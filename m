From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-exploitation-zfcp.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:40 -0700
Message-ID: <200708250518.l7P5Ie2w031899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbXHYFSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, aherrman@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure - exploitation: zfcp
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-exploitation-zfcp.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure - exploitation: zfcp
From: Martin Peschke <mp3@de.ibm.com>

Instrument the zfcp driver and makes it feed statistics data into the
statistics infrastructure.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Andreas Herrmann <aherrman@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/scsi/zfcp_aux.c  |   55 ++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_ccw.c  |   40 +++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h  |   23 +++++++++++++
 drivers/s390/scsi/zfcp_erp.c  |    2 +
 drivers/s390/scsi/zfcp_fsf.c  |   49 +++++++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_fsf.h  |   12 ++++++
 drivers/s390/scsi/zfcp_qdio.c |    4 ++
 7 files changed, 182 insertions(+), 3 deletions(-)

diff -puN drivers/s390/scsi/zfcp_aux.c~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_aux.c
--- a/drivers/s390/scsi/zfcp_aux.c~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_aux.c
@@ -803,6 +803,51 @@ zfcp_get_adapter_by_busid(char *bus_id)
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
@@ -818,6 +863,7 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	struct zfcp_unit *unit, *tmp_unit;
 	unsigned int scsi_lun;
 	int found;
+	char name[64];
 
 	/*
 	 * check that there is no unit with this FCP_LUN already in list
@@ -852,6 +898,14 @@ zfcp_unit_enqueue(struct zfcp_port *port
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
@@ -898,6 +952,7 @@ zfcp_unit_dequeue(struct zfcp_unit *unit
 	write_unlock_irq(&zfcp_data.config_lock);
 	unit->port->units--;
 	zfcp_port_put(unit->port);
+	statistic_remove(&unit->stat_if);
 	zfcp_sysfs_unit_remove_files(&unit->sysfs_device);
 	device_unregister(&unit->sysfs_device);
 }
diff -puN drivers/s390/scsi/zfcp_ccw.c~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_ccw.c
--- a/drivers/s390/scsi/zfcp_ccw.c~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_ccw.c
@@ -132,6 +132,33 @@ zfcp_ccw_remove(struct ccw_device *ccw_d
 	up(&zfcp_data.config_sema);
 }
 
+static struct statistic_info zfcp_statinfo_a[] = {
+	[ZFCP_STAT_A_QOF] = {
+		.name	  = "qdio_outb_full",
+		.x_unit	  = "sbals_left",
+		.y_unit	  = "",
+		.defaults = "type=counter_inc"
+	},
+	[ZFCP_STAT_A_QO] = {
+		.name	  = "qdio_outb",
+		.x_unit	  = "sbals_used",
+		.y_unit	  = "",
+		.defaults = "type=utilisation"
+	},
+	[ZFCP_STAT_A_QI] = {
+		.name	  = "qdio_inb",
+		.x_unit	  = "sbals_used",
+		.y_unit	  = "",
+		.defaults = "type=utilisation"
+	},
+	[ZFCP_STAT_A_ERP] = {
+		.name	  = "erp",
+		.x_unit	  = "",
+		.y_unit	  = "",
+		.defaults = "type=counter_inc"
+	}
+};
+
 /**
  * zfcp_ccw_set_online - set_online function of zfcp driver
  * @ccw_device: pointer to belonging ccw device
@@ -145,6 +172,7 @@ static int
 zfcp_ccw_set_online(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
+	char name[14];
 	int retval;
 
 	down(&zfcp_data.config_sema);
@@ -153,6 +181,15 @@ zfcp_ccw_set_online(struct ccw_device *c
 	retval = zfcp_adapter_debug_register(adapter);
 	if (retval)
 		goto out;
+
+	sprintf(name, "zfcp-%s", zfcp_get_busid_by_adapter(adapter));
+	adapter->stat_if.stat = adapter->stat;
+	adapter->stat_if.info = zfcp_statinfo_a;
+	adapter->stat_if.number = _ZFCP_STAT_A_NUMBER;
+	retval = statistic_create(&adapter->stat_if, name);
+	if (retval)
+		goto out_stat_create;
+
 	retval = zfcp_erp_thread_setup(adapter);
 	if (retval) {
 		ZFCP_LOG_INFO("error: start of error recovery thread for "
@@ -178,6 +215,8 @@ zfcp_ccw_set_online(struct ccw_device *c
  out_scsi_register:
 	zfcp_erp_thread_kill(adapter);
  out_erp_thread:
+	statistic_remove(&adapter->stat_if);
+ out_stat_create:
 	zfcp_adapter_debug_unregister(adapter);
  out:
 	up(&zfcp_data.config_sema);
@@ -201,6 +240,7 @@ zfcp_ccw_set_offline(struct ccw_device *
 	zfcp_erp_adapter_shutdown(adapter, 0);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
+	statistic_remove(&adapter->stat_if);
 	zfcp_adapter_debug_unregister(adapter);
 	up(&zfcp_data.config_sema);
 	return 0;
diff -puN drivers/s390/scsi/zfcp_def.h~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_def.h
--- a/drivers/s390/scsi/zfcp_def.h~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_def.h
@@ -33,6 +33,7 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/mempool.h>
+#include <linux/statistic.h>
 #include <linux/syscalls.h>
 #include <linux/ioctl.h>
 #include <scsi/scsi.h>
@@ -867,6 +868,13 @@ struct zfcp_erp_action {
 	struct timer_list timer;
 };
 
+enum zfcp_adapter_stats {
+	ZFCP_STAT_A_QOF,
+	ZFCP_STAT_A_QO,
+	ZFCP_STAT_A_QI,
+	ZFCP_STAT_A_ERP,
+	_ZFCP_STAT_A_NUMBER,
+};
 
 struct zfcp_adapter {
 	struct list_head	list;              /* list of adapters */
@@ -882,6 +890,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u16			timer_tick_interval; /* for measurement data */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
@@ -933,6 +942,8 @@ struct zfcp_adapter {
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
+	struct statistic_interface stat_if;
+	struct statistic stat[_ZFCP_STAT_A_NUMBER];
 };
 
 /*
@@ -963,6 +974,16 @@ struct zfcp_port {
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
@@ -985,6 +1006,8 @@ struct zfcp_unit {
 						  all scsi_scan_target
 						  requests have been
 						  completed. */
+	struct statistic_interface stat_if;
+	struct statistic stat[_ZFCP_STAT_U_NUMBER];
 };
 
 /* FSF request */
diff -puN drivers/s390/scsi/zfcp_erp.c~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_erp.c
--- a/drivers/s390/scsi/zfcp_erp.c~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_erp.c
@@ -1570,10 +1570,12 @@ zfcp_erp_strategy_check_adapter(struct z
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&adapter->erp_counter, 0);
+		statistic_inc(adapter->stat, ZFCP_STAT_A_ERP, 1);
 		zfcp_erp_adapter_unblock(adapter);
 		break;
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&adapter->erp_counter);
+		statistic_inc(adapter->stat, ZFCP_STAT_A_ERP, -1);
 		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS)
 			zfcp_erp_adapter_failed(adapter);
 		break;
diff -puN drivers/s390/scsi/zfcp_fsf.c~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_fsf.c
@@ -2011,6 +2011,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->adapter_features = bottom->adapter_features;
 	adapter->connection_features = bottom->connection_features;
+	adapter->timer_tick_interval = bottom->timer_tick_interval;
 	adapter->peer_wwpn = 0;
 	adapter->peer_wwnn = 0;
 	adapter->peer_d_id = 0;
@@ -3959,6 +3960,38 @@ zfcp_fsf_send_fcp_command_handler(struct
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
@@ -4027,6 +4060,11 @@ zfcp_fsf_send_fcp_command_task_handler(s
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
@@ -4586,10 +4624,14 @@ zfcp_fsf_req_sbal_get(struct zfcp_adapte
 						       ZFCP_SBAL_TIMEOUT);
 		if (ret < 0)
 			return ret;
-		if (!ret)
+		if (!ret) {
+			statistic_inc(adapter->stat, ZFCP_STAT_A_QOF, 1);
 			return -EIO;
-        } else if (!zfcp_fsf_req_sbal_check(lock_flags, req_queue, 1))
+		}
+        } else if (!zfcp_fsf_req_sbal_check(lock_flags, req_queue, 1)) {
+		statistic_inc(adapter->stat, ZFCP_STAT_A_QOF, 1);
                 return -EIO;
+	}
 
         return 0;
 }
@@ -4754,6 +4796,9 @@ static int zfcp_fsf_req_send(struct zfcp
 	 * position of first one
 	 */
 	atomic_sub(fsf_req->sbal_number, &req_queue->free_count);
+	statistic_inc(adapter->stat, ZFCP_STAT_A_QO,
+		      QDIO_MAX_BUFFERS_PER_Q -
+		      atomic_read(&req_queue->free_count));
 	ZFCP_LOG_TRACE("free_count=%d\n", atomic_read(&req_queue->free_count));
 	req_queue->free_index += fsf_req->sbal_number;	  /* increase */
 	req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q;  /* wrap if needed */
diff -puN drivers/s390/scsi/zfcp_fsf.h~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_fsf.h
--- a/drivers/s390/scsi/zfcp_fsf.h~statistics-infrastructure-exploitation-zfcp
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
diff -puN drivers/s390/scsi/zfcp_qdio.c~statistics-infrastructure-exploitation-zfcp drivers/s390/scsi/zfcp_qdio.c
--- a/drivers/s390/scsi/zfcp_qdio.c~statistics-infrastructure-exploitation-zfcp
+++ a/drivers/s390/scsi/zfcp_qdio.c
@@ -419,6 +419,7 @@ zfcp_qdio_response_handler(struct ccw_de
 	} else {
 		queue->free_index += count;
 		queue->free_index %= QDIO_MAX_BUFFERS_PER_Q;
+		statistic_inc(adapter->stat, ZFCP_STAT_A_QI, count);
 		atomic_set(&queue->free_count, 0);
 		ZFCP_LOG_TRACE("%i buffers enqueued to response "
 			       "queue at position %i\n", count, start);
@@ -618,6 +619,9 @@ zfcp_qdio_sbals_from_segment(struct zfcp
 		/* get next free SBALE for new piece */
 		if (NULL == zfcp_qdio_sbale_next(fsf_req, sbtype)) {
 			/* no SBALE left, clean up and leave */
+			statistic_inc(fsf_req->adapter->stat, ZFCP_STAT_A_QOF,
+				      atomic_read(
+				 &fsf_req->adapter->request_queue.free_count));
 			zfcp_qdio_sbals_wipe(fsf_req);
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from mp3@de.ibm.com are
