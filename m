From: akpm@linux-foundation.org
Subject: - lxfb-add-power-management-functionality-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:01:59 -0700
Message-ID: <200804280701.m3S71xql013098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157AbYD1HCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, dilinger@debian.org, dilinger@queued.net, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb-add-power-management-functionality-fix
has been removed from the -mm tree.  Its filename was
     lxfb-add-power-management-functionality-fix.patch

This patch was dropped because it was folded into lxfb-add-power-management-functionality.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb-add-power-management-functionality-fix
From: Andrew Morton <akpm@linux-foundation.org>

Be conventional, save an ifdef

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality-fix drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality-fix
+++ a/drivers/video/geode/lxfb_core.c
@@ -468,6 +468,9 @@ static int lxfb_resume(struct pci_dev *p
 	pdev->dev.power.power_state = PMSG_ON;
 	return 0;
 }
+#else
+#define lxfb_suspend NULL
+#define lxfb_resume NULL
 #endif
 
 static int __init lxfb_probe(struct pci_dev *pdev,
@@ -595,10 +598,8 @@ static struct pci_driver lxfb_driver = {
 	.id_table	= lxfb_id_table,
 	.probe		= lxfb_probe,
 	.remove		= lxfb_remove,
-#ifdef CONFIG_PM
 	.suspend	= lxfb_suspend,
 	.resume		= lxfb_resume,
-#endif
 };
 
 #ifndef MODULE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

