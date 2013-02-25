From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-convert-to-pr_foo.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:11 -0800
Message-ID: <20130225204811.A22AC5A42E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62661 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab3BYUsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:13 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so346266ggi.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: convert to pr_foo()

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-convert-to-pr_foo mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-convert-to-pr_foo
+++ a/mm/hugetlb.c
@@ -1293,8 +1293,7 @@ static void __init report_hugepages(void
 
 	for_each_hstate(h) {
 		char buf[32];
-		printk(KERN_INFO "HugeTLB registered %s page size, "
-				 "pre-allocated %ld pages\n",
+		pr_info("HugeTLB registered %s page size, pre-allocated %ld pages\n",
 			memfmt(buf, huge_page_size(h)),
 			h->free_huge_pages);
 	}
@@ -1702,8 +1701,7 @@ static void __init hugetlb_sysfs_init(vo
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
 					 hstate_kobjs, &hstate_attr_group);
 		if (err)
-			printk(KERN_ERR "Hugetlb: Unable to add hstate %s",
-								h->name);
+			pr_err("Hugetlb: Unable to add hstate %s", h->name);
 	}
 }
 
@@ -1826,9 +1824,8 @@ void hugetlb_register_node(struct node *
 						nhs->hstate_kobjs,
 						&per_node_hstate_attr_group);
 		if (err) {
-			printk(KERN_ERR "Hugetlb: Unable to add hstate %s"
-					" for node %d\n",
-						h->name, node->dev.id);
+			pr_err("Hugetlb: Unable to add hstate %s for node %d\n",
+				h->name, node->dev.id);
 			hugetlb_unregister_node(node);
 			break;
 		}
@@ -1924,7 +1921,7 @@ void __init hugetlb_add_hstate(unsigned 
 	unsigned long i;
 
 	if (size_to_hstate(PAGE_SIZE << order)) {
-		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
+		pr_warning("hugepagesz= specified twice, ignoring\n");
 		return;
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
@@ -1960,8 +1957,8 @@ static int __init hugetlb_nrpages_setup(
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		printk(KERN_WARNING "hugepages= specified twice without "
-			"interleaving hugepagesz=, ignoring\n");
+		pr_warning("hugepages= specified twice without "
+			   "interleaving hugepagesz=, ignoring\n");
 		return 1;
 	}
 
@@ -2692,9 +2689,8 @@ static int hugetlb_no_page(struct mm_str
 	 * COW. Warn that such a situation has occurred as it may not be obvious
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
-		printk(KERN_WARNING
-			"PID %d killed due to inadequate hugepage pool\n",
-			current->pid);
+		pr_warning("PID %d killed due to inadequate hugepage pool\n",
+			   current->pid);
 		return ret;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

