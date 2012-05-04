From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 04 May 2012 12:18:36 -0700
Message-ID: <20120504191838.34227A011A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:54583 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2EDTSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2012 15:18:40 -0400
Received: by yhgm50 with SMTP id m50so351319yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 04 May 2012 12:18:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-eg20t.c |   30 ---------------------------
 drivers/usb/host/ehci-tegra.c  |   34 -------------------------------
 net/core/drop_monitor.c        |   15 -------------
 3 files changed, 79 deletions(-)

diff -puN drivers/i2c/busses/i2c-eg20t.c~linux-next-git-rejects drivers/i2c/busses/i2c-eg20t.c
--- a/drivers/i2c/busses/i2c-eg20t.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-eg20t.c
@@ -312,36 +312,6 @@ static void pch_i2c_start(struct i2c_alg
 }
 
 /**
-<<<<<<< HEAD
- * pch_i2c_wait_for_xfer_complete() - initiates a wait for the tx complete event
- * @adap:	Pointer to struct i2c_algo_pch_data.
- */
-static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
-{
-	long ret;
-	ret = wait_event_timeout(pch_event,
-			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
-
-	if (ret == 0) {
-		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
-		adap->pch_event_flag = 0;
-		return -ETIMEDOUT;
-	}
-
-	if (adap->pch_event_flag & I2C_ERROR_MASK) {
-		pch_err(adap, "error bits set: %x\n", adap->pch_event_flag);
-		adap->pch_event_flag = 0;
-		return -EIO;
-	}
-
-	adap->pch_event_flag = 0;
-
-	return 0;
-}
-
-/**
-=======
->>>>>>> linux-next/akpm-end
  * pch_i2c_getack() - to confirm ACK/NACK
  * @adap:	Pointer to struct i2c_algo_pch_data.
  */
diff -puN drivers/usb/host/ehci-tegra.c~linux-next-git-rejects drivers/usb/host/ehci-tegra.c
--- a/drivers/usb/host/ehci-tegra.c~linux-next-git-rejects
+++ a/drivers/usb/host/ehci-tegra.c
@@ -308,41 +308,7 @@ static int tegra_ehci_setup(struct usb_h
 	return retval;
 }
 
-<<<<<<< HEAD
 struct temp_buffer {
-=======
-#ifdef CONFIG_PM
-static int tegra_ehci_bus_suspend(struct usb_hcd *hcd)
-{
-	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
-	int error_status = 0;
-
-	error_status = ehci_bus_suspend(hcd);
-	if (!error_status && tegra->power_down_on_bus_suspend) {
-		tegra_usb_suspend(hcd);
-		tegra->bus_suspended = 1;
-	}
-
-	return error_status;
-}
-
-static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
-{
-	struct tegra_ehci_hcd *tegra = dev_get_drvdata(hcd->self.controller);
-
-	if (tegra->bus_suspended && tegra->power_down_on_bus_suspend) {
-		tegra_usb_resume(hcd);
-		tegra->bus_suspended = 0;
-	}
-
-	tegra_usb_phy_preresume(tegra->phy);
-	tegra->port_resuming = 1;
-	return ehci_bus_resume(hcd);
-}
-#endif
-
-struct dma_aligned_buffer {
->>>>>>> linux-next/akpm-end
 	void *kmalloc_ptr;
 	void *old_xfer_buffer;
 	u8 data[0];
diff -puN net/core/drop_monitor.c~linux-next-git-rejects net/core/drop_monitor.c
--- a/net/core/drop_monitor.c~linux-next-git-rejects
+++ a/net/core/drop_monitor.c
@@ -97,13 +97,8 @@ static void reset_per_cpu_data(struct pe
 				  sizeof(struct net_dm_alert_msg));
 		msg = nla_data(nla);
 		memset(msg, 0, al);
-<<<<<<< HEAD
-	} else
-		schedule_work_on(data->cpu, &data->dm_alert_work);
-=======
 	} else if (initialized)
 		schedule_work_on(smp_processor_id(), &data->dm_alert_work);
->>>>>>> linux-next/akpm-end
 
 	/*
 	 * Don't need to lock this, since we are guaranteed to only
@@ -126,11 +121,8 @@ static void send_dm_alert(struct work_st
 {
 	struct sk_buff *skb;
 	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
-<<<<<<< HEAD
 
 	WARN_ON_ONCE(data->cpu != smp_processor_id());
-=======
->>>>>>> linux-next/akpm-end
 
 	/*
 	 * Grab the skb we're about to send
@@ -174,13 +166,9 @@ static void trace_drop_common(struct sk_
 	int i;
 	struct sk_buff *dskb;
 	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
-<<<<<<< HEAD
-
 
 	rcu_read_lock();
 	dskb = rcu_dereference(data->skb);
-=======
->>>>>>> linux-next/akpm-end
 
 	if (!dskb)
 		goto out;
@@ -432,10 +420,7 @@ static int __init init_net_drop_monitor(
 		reset_per_cpu_data(data);
 	}
 
-<<<<<<< HEAD
-=======
 	initialized = 1;
->>>>>>> linux-next/akpm-end
 
 	goto out;
 
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
drivers-gpu-drm-gma500-mdfld_devicec-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

