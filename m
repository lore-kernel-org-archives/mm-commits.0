From: akpm@linux-foundation.org
Subject: [folded-merged] mm-ksm-use-pr_err-instead-of-printk-fix.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:44:55 -0700
Message-ID: <5436f3c7.G8Fakpvyk0kXhsdy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaJIUoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-use-pr_err-instead-of-printk-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-pr_err-instead-of-printk-fix.patch

This patch was dropped because it was folded into mm-ksm-use-pr_err-instead-of-printk.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-use-pr_err-instead-of-printk-fix

remove KERN_ERR

Cc: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~mm-ksm-use-pr_err-instead-of-printk-fix mm/ksm.c
--- a/mm/ksm.c~mm-ksm-use-pr_err-instead-of-printk-fix
+++ a/mm/ksm.c
@@ -2310,7 +2310,7 @@ static int __init ksm_init(void)
 
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
-		pr_err(KERN_ERR "ksm: creating kthread failed\n");
+		pr_err("ksm: creating kthread failed\n");
 		err = PTR_ERR(ksm_thread);
 		goto out_free;
 	}
@@ -2318,7 +2318,7 @@ static int __init ksm_init(void)
 #ifdef CONFIG_SYSFS
 	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
 	if (err) {
-		pr_err(KERN_ERR "ksm: register sysfs failed\n");
+		pr_err("ksm: register sysfs failed\n");
 		kthread_stop(ksm_thread);
 		goto out_free;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

