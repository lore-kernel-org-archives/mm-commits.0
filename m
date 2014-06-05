From: akpm@linux-foundation.org
Subject: [merged] fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:53 -0700
Message-ID: <5390c9e1.Ts9Z3wLNeLzsJq5f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [merged] fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:53 -0700


The patch titled
     Subject: fs/hugetlbfs/inode.c: complete conversion to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/hugetlbfs/inode.c: complete conversion to pr_foo()


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/hugetlbfs/inode.c~fs-hugetlbfs-inodec-complete-conversion-to-pr_foo fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-inodec-complete-conversion-to-pr_foo
+++ a/fs/hugetlbfs/inode.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2002 Linus Torvalds.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/thread_info.h>
 #include <asm/current.h>
@@ -823,8 +825,7 @@ hugetlbfs_parse_options(char *options, s
 			ps = memparse(args[0].from, &rest);
 			pconfig->hstate = size_to_hstate(ps);
 			if (!pconfig->hstate) {
-				printk(KERN_ERR
-				"hugetlbfs: Unsupported page size %lu MB\n",
+				pr_err("Unsupported page size %lu MB\n",
 					ps >> 20);
 				return -EINVAL;
 			}
@@ -832,8 +833,7 @@ hugetlbfs_parse_options(char *options, s
 		}
 
 		default:
-			printk(KERN_ERR "hugetlbfs: Bad mount option: \"%s\"\n",
-				 p);
+			pr_err("Bad mount option: \"%s\"\n", p);
 			return -EINVAL;
 			break;
 		}
@@ -853,8 +853,7 @@ hugetlbfs_parse_options(char *options, s
 	return 0;
 
 bad_val:
- 	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
-	       args[0].from, p);
+ 	pr_err("Bad value '%s' for mount option '%s'\n", args[0].from, p);
  	return -EINVAL;
 }
 
@@ -970,8 +969,7 @@ struct file *hugetlb_file_setup(const ch
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
 			task_lock(current);
-			printk_once(KERN_WARNING
-				"%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
+			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
 				current->comm, current->pid);
 			task_unlock(current);
 		} else {
@@ -1031,7 +1029,7 @@ static int __init init_hugetlbfs_fs(void
 	int i;
 
 	if (!hugepages_supported()) {
-		pr_info("hugetlbfs: disabling because there are no supported hugepage sizes\n");
+		pr_info("disabling because there are no supported hugepage sizes\n");
 		return -ENOTSUPP;
 	}
 
@@ -1060,7 +1058,7 @@ static int __init init_hugetlbfs_fs(void
 							buf);
 
 		if (IS_ERR(hugetlbfs_vfsmount[i])) {
-			pr_err("hugetlb: Cannot mount internal hugetlbfs for "
+			pr_err("Cannot mount internal hugetlbfs for "
 				"page size %uK", ps_kb);
 			error = PTR_ERR(hugetlbfs_vfsmount[i]);
 			hugetlbfs_vfsmount[i] = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

