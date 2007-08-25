From: akpm@linux-foundation.org
Subject: - git-scsi-target.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:27:51 -0700
Message-ID: <200708250327.l7P3RpB5028163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXHYDiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@SteelEye.com, brking@us.ibm.com, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     git-scsi-target.patch
has been removed from the -mm tree.  Its filename was
     git-scsi-target.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-scsi-target.patch

GIT 4bfa261787ee2b72447055d697cc30afbe273b37 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-target.git

commit 
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Thu Aug 2 00:20:34 2007 +0900

    scsi_transport_srp: remove tgt dependencies
    
    it's better to remove tgt dependencies in srp transport class since
    most people want only initiator support.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit aaa3e02728aec2045810ff446de95a5bf81284cf
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:24 2007 +0900

    tgt: convert ibmvstgt to use transport tsk_mgmt_response callback
    
    This converts ibmvstgt to use transport tsk_mgmt_response callback.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit acb6e7595f6fd137ade0ce382895c7cd9a1423b5
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:22 2007 +0900

    tgt: move tsk_mgmt_response callback to transport class
    
    This moves tsk_mgmt_response callback in struct scsi_host_template to
    struct scsi_transport_template since struct scsi_transport_template is
    more suitable for the task management stuff.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit f5aef514e8dafff00ef5ea26d450f92ea3a0b5d4
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:21 2007 +0900

    tgt: convert libsrp and ibmvstgt to use srp_transport
    
    This converts libsrp and ibmvstgt to use srp transport.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Acked-by: Brian King <brking@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 297c87b606202064d2ca995a16f44b27c7750f66
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:19 2007 +0900

    srp_transport: add target driver support
    
    This adds minimum target driver support:
    
    - srp_rport_{add,del} calls scsi_tgt_it_nexus_{create,destroy} for
    target drivers.
    
    - add a callback to notify target drivers of the nexus operation
    results to srp_function_template.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 2f7467fbd77fe8584252c88c62447ac1f886de60
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:17 2007 +0900

    tgt: add I_T nexus support
    
    tgt uses scsi_host as I_T nexus. This works for ibmvstgt because it
    creates one scsi_host for one initiator. However, other target drivers
    don't work like that.
    
    This adds I_T nexus support, which enable one scsi_host to handle
    multiple initiators. New scsi_tgt_it_nexus_create/destroy functions
    are expected be called transport classes. For example, ibmvstgt
    creates an initiator remote port, then the srp transport calls
    tgt_it_nexus_create. tgt doesn't manages I_T nexus, instead it tells
    tgtd, user-space daemon, to create a new I_T nexus.
    
    On the receiving the response from tgtd, tgt calls
    shost->transportt->it_nexus_response. transports should notify a
    lld. The srp transport uses it_nexus_response callback in
    srp_function_template to do that.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 12dbb339b85d8b13bae88e1a354c825f71737be6
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Wed Jul 11 15:08:15 2007 +0900

    transport_srp: add rport roles attribute
    
    This adds a 'roles' attribute to rport like transport_fc. The role can
    be initiator or target. That is, the initiator driver creates target
    remote ports and the target driver creates initiator remote ports.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit f4a79017b1fc34af106764faba73b1d7a42c3880
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Jun 27 16:33:12 2007 +0900

    ib_srp: convert to use the srp transport class
    
    This converts ib_srp to use the srp transport class.
    
    I don't have ib hardware so I've not tested this patch.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Cc: Roland Dreier <rolandd@cisco.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 622fdb4c0f09ea8e0390ba2681d9ab6385818c99
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Jun 27 16:32:50 2007 +0900

    ibmvscsi: convert to use the srp transport class
    
    This converts ibmvscsi to use the srp transport class.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Acked-by: Brian King <brking@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 87b61af72b5a6ecfcb8303c2749c7f9c3ca69948
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Jun 27 16:32:39 2007 +0900

    add srp transport class
    
    This adds srp transport class that works with ib_srp and ibmvscsi.
    
    It creates only /sys/class/{srp_host,srp_remote_ports} and
    srp_remote_ports has only "port_id" attribute.
    
    viola:/sys/class/srp_remote_ports/port-0:1# ls
    device  port_id  subsystem  uevent
    viola:/sys/class/srp_remote_ports/port-0:1# cat port_id
    4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
 drivers/infiniband/ulp/srp/Kconfig         |    1 
 drivers/infiniband/ulp/srp/ib_srp.c        |   28 ++
 drivers/scsi/Kconfig                       |   17 +
 drivers/scsi/Makefile                      |    1 
 drivers/scsi/ibmvscsi/ibmvscsi.c           |   35 ++-
 drivers/scsi/ibmvscsi/ibmvstgt.c           |   60 ++++
 drivers/scsi/libsrp.c                      |    5 
 drivers/scsi/scsi_tgt_if.c                 |   42 +++
 drivers/scsi/scsi_tgt_lib.c                |   83 +++++-
 drivers/scsi/scsi_tgt_priv.h               |   22 +-
 drivers/scsi/scsi_transport_srp.c          |  379 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_srp_internal.h |   25 ++
 include/scsi/libsrp.h                      |    2 
 include/scsi/scsi_host.h                   |    3 
 include/scsi/scsi_tgt.h                    |    8 -
 include/scsi/scsi_tgt_if.h                 |   35 ++-
 include/scsi/scsi_transport.h              |   12 +
 include/scsi/scsi_transport_srp.h          |   39 +++
 18 files changed, 745 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/Kconfig b/drivers/infiniband/ulp/srp/Kconfig
index 3432dce..c74ee96 100644
--- a/drivers/infiniband/ulp/srp/Kconfig
+++ b/drivers/infiniband/ulp/srp/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_SRP
 	tristate "InfiniBand SCSI RDMA Protocol"
 	depends on SCSI
+	select SCSI_SRP_ATTRS
 	---help---
 	  Support for the SCSI RDMA Protocol over InfiniBand.  This
 	  allows you to access storage devices that speak SRP over
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f6a0514..24c8037 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -47,6 +47,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/srp.h>
+#include <scsi/scsi_transport_srp.h>
 
 #include <rdma/ib_cache.h>
 
@@ -86,6 +87,8 @@ static void srp_remove_one(struct ib_dev
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
+static struct scsi_transport_template *ib_srp_transport_template;
+
 static struct ib_client srp_client = {
 	.name   = "srp",
 	.add    = srp_add_one,
@@ -419,6 +422,7 @@ static void srp_remove_work(struct work_
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
+	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
@@ -1543,12 +1547,24 @@ static struct scsi_host_template srp_tem
 
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 {
+	struct srp_rport_identifiers ids;
+	struct srp_rport *rport;
+
 	sprintf(target->target_name, "SRP.T10:%016llX",
 		 (unsigned long long) be64_to_cpu(target->id_ext));
 
 	if (scsi_add_host(target->scsi_host, host->dev->dev->dma_device))
 		return -ENODEV;
 
+	memcpy(ids.port_id, &target->id_ext, 8);
+	memcpy(ids.port_id + 8, &target->ioc_guid, 8);
+	ids.roles = SRP_RPORT_ROLE_TARGET;
+	rport = srp_rport_add(target->scsi_host, &ids);
+	if (IS_ERR(rport)) {
+		scsi_remove_host(target->scsi_host);
+		return PTR_ERR(rport);
+	}
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
@@ -1773,6 +1789,7 @@ static ssize_t srp_create_target(struct 
 	if (!target_host)
 		return -ENOMEM;
 
+	target_host->transportt = ib_srp_transport_template;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 
@@ -2052,10 +2069,18 @@ static void srp_remove_one(struct ib_dev
 	kfree(srp_dev);
 }
 
+static struct srp_function_template ib_srp_transport_functions = {
+};
+
 static int __init srp_init_module(void)
 {
 	int ret;
 
+	ib_srp_transport_template =
+		srp_attach_transport(&ib_srp_transport_functions);
+	if (!ib_srp_transport_template)
+		return -ENOMEM;
+
 	srp_template.sg_tablesize = srp_sg_tablesize;
 	srp_max_iu_len = (sizeof (struct srp_cmd) +
 			  sizeof (struct srp_indirect_buf) +
@@ -2064,6 +2089,7 @@ static int __init srp_init_module(void)
 	ret = class_register(&srp_class);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
+		srp_release_transport(ib_srp_transport_template);
 		return ret;
 	}
 
@@ -2072,6 +2098,7 @@ static int __init srp_init_module(void)
 	ret = ib_register_client(&srp_client);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register IB client\n");
+		srp_release_transport(ib_srp_transport_template);
 		ib_sa_unregister_client(&srp_sa_client);
 		class_unregister(&srp_class);
 		return ret;
@@ -2085,6 +2112,7 @@ static void __exit srp_cleanup_module(vo
 	ib_unregister_client(&srp_client);
 	ib_sa_unregister_client(&srp_sa_client);
 	class_unregister(&srp_class);
+	srp_release_transport(ib_srp_transport_template);
 }
 
 module_init(srp_init_module);
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6f2c71e..d4fd234 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -289,6 +289,20 @@ config SCSI_SAS_ATTRS
 
 source "drivers/scsi/libsas/Kconfig"
 
+config SCSI_SRP_ATTRS
+	tristate "SRP Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SRP device to sysfs, say Y.
+
+config SCSI_SRP_TGT_ATTRS
+	bool "SCSI target support for SRP Transport Attributes"
+	depends on SCSI_SRP_ATTRS
+	depends on SCSI_TGT = y || SCSI_TGT = SCSI_SRP_ATTRS
+	help
+		If you want to use SCSI target mode drivers enable this option.
+
 endmenu
 
 menuconfig SCSI_LOWLEVEL
@@ -836,6 +850,7 @@ config SCSI_IPS
 config SCSI_IBMVSCSI
 	tristate "IBM Virtual SCSI support"
 	depends on PPC_PSERIES || PPC_ISERIES
+	select SCSI_SRP_ATTRS
 	help
 	  This is the IBM POWER Virtual SCSI Client
 
@@ -844,7 +859,7 @@ config SCSI_IBMVSCSI
 
 config SCSI_IBMVSCSIS
 	tristate "IBM Virtual SCSI Server support"
-	depends on PPC_PSERIES && SCSI_TGT && SCSI_SRP
+	depends on PPC_PSERIES && SCSI_SRP && SCSI_SRP_TGT_ATTRS
 	help
 	  This is the SRP target driver for IBM pSeries virtual environments.
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 86a7ba7..6141389 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_tra
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
+obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 5ecc63d..93bd01b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -75,6 +75,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_srp.h>
 #include "ibmvscsi.h"
 
 /* The values below are somewhat arbitrary default values, but 
@@ -87,6 +88,8 @@ static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 
+static struct scsi_transport_template *ibmvscsi_transport_template;
+
 #define IBMVSCSI_VERSION "1.5.8"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
@@ -1553,6 +1556,8 @@ static int ibmvscsi_probe(struct vio_dev
 	struct ibmvscsi_host_data *hostdata;
 	struct Scsi_Host *host;
 	struct device *dev = &vdev->dev;
+	struct srp_rport_identifiers ids;
+	struct srp_rport *rport;
 	unsigned long wait_switch = 0;
 	int rc;
 
@@ -1565,6 +1570,7 @@ static int ibmvscsi_probe(struct vio_dev
 		goto scsi_host_alloc_failed;
 	}
 
+	host->transportt = ibmvscsi_transport_template;
 	hostdata = shost_priv(host);
 	memset(hostdata, 0x00, sizeof(*hostdata));
 	INIT_LIST_HEAD(&hostdata->sent);
@@ -1590,6 +1596,14 @@ static int ibmvscsi_probe(struct vio_dev
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
 
+	/* we don't have a proper target_port_id so let's use the fake one */
+	memcpy(ids.port_id, hostdata->madapter_info.partition_name,
+	       sizeof(ids.port_id));
+	ids.roles = SRP_RPORT_ROLE_TARGET;
+	rport = srp_rport_add(host, &ids);
+	if (IS_ERR(rport))
+		goto add_srp_port_failed;
+
 	/* Try to send an initialization message.  Note that this is allowed
 	 * to fail if the other end is not acive.  In that case we don't
 	 * want to scan
@@ -1617,6 +1631,8 @@ static int ibmvscsi_probe(struct vio_dev
 	vdev->dev.driver_data = hostdata;
 	return 0;
 
+      add_srp_port_failed:
+	scsi_remove_host(hostdata->host);
       add_host_failed:
 	release_event_pool(&hostdata->pool, hostdata);
       init_pool_failed:
@@ -1633,7 +1649,8 @@ static int ibmvscsi_remove(struct vio_de
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 				   max_requests);
-	
+
+	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
 	scsi_host_put(hostdata->host);
 
@@ -1660,14 +1677,28 @@ static struct vio_driver ibmvscsi_driver
 	}
 };
 
+static struct srp_function_template ibmvscsi_transport_functions = {
+};
+
 int __init ibmvscsi_module_init(void)
 {
-	return vio_register_driver(&ibmvscsi_driver);
+	int ret;
+
+	ibmvscsi_transport_template =
+		srp_attach_transport(&ibmvscsi_transport_functions);
+	if (!ibmvscsi_transport_template)
+		return -ENOMEM;
+
+	ret = vio_register_driver(&ibmvscsi_driver);
+	if (ret)
+		srp_release_transport(ibmvscsi_transport_template);
+	return ret;
 }
 
 void __exit ibmvscsi_module_exit(void)
 {
 	vio_unregister_driver(&ibmvscsi_driver);
+	srp_release_transport(ibmvscsi_transport_template);
 }
 
 module_init(ibmvscsi_module_init);
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 8ba7dd0..3db03dd 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -25,6 +25,7 @@ #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_srp.h>
 #include <scsi/scsi_tgt.h>
 #include <scsi/libsrp.h>
 #include <asm/hvcall.h>
@@ -68,9 +69,12 @@ struct vio_port {
 	unsigned long liobn;
 	unsigned long riobn;
 	struct srp_target *target;
+
+	struct srp_rport *rport;
 };
 
 static struct workqueue_struct *vtgtd;
+static struct scsi_transport_template *ibmvstgt_transport_template;
 
 /*
  * These are fixed for the system and come from the Open Firmware device tree.
@@ -188,6 +192,7 @@ static int send_rsp(struct iu_entry *iue
 static void handle_cmd_queue(struct srp_target *target)
 {
 	struct Scsi_Host *shost = target->shost;
+	struct srp_rport *rport = target_to_port(target)->rport;
 	struct iu_entry *iue;
 	struct srp_cmd *cmd;
 	unsigned long flags;
@@ -200,7 +205,8 @@ retry:
 		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
 			spin_unlock_irqrestore(&target->lock, flags);
 			cmd = iue->sbuf->buf;
-			err = srp_cmd_queue(shost, cmd, iue, 0);
+			err = srp_cmd_queue(shost, cmd, iue,
+					    (unsigned long)rport, 0);
 			if (err) {
 				eprintk("cannot queue cmd %p %d\n", cmd, err);
 				srp_iu_put(iue);
@@ -359,6 +365,16 @@ static void process_login(struct iu_entr
 	union viosrp_iu *iu = vio_iu(iue);
 	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
 	uint64_t tag = iu->srp.rsp.tag;
+	struct Scsi_Host *shost = iue->target->shost;
+	struct srp_target *target = host_to_srp_target(shost);
+	struct vio_port *vport = target_to_port(target);
+	struct srp_rport_identifiers ids;
+
+	memset(&ids, 0, sizeof(ids));
+	sprintf(ids.port_id, "%x", vport->dma_dev->unit_address);
+	ids.roles = SRP_RPORT_ROLE_INITIATOR;
+	if (!vport->rport)
+		vport->rport = srp_rport_add(shost, &ids);
 
 	/* TODO handle case that requested size is wrong and
 	 * buffer format is wrong
@@ -412,7 +428,9 @@ static int process_tsk_mgmt(struct iu_en
 		fn = 0;
 	}
 	if (fn)
-		scsi_tgt_tsk_mgmt_request(iue->target->shost, fn,
+		scsi_tgt_tsk_mgmt_request(iue->target->shost,
+					  (unsigned long)iue->target->shost,
+					  fn,
 					  iu->srp.tsk_mgmt.task_tag,
 					  (struct scsi_lun *) &iu->srp.tsk_mgmt.lun,
 					  iue);
@@ -721,7 +739,8 @@ static int ibmvstgt_eh_abort_handler(str
 	return 0;
 }
 
-static int ibmvstgt_tsk_mgmt_response(u64 mid, int result)
+static int ibmvstgt_tsk_mgmt_response(struct Scsi_Host *shost,
+				      u64 itn_id, u64 mid, int result)
 {
 	struct iu_entry *iue = (struct iu_entry *) ((void *) mid);
 	union viosrp_iu *iu = vio_iu(iue);
@@ -747,6 +766,20 @@ static int ibmvstgt_tsk_mgmt_response(u6
 	return 0;
 }
 
+static int ibmvstgt_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
+				      int result)
+{
+	struct srp_target *target = host_to_srp_target(shost);
+	struct vio_port *vport = target_to_port(target);
+
+	if (result) {
+		eprintk("%p %d\n", shost, result);
+		srp_rport_del(vport->rport);
+		vport->rport = NULL;
+	}
+	return 0;
+}
+
 static ssize_t system_id_show(struct class_device *cdev, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", system_id);
@@ -785,7 +818,6 @@ static struct scsi_host_template ibmvstg
 	.max_sectors		= DEFAULT_MAX_SECTORS,
 	.transfer_response	= ibmvstgt_cmd_done,
 	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
-	.tsk_mgmt_response	= ibmvstgt_tsk_mgmt_response,
 	.shost_attrs		= ibmvstgt_attrs,
 	.proc_name		= TGT_NAME,
 };
@@ -804,6 +836,7 @@ static int ibmvstgt_probe(struct vio_dev
 	shost = scsi_host_alloc(&ibmvstgt_sht, sizeof(struct srp_target));
 	if (!shost)
 		goto free_vport;
+	shost->transportt = ibmvstgt_transport_template;
 	err = scsi_tgt_alloc_queue(shost);
 	if (err)
 		goto put_host;
@@ -837,8 +870,8 @@ static int ibmvstgt_probe(struct vio_dev
 	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto destroy_queue;
-	return 0;
 
+	return 0;
 destroy_queue:
 	crq_queue_destroy(target);
 free_srp_target:
@@ -857,6 +890,7 @@ static int ibmvstgt_remove(struct vio_de
 	struct vio_port *vport = target->ldata;
 
 	crq_queue_destroy(target);
+	srp_remove_host(shost);
 	scsi_remove_host(shost);
 	scsi_tgt_free_queue(shost);
 	srp_target_free(target);
@@ -909,15 +943,25 @@ static int get_system_info(void)
 	return 0;
 }
 
+static struct srp_function_template ibmvstgt_transport_functions = {
+	.tsk_mgmt_response = ibmvstgt_tsk_mgmt_response,
+	.it_nexus_response = ibmvstgt_it_nexus_response,
+};
+
 static int ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
 	printk("IBM eServer i/pSeries Virtual SCSI Target Driver\n");
 
+	ibmvstgt_transport_template =
+		srp_attach_transport(&ibmvstgt_transport_functions);
+	if (!ibmvstgt_transport_template)
+		return err;
+
 	vtgtd = create_workqueue("ibmvtgtd");
 	if (!vtgtd)
-		return err;
+		goto release_transport;
 
 	err = get_system_info();
 	if (err)
@@ -928,9 +972,10 @@ static int ibmvstgt_init(void)
 		goto destroy_wq;
 
 	return 0;
-
 destroy_wq:
 	destroy_workqueue(vtgtd);
+release_transport:
+	srp_release_transport(ibmvstgt_transport_template);
 	return err;
 }
 
@@ -940,6 +985,7 @@ static void ibmvstgt_exit(void)
 
 	destroy_workqueue(vtgtd);
 	vio_unregister_driver(&ibmvstgt_driver);
+	srp_release_transport(ibmvstgt_transport_template);
 }
 
 MODULE_DESCRIPTION("IBM Virtual SCSI Target");
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 732446e..2ad0a27 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -392,7 +392,7 @@ static int vscsis_data_length(struct srp
 }
 
 int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
-		  u64 addr)
+		  u64 itn_id, u64 addr)
 {
 	enum dma_data_direction dir;
 	struct scsi_cmnd *sc;
@@ -428,7 +428,8 @@ int srp_cmd_queue(struct Scsi_Host *shos
 	sc->request_bufflen = len;
 	sc->request_buffer = (void *) (unsigned long) addr;
 	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, (struct scsi_lun *) &cmd->lun, cmd->tag);
+	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
+				     cmd->tag);
 	if (err)
 		scsi_host_put_command(shost, sc);
 
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index ca22ddf..9815a1a 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -102,7 +102,8 @@ static int tgt_uspace_send_event(u32 typ
 	return 0;
 }
 
-int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun, u64 tag)
+int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 itn_id,
+			     struct scsi_lun *lun, u64 tag)
 {
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	struct tgt_event ev;
@@ -110,6 +111,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_req.host_no = shost->host_no;
+	ev.p.cmd_req.itn_id = itn_id;
 	ev.p.cmd_req.data_len = cmd->request_bufflen;
 	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
 	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
@@ -127,7 +129,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi
 	return err;
 }
 
-int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag)
+int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 itn_id, u64 tag)
 {
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	struct tgt_event ev;
@@ -135,6 +137,7 @@ int scsi_tgt_uspace_send_status(struct s
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_done.host_no = shost->host_no;
+	ev.p.cmd_done.itn_id = itn_id;
 	ev.p.cmd_done.tag = tag;
 	ev.p.cmd_done.result = cmd->result;
 
@@ -149,14 +152,15 @@ int scsi_tgt_uspace_send_status(struct s
 	return err;
 }
 
-int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
-				  struct scsi_lun *scsilun, void *data)
+int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 itn_id, int function,
+				  u64 tag, struct scsi_lun *scsilun, void *data)
 {
 	struct tgt_event ev;
 	int err;
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.tsk_mgmt_req.host_no = host_no;
+	ev.p.tsk_mgmt_req.itn_id = itn_id;
 	ev.p.tsk_mgmt_req.function = function;
 	ev.p.tsk_mgmt_req.tag = tag;
 	memcpy(ev.p.tsk_mgmt_req.lun, scsilun, sizeof(ev.p.tsk_mgmt_req.lun));
@@ -172,6 +176,29 @@ int scsi_tgt_uspace_send_tsk_mgmt(int ho
 	return err;
 }
 
+int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 itn_id,
+					  int function, char *initiator_id)
+{
+	struct tgt_event ev;
+	int err;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.p.it_nexus_req.host_no = host_no;
+	ev.p.it_nexus_req.function = function;
+	ev.p.it_nexus_req.itn_id = itn_id;
+	if (initiator_id)
+		strncpy(ev.p.it_nexus_req.initiator_id, initiator_id,
+			sizeof(ev.p.it_nexus_req.initiator_id));
+
+	dprintk("%d %x %llx\n", host_no, function, (unsigned long long)itn_id);
+
+	err = tgt_uspace_send_event(TGT_KEVENT_IT_NEXUS_REQ, &ev);
+	if (err)
+		eprintk("tx buf is full, could not send\n");
+
+	return err;
+}
+
 static int event_recv_msg(struct tgt_event *ev)
 {
 	int err = 0;
@@ -179,6 +206,7 @@ static int event_recv_msg(struct tgt_eve
 	switch (ev->hdr.type) {
 	case TGT_UEVENT_CMD_RSP:
 		err = scsi_tgt_kspace_exec(ev->p.cmd_rsp.host_no,
+					   ev->p.cmd_rsp.itn_id,
 					   ev->p.cmd_rsp.result,
 					   ev->p.cmd_rsp.tag,
 					   ev->p.cmd_rsp.uaddr,
@@ -189,9 +217,15 @@ static int event_recv_msg(struct tgt_eve
 		break;
 	case TGT_UEVENT_TSK_MGMT_RSP:
 		err = scsi_tgt_kspace_tsk_mgmt(ev->p.tsk_mgmt_rsp.host_no,
+					       ev->p.tsk_mgmt_rsp.itn_id,
 					       ev->p.tsk_mgmt_rsp.mid,
 					       ev->p.tsk_mgmt_rsp.result);
 		break;
+	case TGT_UEVENT_IT_NEXUS_RSP:
+		err = scsi_tgt_kspace_it_nexus_rsp(ev->p.it_nexus_rsp.host_no,
+						   ev->p.it_nexus_rsp.itn_id,
+						   ev->p.it_nexus_rsp.result);
+		break;
 	default:
 		eprintk("unknown type %d\n", ev->hdr.type);
 		err = -EINVAL;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 371b69c..5851c8e 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -27,6 +27,7 @@ #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_tgt.h>
 
 #include "scsi_tgt_priv.h"
@@ -46,6 +47,7 @@ struct scsi_tgt_cmd {
 
 	struct list_head hash_list;
 	struct request *rq;
+	u64 itn_id;
 	u64 tag;
 };
 
@@ -185,12 +187,13 @@ static void scsi_tgt_cmd_destroy(struct 
 }
 
 static void init_scsi_tgt_cmd(struct request *rq, struct scsi_tgt_cmd *tcmd,
-			      u64 tag)
+			      u64 itn_id, u64 tag)
 {
 	struct scsi_tgt_queuedata *qdata = rq->q->queuedata;
 	unsigned long flags;
 	struct list_head *head;
 
+	tcmd->itn_id = itn_id;
 	tcmd->tag = tag;
 	tcmd->bio = NULL;
 	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy);
@@ -301,14 +304,14 @@ EXPORT_SYMBOL_GPL(scsi_tgt_cmd_to_host);
  * @scsilun:	scsi lun
  * @tag:	unique value to identify this command for tmf
  */
-int scsi_tgt_queue_command(struct scsi_cmnd *cmd, struct scsi_lun *scsilun,
-			   u64 tag)
+int scsi_tgt_queue_command(struct scsi_cmnd *cmd, u64 itn_id,
+			   struct scsi_lun *scsilun, u64 tag)
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
 	int err;
 
-	init_scsi_tgt_cmd(cmd->request, tcmd, tag);
-	err = scsi_tgt_uspace_send_cmd(cmd, scsilun, tag);
+	init_scsi_tgt_cmd(cmd->request, tcmd, itn_id, tag);
+	err = scsi_tgt_uspace_send_cmd(cmd, itn_id, scsilun, tag);
 	if (err)
 		cmd_hashlist_del(cmd);
 
@@ -326,7 +329,7 @@ static void scsi_tgt_cmd_done(struct scs
 
 	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
 
-	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
+	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
 	if (cmd->request_buffer)
 		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
@@ -459,7 +462,7 @@ static struct request *tgt_cmd_hash_look
 	return rq;
 }
 
-int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
+int scsi_tgt_kspace_exec(int host_no, u64 itn_id, int result, u64 tag,
 			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
 			 u32 sense_len, u8 rw)
 {
@@ -541,21 +544,22 @@ done:
 	return err;
 }
 
-int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, int function, u64 tag,
-			      struct scsi_lun *scsilun, void *data)
+int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, u64 itn_id,
+			      int function, u64 tag, struct scsi_lun *scsilun,
+			      void *data)
 {
 	int err;
 
 	/* TODO: need to retry if this fails. */
-	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, function,
-					    tag, scsilun, data);
+	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, itn_id,
+					    function, tag, scsilun, data);
 	if (err < 0)
 		eprintk("The task management request lost!\n");
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_tgt_tsk_mgmt_request);
 
-int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result)
+int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 itn_id, u64 mid, int result)
 {
 	struct Scsi_Host *shost;
 	int err = -EINVAL;
@@ -573,7 +577,60 @@ int scsi_tgt_kspace_tsk_mgmt(int host_no
 		goto done;
 	}
 
-	err = shost->hostt->tsk_mgmt_response(mid, result);
+	err = shost->transportt->tsk_mgmt_response(shost, itn_id, mid, result);
+done:
+	scsi_host_put(shost);
+	return err;
+}
+
+int scsi_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+			     char *initiator)
+{
+	int err;
+
+	/* TODO: need to retry if this fails. */
+	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no, itn_id, 0,
+						    initiator);
+	if (err < 0)
+		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+			shost->host_no, (unsigned long long)itn_id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_create);
+
+int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	int err;
+
+	/* TODO: need to retry if this fails. */
+	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no,
+						    itn_id, 1, NULL);
+	if (err < 0)
+		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+			shost->host_no, (unsigned long long)itn_id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_it_nexus_destroy);
+
+int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 itn_id, int result)
+{
+	struct Scsi_Host *shost;
+	int err = -EINVAL;
+
+	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
+
+	shost = scsi_host_lookup(host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "Could not find host no %d\n", host_no);
+		return err;
+	}
+
+	if (!shost->uspace_req_q) {
+		printk(KERN_ERR "Not target scsi host %d\n", host_no);
+		goto done;
+	}
+
+	err = shost->transportt->it_nexus_response(shost, itn_id, result);
 done:
 	scsi_host_put(shost);
 	return err;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index e9e6db1..cb92888 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -15,12 +15,18 @@ #define dprintk(fmt, args...)
 extern void scsi_tgt_if_exit(void);
 extern int scsi_tgt_if_init(void);
 
-extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun,
-				    u64 tag);
-extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag);
-extern int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
-				unsigned long uaddr, u32 len, unsigned long sense_uaddr,
-				u32 sense_len, u8 rw);
-extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
+extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 it_nexus_id,
+				    struct scsi_lun *lun, u64 tag);
+extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 it_nexus_id,
+				       u64 tag);
+extern int scsi_tgt_kspace_exec(int host_no, u64 it_nexus_id, int result, u64 tag,
+				unsigned long uaddr, u32 len,
+				unsigned long sense_uaddr, u32 sense_len, u8 rw);
+extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, u64 it_nexus_id,
+					 int function, u64 tag,
 					 struct scsi_lun *scsilun, void *data);
-extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result);
+extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 it_nexus_id,
+				    u64 mid, int result);
+extern int scsi_tgt_uspace_send_it_nexus_request(int host_no, u64 it_nexus_id,
+						 int function, char *initiator);
+extern int scsi_tgt_kspace_it_nexus_rsp(int host_no, u64 it_nexus_id, int result);
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
new file mode 100644
index 0000000..430501e
--- /dev/null
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -0,0 +1,379 @@
+/*
+ * SCSI RDMA (SRP) transport class
+ *
+ * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_srp.h>
+#include "scsi_transport_srp_internal.h"
+
+struct srp_host_attrs {
+	atomic_t next_port_id;
+};
+#define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
+
+#define SRP_HOST_ATTRS 0
+#define SRP_RPORT_ATTRS 2
+
+struct srp_internal {
+	struct scsi_transport_template t;
+	struct srp_function_template *f;
+
+	struct class_device_attribute *host_attrs[SRP_HOST_ATTRS + 1];
+
+	struct class_device_attribute *rport_attrs[SRP_RPORT_ATTRS + 1];
+	struct class_device_attribute private_rport_attrs[SRP_RPORT_ATTRS];
+	struct transport_container rport_attr_cont;
+};
+
+#define to_srp_internal(tmpl) container_of(tmpl, struct srp_internal, t)
+
+#define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
+#define transport_class_to_srp_rport(cdev) dev_to_rport((cdev)->dev)
+
+static int srp_host_setup(struct transport_container *tc, struct device *dev,
+			  struct class_device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
+
+	atomic_set(&srp_host->next_port_id, 0);
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(srp_host_class, "srp_host", srp_host_setup,
+			       NULL, NULL);
+
+static DECLARE_TRANSPORT_CLASS(srp_rport_class, "srp_remote_ports",
+			       NULL, NULL, NULL);
+
+#define SETUP_TEMPLATE(attrb, field, perm, test, ro_test, ro_perm)	\
+	i->private_##attrb[count] = class_device_attr_##field;		\
+	i->private_##attrb[count].attr.mode = perm;			\
+	if (ro_test) {							\
+		i->private_##attrb[count].attr.mode = ro_perm;		\
+		i->private_##attrb[count].store = NULL;			\
+	}								\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
+
+#define SETUP_RPORT_ATTRIBUTE_RD(field)					\
+	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO, 1, 0, 0)
+
+#define SETUP_RPORT_ATTRIBUTE_RW(field)					\
+	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO | S_IWUSR,		\
+		       1, 1, S_IRUGO)
+
+#define SRP_PID(p) \
+	(p)->port_id[0], (p)->port_id[1], (p)->port_id[2], (p)->port_id[3], \
+	(p)->port_id[4], (p)->port_id[5], (p)->port_id[6], (p)->port_id[7], \
+	(p)->port_id[8], (p)->port_id[9], (p)->port_id[10], (p)->port_id[11], \
+	(p)->port_id[12], (p)->port_id[13], (p)->port_id[14], (p)->port_id[15]
+
+#define SRP_PID_FMT "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:" \
+	"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x"
+
+static ssize_t
+show_srp_rport_id(struct class_device *cdev, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(cdev);
+	return sprintf(buf, SRP_PID_FMT "\n", SRP_PID(rport));
+}
+
+static CLASS_DEVICE_ATTR(port_id, S_IRUGO, show_srp_rport_id, NULL);
+
+static const struct {
+	u32 value;
+	char *name;
+} srp_rport_role_names[] = {
+	{SRP_RPORT_ROLE_INITIATOR, "SRP Initiator"},
+	{SRP_RPORT_ROLE_TARGET, "SRP Target"},
+};
+
+static ssize_t
+show_srp_rport_roles(struct class_device *cdev, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(cdev);
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(srp_rport_role_names); i++)
+		if (srp_rport_role_names[i].value == rport->roles) {
+			name = srp_rport_role_names[i].name;
+			break;
+		}
+	return sprintf(buf, "%s\n", name ? : "unknown");
+}
+
+static CLASS_DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
+
+static void srp_rport_release(struct device *dev)
+{
+	struct srp_rport *rport = dev_to_rport(dev);
+
+	put_device(dev->parent);
+	kfree(rport);
+}
+
+static int scsi_is_srp_rport(const struct device *dev)
+{
+	return dev->release == srp_rport_release;
+}
+
+static int srp_rport_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	if (!scsi_is_srp_rport(dev))
+		return 0;
+
+	shost = dev_to_shost(dev->parent);
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class != &srp_host_class.class)
+		return 0;
+
+	i = to_srp_internal(shost->transportt);
+	return &i->rport_attr_cont.ac == cont;
+}
+
+static int srp_host_match(struct attribute_container *cont, struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class != &srp_host_class.class)
+		return 0;
+
+	i = to_srp_internal(shost->transportt);
+	return &i->t.host_attrs.ac == cont;
+}
+
+/**
+ * srp_rport_add - add a SRP remote port to the device hierarchy
+ *
+ * @shost:	scsi host the remote port is connected to.
+ * @ids:	The port id for the remote port.
+ *
+ * publishes a port to the rest of the system
+ */
+struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
+				struct srp_rport_identifiers *ids)
+{
+	struct srp_rport *rport;
+	struct device *parent = &shost->shost_gendev;
+	int id, ret;
+
+	rport = kzalloc(sizeof(*rport), GFP_KERNEL);
+	if (!rport)
+		return ERR_PTR(-ENOMEM);
+
+	device_initialize(&rport->dev);
+
+	rport->dev.parent = get_device(parent);
+	rport->dev.release = srp_rport_release;
+
+	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
+	rport->roles = ids->roles;
+
+	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
+	sprintf(rport->dev.bus_id, "port-%d:%d", shost->host_no, id);
+
+	transport_setup_device(&rport->dev);
+
+	ret = device_add(&rport->dev);
+	if (ret) {
+		transport_destroy_device(&rport->dev);
+		put_device(&rport->dev);
+		return ERR_PTR(ret);
+	}
+
+	if (ids->roles == SRP_RPORT_ROLE_INITIATOR) {
+		ret = srp_tgt_it_nexus_create(shost, (unsigned long)rport,
+					      rport->port_id);
+		if (ret) {
+			device_del(&rport->dev);
+			transport_destroy_device(&rport->dev);
+			put_device(&rport->dev);
+			return ERR_PTR(ret);
+		}
+	}
+
+	transport_add_device(&rport->dev);
+	transport_configure_device(&rport->dev);
+
+	return rport;
+}
+EXPORT_SYMBOL_GPL(srp_rport_add);
+
+/**
+ * srp_rport_del  --  remove a SRP remote port
+ * @port:	SRP remote port to remove
+ *
+ * Removes the specified SRP remote port.
+ */
+void srp_rport_del(struct srp_rport *rport)
+{
+	struct device *dev = &rport->dev;
+
+	if (rport->roles == SRP_RPORT_ROLE_INITIATOR)
+		srp_tgt_it_nexus_destroy(dev_to_shost(dev->parent),
+					 (unsigned long)rport);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+EXPORT_SYMBOL_GPL(srp_rport_del);
+
+static int do_srp_rport_del(struct device *dev, void *data)
+{
+	srp_rport_del(dev_to_rport(dev));
+	return 0;
+}
+
+/**
+ * srp_remove_host  --  tear down a Scsi_Host's SRP data structures
+ * @shost:	Scsi Host that is torn down
+ *
+ * Removes all SRP remote ports for a given Scsi_Host.
+ * Must be called just before scsi_remove_host for SRP HBAs.
+ */
+void srp_remove_host(struct Scsi_Host *shost)
+{
+	device_for_each_child(&shost->shost_gendev, NULL, do_srp_rport_del);
+}
+EXPORT_SYMBOL_GPL(srp_remove_host);
+
+static int srp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
+				 int result)
+{
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
+}
+
+static int srp_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
+{
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+	return i->f->it_nexus_response(shost, nexus, result);
+}
+
+/**
+ * srp_attach_transport  --  instantiate SRP transport template
+ * @ft:		SRP transport class function template
+ */
+struct scsi_transport_template *
+srp_attach_transport(struct srp_function_template *ft)
+{
+	int count;
+	struct srp_internal *i;
+
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
+	if (!i)
+		return NULL;
+
+	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
+	i->t.it_nexus_response = srp_it_nexus_response;
+
+	i->t.host_size = sizeof(struct srp_host_attrs);
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &srp_host_class.class;
+	i->t.host_attrs.ac.match = srp_host_match;
+	i->host_attrs[0] = NULL;
+	transport_container_register(&i->t.host_attrs);
+
+	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
+	i->rport_attr_cont.ac.class = &srp_rport_class.class;
+	i->rport_attr_cont.ac.match = srp_rport_match;
+	transport_container_register(&i->rport_attr_cont);
+
+	count = 0;
+	SETUP_RPORT_ATTRIBUTE_RD(port_id);
+	SETUP_RPORT_ATTRIBUTE_RD(roles);
+	i->rport_attrs[count] = NULL;
+
+	i->f = ft;
+
+	return &i->t;
+}
+EXPORT_SYMBOL_GPL(srp_attach_transport);
+
+/**
+ * srp_release_transport  --  release SRP transport template instance
+ * @t:		transport template instance
+ */
+void srp_release_transport(struct scsi_transport_template *t)
+{
+	struct srp_internal *i = to_srp_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->rport_attr_cont);
+
+	kfree(i);
+}
+EXPORT_SYMBOL_GPL(srp_release_transport);
+
+static __init int srp_transport_init(void)
+{
+	int ret;
+
+	ret = transport_class_register(&srp_host_class);
+	if (ret)
+		return ret;
+	ret = transport_class_register(&srp_rport_class);
+	if (ret)
+		goto unregister_host_class;
+
+	return 0;
+unregister_host_class:
+	transport_class_unregister(&srp_host_class);
+	return ret;
+}
+
+static void __exit srp_transport_exit(void)
+{
+	transport_class_unregister(&srp_host_class);
+	transport_class_unregister(&srp_rport_class);
+}
+
+MODULE_AUTHOR("FUJITA Tomonori");
+MODULE_DESCRIPTION("SRP Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(srp_transport_init);
+module_exit(srp_transport_exit);
diff --git a/drivers/scsi/scsi_transport_srp_internal.h b/drivers/scsi/scsi_transport_srp_internal.h
new file mode 100644
index 0000000..8a79747
--- /dev/null
+++ b/drivers/scsi/scsi_transport_srp_internal.h
@@ -0,0 +1,25 @@
+#include <scsi/scsi_tgt.h>
+
+#ifdef CONFIG_SCSI_SRP_TGT_ATTRS
+static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					  char *initiator)
+{
+	return scsi_tgt_it_nexus_create(shost, itn_id, initiator);
+}
+
+static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return scsi_tgt_it_nexus_destroy(shost, itn_id);
+}
+
+#else
+static inline int srp_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+					  char *initiator)
+{
+	return 0;
+}
+static inline int srp_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return 0;
+}
+#endif
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index d143171..ba615e4 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -59,7 +59,7 @@ extern void srp_target_free(struct srp_t
 extern struct iu_entry *srp_iu_get(struct srp_target *);
 extern void srp_iu_put(struct iu_entry *);
 
-extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64);
+extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64);
 extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
 			     srp_rdma_t, int, int);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b8a6a8..88f6871 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -145,9 +145,6 @@ #endif
 	int (* transfer_response)(struct scsi_cmnd *,
 				  void (*done)(struct scsi_cmnd *));
 
-	/* Used as callback for the completion of task management request. */
-	int (* tsk_mgmt_response)(u64 mid, int result);
-
 	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
diff --git a/include/scsi/scsi_tgt.h b/include/scsi/scsi_tgt.h
index 4f44279..d0fefb9 100644
--- a/include/scsi/scsi_tgt.h
+++ b/include/scsi/scsi_tgt.h
@@ -11,9 +11,11 @@ struct scsi_lun;
 extern struct Scsi_Host *scsi_tgt_cmd_to_host(struct scsi_cmnd *);
 extern int scsi_tgt_alloc_queue(struct Scsi_Host *);
 extern void scsi_tgt_free_queue(struct Scsi_Host *);
-extern int scsi_tgt_queue_command(struct scsi_cmnd *, struct scsi_lun *, u64);
-extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, int, u64, struct scsi_lun *,
-				     void *);
+extern int scsi_tgt_queue_command(struct scsi_cmnd *, u64, struct scsi_lun *, u64);
+extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, u64, int, u64,
+				     struct scsi_lun *, void *);
 extern struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *,
 					       enum dma_data_direction,	gfp_t);
 extern void scsi_host_put_command(struct Scsi_Host *, struct scsi_cmnd *);
+extern int scsi_tgt_it_nexus_create(struct Scsi_Host *, u64, char *);
+extern int scsi_tgt_it_nexus_destroy(struct Scsi_Host *, u64);
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index 4cf9dff..f2ee7c2 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -23,13 +23,15 @@ #ifndef __SCSI_TARGET_IF_H
 #define __SCSI_TARGET_IF_H
 
 /* user -> kernel */
-#define	TGT_UEVENT_CMD_RSP	0x0001
-#define	TGT_UEVENT_TSK_MGMT_RSP	0x0002
+#define	TGT_UEVENT_CMD_RSP		0x0001
+#define	TGT_UEVENT_IT_NEXUS_RSP		0x0002
+#define	TGT_UEVENT_TSK_MGMT_RSP		0x0003
 
 /* kernel -> user */
-#define	TGT_KEVENT_CMD_REQ	0x1001
-#define	TGT_KEVENT_CMD_DONE	0x1002
-#define	TGT_KEVENT_TSK_MGMT_REQ	0x1003
+#define	TGT_KEVENT_CMD_REQ		0x1001
+#define	TGT_KEVENT_CMD_DONE		0x1002
+#define	TGT_KEVENT_IT_NEXUS_REQ		0x1003
+#define	TGT_KEVENT_TSK_MGMT_REQ		0x1004
 
 struct tgt_event_hdr {
 	uint16_t version;
@@ -46,6 +48,7 @@ struct tgt_event {
 		struct {
 			int host_no;
 			int result;
+			aligned_u64 itn_id;
 			aligned_u64 tag;
 			aligned_u64 uaddr;
 			aligned_u64 sense_uaddr;
@@ -55,15 +58,22 @@ struct tgt_event {
 		} cmd_rsp;
 		struct {
 			int host_no;
-			aligned_u64 mid;
 			int result;
+			aligned_u64 itn_id;
+			aligned_u64 mid;
 		} tsk_mgmt_rsp;
-
+		struct {
+			__s32 host_no;
+			__s32 result;
+			aligned_u64 itn_id;
+			__u32 function;
+		} it_nexus_rsp;
 
 		/* kernel -> user */
 		struct {
 			int host_no;
 			uint32_t data_len;
+			aligned_u64 itn_id;
 			uint8_t scb[16];
 			uint8_t lun[8];
 			int attribute;
@@ -71,16 +81,25 @@ struct tgt_event {
 		} cmd_req;
 		struct {
 			int host_no;
-			aligned_u64 tag;
 			int result;
+			aligned_u64 itn_id;
+			aligned_u64 tag;
 		} cmd_done;
 		struct {
 			int host_no;
 			int function;
+			aligned_u64 itn_id;
 			aligned_u64 tag;
 			uint8_t lun[8];
 			aligned_u64 mid;
 		} tsk_mgmt_req;
+		struct {
+			__s32 host_no;
+			__u32 function;
+			aligned_u64 itn_id;
+			__u32 max_cmds;
+			__u8 initiator_id[16];
+		} it_nexus_req;
 	} p;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 3c18baa..0dfef75 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -65,6 +65,18 @@ struct scsi_transport_template {
 	 * EH_NOT_HANDLED	Begin normal error recovery
 	 */
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+
+	/*
+	 * Used as callback for the completion of i_t_nexus request
+	 * for target drivers.
+	 */
+	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
+
+	/*
+	 * Used as callback for the completion of task management
+	 * request for target drivers.
+	 */
+	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 };
 
 #define transport_class_to_shost(tc) \
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
new file mode 100644
index 0000000..9c60ca1
--- /dev/null
+++ b/include/scsi/scsi_transport_srp.h
@@ -0,0 +1,39 @@
+#ifndef SCSI_TRANSPORT_SRP_H
+#define SCSI_TRANSPORT_SRP_H
+
+#include <linux/transport_class.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+
+#define SRP_RPORT_ROLE_INITIATOR 0
+#define SRP_RPORT_ROLE_TARGET 1
+
+struct srp_rport_identifiers {
+	u8 port_id[16];
+	u8 roles;
+};
+
+struct srp_rport {
+	struct device dev;
+
+	u8 port_id[16];
+	u8 roles;
+};
+
+struct srp_function_template {
+	/* for target drivers */
+	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
+	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
+};
+
+extern struct scsi_transport_template *
+srp_attach_transport(struct srp_function_template *);
+extern void srp_release_transport(struct scsi_transport_template *);
+
+extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
+				       struct srp_rport_identifiers *);
+extern void srp_rport_del(struct srp_rport *);
+
+extern void srp_remove_host(struct Scsi_Host *);
+
+#endif

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
git-block.patch
