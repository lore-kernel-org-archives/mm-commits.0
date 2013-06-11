From: akpm@linux-foundation.org
Subject: + drivers-avoid-parsing-names-as-kthread_run-format-strings.patch added to -mm tree
Date: Tue, 11 Jun 2013 13:11:56 -0700
Message-ID: <51b7848c.VJH5lxya20Pgct2+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3FKUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: + drivers-avoid-parsing-names-as-kthread_run-format-strings.patch added to -mm tree
To: keescook@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:11:56 -0700


The patch titled
     Subject: drivers: avoid parsing names as kthread_run() format strings
has been added to the -mm tree.  Its filename is
     drivers-avoid-parsing-names-as-kthread_run-format-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: drivers: avoid parsing names as kthread_run() format strings

Calling kthread_run with a single name parameter causes it to be handled
as a format string. Many callers are passing potentially dynamic string
content, so use "%s" in those cases to avoid any potential accidents.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c           |    2 +-
 drivers/block/mtip32xx/mtip32xx.c    |    3 ++-
 drivers/block/xen-blkback/xenbus.c   |    2 +-
 drivers/hwmon/adt7470.c              |    2 +-
 drivers/media/i2c/tvaudio.c          |    3 ++-
 drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
 drivers/media/platform/vivi.c        |    3 ++-
 drivers/mtd/ubi/build.c              |    2 +-
 drivers/net/wireless/airo.c          |    3 ++-
 drivers/scsi/aacraid/commctrl.c      |    3 ++-
 drivers/scsi/aacraid/commsup.c       |    3 ++-
 drivers/spi/spi.c                    |    2 +-
 drivers/staging/rtl8712/os_intfs.c   |    2 +-
 drivers/usb/atm/usbatm.c             |    5 +++--
 fs/lockd/svc.c                       |    2 +-
 fs/nfs/callback.c                    |    5 ++---
 fs/nfs/nfs4state.c                   |    2 +-
 kernel/rcutree.c                     |    2 +-
 net/sunrpc/svc.c                     |    2 +-
 19 files changed, 28 insertions(+), 22 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/block/aoe/aoecmd.c
@@ -1340,7 +1340,7 @@ aoe_ktstart(struct ktstate *k)
 	struct task_struct *task;
 
 	init_completion(&k->rendez);
-	task = kthread_run(kthread, k, k->name);
+	task = kthread_run(kthread, k, "%s", k->name);
 	if (task == NULL || IS_ERR(task))
 		return -ENOMEM;
 	k->task = task;
diff -puN drivers/block/mtip32xx/mtip32xx.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -4087,7 +4087,8 @@ skip_create_disk:
 start_service_thread:
 	sprintf(thd_name, "mtip_svc_thd_%02d", index);
 	dd->mtip_svc_handler = kthread_create_on_node(mtip_service_thread,
-						dd, dd->numa_node, thd_name);
+						dd, dd->numa_node, "%s",
+						thd_name);
 
 	if (IS_ERR(dd->mtip_svc_handler)) {
 		dev_err(&dd->pdev->dev, "service thread failed to start\n");
diff -puN drivers/block/xen-blkback/xenbus.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/block/xen-blkback/xenbus.c
--- a/drivers/block/xen-blkback/xenbus.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/block/xen-blkback/xenbus.c
@@ -93,7 +93,7 @@ static void xen_update_blkif_status(stru
 	}
 	invalidate_inode_pages2(blkif->vbd.bdev->bd_inode->i_mapping);
 
-	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, name);
+	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, "%s", name);
 	if (IS_ERR(blkif->xenblkd)) {
 		err = PTR_ERR(blkif->xenblkd);
 		blkif->xenblkd = NULL;
diff -puN drivers/hwmon/adt7470.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/hwmon/adt7470.c
@@ -1285,7 +1285,7 @@ static int adt7470_probe(struct i2c_clie
 	}
 
 	init_completion(&data->auto_update_stop);
-	data->auto_update = kthread_run(adt7470_update_thread, client,
+	data->auto_update = kthread_run(adt7470_update_thread, client, "%s",
 					dev_name(data->hwmon_dev));
 	if (IS_ERR(data->auto_update)) {
 		err = PTR_ERR(data->auto_update);
diff -puN drivers/media/i2c/tvaudio.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/media/i2c/tvaudio.c
--- a/drivers/media/i2c/tvaudio.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/media/i2c/tvaudio.c
@@ -2018,7 +2018,8 @@ static int tvaudio_probe(struct i2c_clie
 		/* start async thread */
 		chip->wt.function = chip_thread_wake;
 		chip->wt.data     = (unsigned long)chip;
-		chip->thread = kthread_run(chip_thread, chip, client->name);
+		chip->thread = kthread_run(chip_thread, chip, "%s",
+					   client->name);
 		if (IS_ERR(chip->thread)) {
 			v4l2_warn(sd, "failed to create kthread\n");
 			chip->thread = NULL;
diff -puN drivers/media/pci/ivtv/ivtv-driver.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/media/pci/ivtv/ivtv-driver.c
--- a/drivers/media/pci/ivtv/ivtv-driver.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/media/pci/ivtv/ivtv-driver.c
@@ -753,7 +753,7 @@ static int ivtv_init_struct1(struct ivtv
 
 	init_kthread_worker(&itv->irq_worker);
 	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
-					   itv->v4l2_dev.name);
+					   "%s", itv->v4l2_dev.name);
 	if (IS_ERR(itv->irq_worker_task)) {
 		IVTV_ERR("Could not create ivtv task\n");
 		return -1;
diff -puN drivers/media/platform/vivi.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/media/platform/vivi.c
--- a/drivers/media/platform/vivi.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/media/platform/vivi.c
@@ -768,7 +768,8 @@ static int vivi_start_generating(struct
 
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
-	dma_q->kthread = kthread_run(vivi_thread, dev, dev->v4l2_dev.name);
+	dma_q->kthread = kthread_run(vivi_thread, dev, "%s",
+				     dev->v4l2_dev.name);
 
 	if (IS_ERR(dma_q->kthread)) {
 		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
diff -puN drivers/mtd/ubi/build.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/mtd/ubi/build.c
--- a/drivers/mtd/ubi/build.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/mtd/ubi/build.c
@@ -1005,7 +1005,7 @@ int ubi_attach_mtd_dev(struct mtd_info *
 	if (err)
 		goto out_uif;
 
-	ubi->bgt_thread = kthread_create(ubi_thread, ubi, ubi->bgt_name);
+	ubi->bgt_thread = kthread_create(ubi_thread, ubi, "%s", ubi->bgt_name);
 	if (IS_ERR(ubi->bgt_thread)) {
 		err = PTR_ERR(ubi->bgt_thread);
 		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
diff -puN drivers/net/wireless/airo.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/net/wireless/airo.c
@@ -1893,7 +1893,8 @@ static int airo_open(struct net_device *
 
 	if (ai->wifidev != dev) {
 		clear_bit(JOB_DIE, &ai->jobs);
-		ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
+		ai->airo_thread_task = kthread_run(airo_thread, dev, "%s",
+						   dev->name);
 		if (IS_ERR(ai->airo_thread_task))
 			return (int)PTR_ERR(ai->airo_thread_task);
 
diff -puN drivers/scsi/aacraid/commctrl.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -318,7 +318,8 @@ return_fib:
 			kthread_stop(dev->thread);
 			ssleep(1);
 			dev->aif_thread = 0;
-			dev->thread = kthread_run(aac_command_thread, dev, dev->name);
+			dev->thread = kthread_run(aac_command_thread, dev,
+						  "%s", dev->name);
 			ssleep(1);
 		}
 		if (f.wait) {
diff -puN drivers/scsi/aacraid/commsup.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1336,7 +1336,8 @@ static int _aac_reset_adapter(struct aac
 		if ((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32))))
 			goto out;
 	if (jafo) {
-		aac->thread = kthread_run(aac_command_thread, aac, aac->name);
+		aac->thread = kthread_run(aac_command_thread, aac, "%s",
+					  aac->name);
 		if (IS_ERR(aac->thread)) {
 			retval = PTR_ERR(aac->thread);
 			goto out;
diff -puN drivers/spi/spi.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/spi/spi.c
--- a/drivers/spi/spi.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/spi/spi.c
@@ -601,7 +601,7 @@ static int spi_init_queue(struct spi_mas
 
 	init_kthread_worker(&master->kworker);
 	master->kworker_task = kthread_run(kthread_worker_fn,
-					   &master->kworker,
+					   &master->kworker, "%s",
 					   dev_name(&master->dev));
 	if (IS_ERR(master->kworker_task)) {
 		dev_err(&master->dev, "failed to create message pump task\n");
diff -puN drivers/staging/rtl8712/os_intfs.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/staging/rtl8712/os_intfs.c
--- a/drivers/staging/rtl8712/os_intfs.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/staging/rtl8712/os_intfs.c
@@ -238,7 +238,7 @@ struct net_device *r8712_init_netdev(voi
 
 static u32 start_drv_threads(struct _adapter *padapter)
 {
-	padapter->cmdThread = kthread_run(r8712_cmd_thread, padapter,
+	padapter->cmdThread = kthread_run(r8712_cmd_thread, padapter, "%s",
 			      padapter->pnetdev->name);
 	if (IS_ERR(padapter->cmdThread) < 0)
 		return _FAIL;
diff -puN drivers/usb/atm/usbatm.c~drivers-avoid-parsing-names-as-kthread_run-format-strings drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/drivers/usb/atm/usbatm.c
@@ -1020,7 +1020,7 @@ static int usbatm_heavy_init(struct usba
 {
 	struct task_struct *t;
 
-	t = kthread_create(usbatm_do_heavy_init, instance,
+	t = kthread_create(usbatm_do_heavy_init, instance, "%s",
 			instance->driver->driver_name);
 	if (IS_ERR(t)) {
 		usb_err(instance, "%s: failed to create kernel_thread (%ld)!\n",
@@ -1076,7 +1076,8 @@ int usbatm_usb_probe(struct usb_interfac
 	/* public fields */
 
 	instance->driver = driver;
-	snprintf(instance->driver_name, sizeof(instance->driver_name), driver->driver_name);
+	strlcpy(instance->driver_name, driver->driver_name,
+		sizeof(instance->driver_name));
 
 	instance->usb_dev = usb_dev;
 	instance->usb_intf = intf;
diff -puN fs/lockd/svc.c~drivers-avoid-parsing-names-as-kthread_run-format-strings fs/lockd/svc.c
--- a/fs/lockd/svc.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/fs/lockd/svc.c
@@ -305,7 +305,7 @@ static int lockd_start_svc(struct svc_se
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
-	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, serv->sv_name);
+	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, "%s", serv->sv_name);
 	if (IS_ERR(nlmsvc_task)) {
 		error = PTR_ERR(nlmsvc_task);
 		printk(KERN_WARNING
diff -puN fs/nfs/callback.c~drivers-avoid-parsing-names-as-kthread_run-format-strings fs/nfs/callback.c
--- a/fs/nfs/callback.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/fs/nfs/callback.c
@@ -211,7 +211,6 @@ static int nfs_callback_start_svc(int mi
 	struct svc_rqst *rqstp;
 	int (*callback_svc)(void *vrqstp);
 	struct nfs_callback_data *cb_info = &nfs_callback_info[minorversion];
-	char svc_name[12];
 	int ret;
 
 	nfs_callback_bc_serv(minorversion, xprt, serv);
@@ -235,10 +234,10 @@ static int nfs_callback_start_svc(int mi
 
 	svc_sock_update_bufs(serv);
 
-	sprintf(svc_name, "nfsv4.%u-svc", minorversion);
 	cb_info->serv = serv;
 	cb_info->rqst = rqstp;
-	cb_info->task = kthread_run(callback_svc, cb_info->rqst, svc_name);
+	cb_info->task = kthread_run(callback_svc, cb_info->rqst,
+				    "nfsv4.%u-svc", minorversion);
 	if (IS_ERR(cb_info->task)) {
 		ret = PTR_ERR(cb_info->task);
 		svc_exit_thread(cb_info->rqst);
diff -puN fs/nfs/nfs4state.c~drivers-avoid-parsing-names-as-kthread_run-format-strings fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/fs/nfs/nfs4state.c
@@ -1194,7 +1194,7 @@ void nfs4_schedule_state_manager(struct
 	snprintf(buf, sizeof(buf), "%s-manager",
 			rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_ADDR));
 	rcu_read_unlock();
-	task = kthread_run(nfs4_run_state_manager, clp, buf);
+	task = kthread_run(nfs4_run_state_manager, clp, "%s", buf);
 	if (IS_ERR(task)) {
 		printk(KERN_ERR "%s: kthread_run: %ld\n",
 			__func__, PTR_ERR(task));
diff -puN kernel/rcutree.c~drivers-avoid-parsing-names-as-kthread_run-format-strings kernel/rcutree.c
--- a/kernel/rcutree.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/kernel/rcutree.c
@@ -3015,7 +3015,7 @@ static int __init rcu_spawn_gp_kthread(v
 	struct task_struct *t;
 
 	for_each_rcu_flavor(rsp) {
-		t = kthread_run(rcu_gp_kthread, rsp, rsp->name);
+		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
 		rnp = rcu_get_root(rsp);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
diff -puN net/sunrpc/svc.c~drivers-avoid-parsing-names-as-kthread_run-format-strings net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~drivers-avoid-parsing-names-as-kthread_run-format-strings
+++ a/net/sunrpc/svc.c
@@ -740,7 +740,7 @@ svc_set_num_threads(struct svc_serv *ser
 
 		__module_get(serv->sv_module);
 		task = kthread_create_on_node(serv->sv_function, rqstp,
-					      node, serv->sv_name);
+					      node, "%s", serv->sv_name);
 		if (IS_ERR(task)) {
 			error = PTR_ERR(task);
 			module_put(serv->sv_module);
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
block-do-not-pass-disk-names-as-format-strings.patch
crypto-sanitize-argument-for-format-string.patch
drivers-avoid-format-string-in-dev_set_name.patch
drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch
drivers-avoid-parsing-names-as-kthread_run-format-strings.patch
isdn-clean-up-debug-format-string-usage.patch

