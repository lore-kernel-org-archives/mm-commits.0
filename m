From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memoryc-complete-conversion-to-pr_foo.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:17 -0700
Message-ID: <5390c9bd.MuvWoPX891ajg9qh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFETtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [merged] mm-huge_memoryc-complete-conversion-to-pr_foo.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:17 -0700


The patch titled
     Subject: mm/huge_memory.c: complete conversion to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-complete-conversion-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/huge_memory.c: complete conversion to pr_foo()

It was using a mix of pr_foo() and printk(KERN_ERR ...).

Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-complete-conversion-to-pr_foo mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-complete-conversion-to-pr_foo
+++ a/mm/huge_memory.c
@@ -5,6 +5,8 @@
  *  the COPYING file in the top-level directory.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/highmem.h>
@@ -151,8 +153,7 @@ static int start_khugepaged(void)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
 		if (unlikely(IS_ERR(khugepaged_thread))) {
-			printk(KERN_ERR
-			       "khugepaged: kthread_run(khugepaged) failed\n");
+			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
 		}
@@ -584,19 +585,19 @@ static int __init hugepage_init_sysfs(st
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!*hugepage_kobj)) {
-		printk(KERN_ERR "hugepage: failed to create transparent hugepage kobject\n");
+		pr_err("failed to create transparent hugepage kobject\n");
 		return -ENOMEM;
 	}
 
 	err = sysfs_create_group(*hugepage_kobj, &hugepage_attr_group);
 	if (err) {
-		printk(KERN_ERR "hugepage: failed to register transparent hugepage group\n");
+		pr_err("failed to register transparent hugepage group\n");
 		goto delete_obj;
 	}
 
 	err = sysfs_create_group(*hugepage_kobj, &khugepaged_attr_group);
 	if (err) {
-		printk(KERN_ERR "hugepage: failed to register transparent hugepage group\n");
+		pr_err("failed to register transparent hugepage group\n");
 		goto remove_hp_group;
 	}
 
@@ -689,8 +690,7 @@ static int __init setup_transparent_huge
 	}
 out:
 	if (!ret)
-		printk(KERN_WARNING
-		       "transparent_hugepage= cannot parse, ignored\n");
+		pr_warn("transparent_hugepage= cannot parse, ignored\n");
 	return ret;
 }
 __setup("transparent_hugepage=", setup_transparent_hugepage);
@@ -1831,8 +1831,8 @@ static void __split_huge_page(struct pag
 	 * walk, to be able to set it as pmd_trans_splitting too.
 	 */
 	if (mapcount != page_mapcount(page)) {
-		printk(KERN_ERR "mapcount %d page_mapcount %d\n",
-		       mapcount, page_mapcount(page));
+		pr_err("mapcount %d page_mapcount %d\n",
+			mapcount, page_mapcount(page));
 		BUG();
 	}
 
@@ -1846,8 +1846,8 @@ static void __split_huge_page(struct pag
 		mapcount2 += __split_huge_page_map(page, vma, addr);
 	}
 	if (mapcount != mapcount2) {
-		printk(KERN_ERR "mapcount %d mapcount2 %d page_mapcount %d\n",
-		       mapcount, mapcount2, page_mapcount(page));
+		pr_err("mapcount %d mapcount2 %d page_mapcount %d\n",
+			mapcount, mapcount2, page_mapcount(page));
 		BUG();
 	}
 }
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

