From: akpm@linux-foundation.org
Subject: + revert-rm-pointless-dmaengine-exports.patch added to -mm tree
Date: Fri, 09 Mar 2007 18:47:03 -0800
Message-ID: <200703100247.l2A2l32K009635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57728 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993160AbXCJCrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Mar 2007 21:47:05 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l2A2l4o4025773
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 9 Mar 2007 18:47:04 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     revert rm-pointless-dmaengine-exports
has been added to the -mm tree.  Its filename is
     revert-rm-pointless-dmaengine-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert rm-pointless-dmaengine-exports
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/dma/dmaengine.c~revert-rm-pointless-dmaengine-exports drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~revert-rm-pointless-dmaengine-exports
+++ a/drivers/dma/dmaengine.c
@@ -176,7 +176,6 @@ void dma_chan_cleanup(struct kref *kref)
 	chan->client = NULL;
 	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
-EXPORT_SYMBOL(dma_chan_cleanup);
 
 static void dma_chan_free_rcu(struct rcu_head *rcu)
 {
@@ -262,7 +261,6 @@ struct dma_client *dma_async_client_regi
 
 	return client;
 }
-EXPORT_SYMBOL(dma_async_client_register);
 
 /**
  * dma_async_client_unregister - unregister a client and free the &dma_client
@@ -289,7 +287,6 @@ void dma_async_client_unregister(struct 
 	kfree(client);
 	dma_chans_rebalance();
 }
-EXPORT_SYMBOL(dma_async_client_unregister);
 
 /**
  * dma_async_client_chan_request - request DMA channels
@@ -307,7 +304,6 @@ void dma_async_client_chan_request(struc
 	client->chans_desired = number;
 	dma_chans_rebalance();
 }
-EXPORT_SYMBOL(dma_async_client_chan_request);
 
 /**
  * dma_async_device_register - registers DMA devices found
@@ -350,7 +346,6 @@ int dma_async_device_register(struct dma
 
 	return 0;
 }
-EXPORT_SYMBOL(dma_async_device_register);
 
 /**
  * dma_async_device_cleanup - function called when all references are released
@@ -395,12 +390,23 @@ void dma_async_device_unregister(struct 
 	kref_put(&device->refcount, dma_async_device_cleanup);
 	wait_for_completion(&device->done);
 }
-EXPORT_SYMBOL(dma_async_device_unregister);
 
 static int __init dma_bus_init(void)
 {
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
+
 subsys_initcall(dma_bus_init);
 
+EXPORT_SYMBOL(dma_async_client_register);
+EXPORT_SYMBOL(dma_async_client_unregister);
+EXPORT_SYMBOL(dma_async_client_chan_request);
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
+EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
+EXPORT_SYMBOL(dma_async_memcpy_complete);
+EXPORT_SYMBOL(dma_async_memcpy_issue_pending);
+EXPORT_SYMBOL(dma_async_device_register);
+EXPORT_SYMBOL(dma_async_device_unregister);
+EXPORT_SYMBOL(dma_chan_cleanup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
