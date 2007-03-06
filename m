From: akpm@linux-foundation.org
Subject: - zfcp-gather-hba-specific-latencies-in-statistics.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:09:24 -0800
Message-ID: <200703060209.l2629Psa008955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965740AbXCFCJd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, aherrman@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     zfcp: gather HBA-specific latencies in statistics
has been removed from the -mm tree.  Its filename was
     zfcp-gather-hba-specific-latencies-in-statistics.patch

This patch was dropped because it was folded into statistics-infrastructure-exploitation-zfcp.patch

------------------------------------------------------
Subject: zfcp: gather HBA-specific latencies in statistics
From: Martin Peschke <mp3@de.ibm.com>

Newer versions of the System z FCP HBA (s390 arch) provide additional
measurement data, including a so called 'channel latency' (roughly the time
a request spent in the HBA) and a 'fabric latency' (the time a request
spent outside the System z machine).

This patch allows users to accumulate these latencies - separately for
requests with outbound/inbound/no data transfer - in statistics, that is,
histograms by default.  These statistics are useful when there is a need to
further break down overall latencies as seen by Linux.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Andreas Herrmann <aherrman@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/scsi/zfcp_aux.c |   55 +++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h |   13 +++++++
 drivers/s390/scsi/zfcp_fsf.c |   38 ++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h |   12 ++++++-
 4 files changed, 117 insertions(+), 1 deletion(-)

diff -puN drivers/s390/scsi/zfcp_aux.c~zfcp-gather-hba-specific-latencies-in-statistics drivers/s390/scsi/zfcp_aux.c
--- a/drivers/s390/scsi/zfcp_aux.c~zfcp-gather-hba-specific-latencies-in-statistics
+++ a/drivers/s390/scsi/zfcp_aux.c
@@ -869,6 +869,51 @@ zfcp_get_adapter_by_busid(char *bus_id)
 	return found ? adapter : NULL;
 }
 
+static struct statistic_info zfcp_statinfo_u[] = {
+	[ZFCP_STAT_U_CLW] = {
+		.name	  = "channel_latency_write",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=17 "
+			    "base_interval=1000 range_min=0"
+	},
+	[ZFCP_STAT_U_CLR] = {
+		.name	  = "channel_latency_read",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=17 "
+			    "base_interval=1000 range_min=0"
+	},
+	[ZFCP_STAT_U_CLN] = {
+		.name	  = "channel_latency_nodata",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=17 "
+			    "base_interval=1000 range_min=0"
+	},
+	[ZFCP_STAT_U_FLW] = {
+		.name	  = "fabric_latency_write",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=13 "
+			    "base_interval=1000000 range_min=0"
+	},
+	[ZFCP_STAT_U_FLR] = {
+		.name	  = "fabric_latency_read",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=13 "
+			    "base_interval=1000000 range_min=0"
+	},
+	[ZFCP_STAT_U_FLN] = {
+		.name	  = "fabric_latency_nodata",
+		.x_unit	  = "nanosec",
+		.y_unit	  = "request",
+		.defaults = "type=histogram_log2 entries=13 "
+			    "base_interval=1000000 range_min=0"
+	}
+};
+
 /**
  * zfcp_unit_enqueue - enqueue unit to unit list of a port.
  * @port: pointer to port where unit is added
@@ -884,6 +929,7 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	struct zfcp_unit *unit, *tmp_unit;
 	unsigned int scsi_lun;
 	int found;
+	char name[64];
 
 	/*
 	 * check that there is no unit with this FCP_LUN already in list
@@ -916,6 +962,14 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	/* mark unit unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 
+	sprintf(name, "zfcp-%s-0x%016Lx-0x%016Lx",
+		zfcp_get_busid_by_unit(unit), port->wwpn, fcp_lun);
+	unit->stat_if.stat = unit->stat;
+	unit->stat_if.info = zfcp_statinfo_u;
+	unit->stat_if.number = _ZFCP_STAT_U_NUMBER;
+	if (statistic_create(&unit->stat_if, name))
+		printk("statistics are unavailable (%s)\n", name);
+
 	if (device_register(&unit->sysfs_device)) {
 		kfree(unit);
 		return NULL;
@@ -962,6 +1016,7 @@ zfcp_unit_dequeue(struct zfcp_unit *unit
 	write_unlock_irq(&zfcp_data.config_lock);
 	unit->port->units--;
 	zfcp_port_put(unit->port);
+	statistic_remove(&unit->stat_if);
 	zfcp_sysfs_unit_remove_files(&unit->sysfs_device);
 	device_unregister(&unit->sysfs_device);
 }
diff -puN drivers/s390/scsi/zfcp_def.h~zfcp-gather-hba-specific-latencies-in-statistics drivers/s390/scsi/zfcp_def.h
--- a/drivers/s390/scsi/zfcp_def.h~zfcp-gather-hba-specific-latencies-in-statistics
+++ a/drivers/s390/scsi/zfcp_def.h
@@ -889,6 +889,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u16			timer_tick_interval; /* for measurement data */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
@@ -972,6 +973,16 @@ struct zfcp_port {
 	u32                    supported_classes;
 };
 
+enum zfcp_unit_stats {
+	ZFCP_STAT_U_CLW,
+	ZFCP_STAT_U_CLR,
+	ZFCP_STAT_U_CLN,
+	ZFCP_STAT_U_FLW,
+	ZFCP_STAT_U_FLR,
+	ZFCP_STAT_U_FLN,
+	_ZFCP_STAT_U_NUMBER,
+};
+
 /* the struct device sysfs_device must be at the beginning of this structure.
  * pointer to struct device is used to free unit structure in release function
  * of the device. don't change!
@@ -990,6 +1001,8 @@ struct zfcp_unit {
         struct scsi_device     *device;        /* scsi device struct pointer */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
+	struct statistic_interface stat_if;
+	struct statistic stat[_ZFCP_STAT_U_NUMBER];
 };
 
 /* FSF request */
diff -puN drivers/s390/scsi/zfcp_fsf.c~zfcp-gather-hba-specific-latencies-in-statistics drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c~zfcp-gather-hba-specific-latencies-in-statistics
+++ a/drivers/s390/scsi/zfcp_fsf.c
@@ -2023,6 +2023,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->adapter_features = bottom->adapter_features;
 	adapter->connection_features = bottom->connection_features;
+	adapter->timer_tick_interval = bottom->timer_tick_interval;
 	adapter->peer_wwpn = 0;
 	adapter->peer_wwnn = 0;
 	adapter->peer_d_id = 0;
@@ -3970,6 +3971,38 @@ zfcp_fsf_send_fcp_command_handler(struct
 	return retval;
 }
 
+#ifdef CONFIG_STATISTICS
+static void zfcp_fsf_sfc_stat(struct zfcp_fsf_req *fsf_req,
+			      struct scsi_cmnd *cmd)
+{
+	struct zfcp_adapter *adapter = fsf_req->unit->port->adapter;
+	struct statistic *stat = fsf_req->unit->stat;
+	struct fsf_measurement_data *data;
+	s64 channel_latency, fabric_latency;
+	unsigned long flags;
+
+	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
+		return;
+
+	data = &fsf_req->qtcb->prefix.prot_status_qual.measurement_data;
+	channel_latency = data->channel_latency * adapter->timer_tick_interval;
+	fabric_latency = data->fabric_latency * adapter->timer_tick_interval;
+
+	local_irq_save(flags);
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		_statistic_inc(stat, ZFCP_STAT_U_CLW, channel_latency);
+		_statistic_inc(stat, ZFCP_STAT_U_FLW, fabric_latency);
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		_statistic_inc(stat, ZFCP_STAT_U_CLR, channel_latency);
+		_statistic_inc(stat, ZFCP_STAT_U_FLR, fabric_latency);
+	} else if (cmd->sc_data_direction == DMA_NONE) {
+		_statistic_inc(stat, ZFCP_STAT_U_CLN, channel_latency);
+		_statistic_inc(stat, ZFCP_STAT_U_FLN, fabric_latency);
+	}
+	local_irq_restore(flags);
+}
+#endif
+
 /*
  * function:    zfcp_fsf_send_fcp_command_task_handler
  *
@@ -4038,6 +4071,11 @@ zfcp_fsf_send_fcp_command_task_handler(s
 			      fcp_rsp_iu->fcp_sns_len);
 	}
 
+	/* we get hba measurement data regardless of the scsi status */
+#ifdef CONFIG_STATISTICS
+	zfcp_fsf_sfc_stat(fsf_req, scpnt);
+#endif
+
 	/* check FCP_RSP_INFO */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
 		ZFCP_LOG_DEBUG("rsp_len is valid\n");
diff -puN drivers/s390/scsi/zfcp_fsf.h~zfcp-gather-hba-specific-latencies-in-statistics drivers/s390/scsi/zfcp_fsf.h
--- a/drivers/s390/scsi/zfcp_fsf.h~zfcp-gather-hba-specific-latencies-in-statistics
+++ a/drivers/s390/scsi/zfcp_fsf.h
@@ -213,6 +213,7 @@
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
+#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
@@ -322,11 +323,18 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
+struct fsf_measurement_data {
+	u32 channel_latency;
+	u32 fabric_latency;
+	u8 res1[8];
+} __attribute__ ((packed));
+
 union fsf_prot_status_qual {
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
 	struct fsf_link_down_info link_down_info;
+	struct fsf_measurement_data measurement_data;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_prefix {
@@ -427,7 +435,9 @@ struct fsf_qtcb_bottom_config {
 	u32 fc_link_speed;
 	u32 adapter_type;
 	u32 peer_d_id;
-	u8 res2[12];
+	u16 status_read_buf_num;
+	u16 timer_tick_interval;
+	u8 res2[8];
 	u32 s_id;
 	struct fsf_nport_serv_param nport_serv_param;
 	u8 reserved_nport_serv_param[16];
_

Patches currently in -mm which might be from mp3@de.ibm.com are

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-exploitation-zfcp.patch
zfcp-gather-hba-specific-latencies-in-statistics.patch
