From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-transfer-page-count-from-head-page-to-tail-page-after-split-thp.patch removed from -mm tree
Date: Fri, 03 Jan 2014 12:38:06 -0800
Message-ID: <52c71fae.puPrTRNaFqcOn36a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaACUiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 15:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, liwanp@linux.vnet.ibm.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-transfer-page-count-from-head-page-to-tail-page-after-split-thp.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,liwanp@linux.vnet.ibm.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 12:38:06 -0800


The patch titled
     Subject: mm/memory-failure.c: transfer page count from head page to tail page after split thp
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-transfer-page-count-from-head-page-to-tail-page-after-split-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: transfer page count from head page to tail page after split thp

Memory failures on thp tail pages cause kernel panic like below:

  [  317.361821] mce: [Hardware Error]: Machine check events logged
  [  317.361831] MCE exception done on CPU 7
  [  317.362007] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
  [  317.362015] IP: [<ffffffff811b7cd1>] dequeue_hwpoisoned_huge_page+0x131/0x1e0
  [  317.362017] PGD bae42067 PUD ba47d067 PMD 0
  [  317.362019] Oops: 0000 [#1] SMP
  ...
  [  317.362052] CPU: 7 PID: 128 Comm: kworker/7:2 Tainted: G   M       O 3.13.0-rc4-131217-1558-00003-g83b7df08e462 #25
  ...
  [  317.362083] Call Trace:
  [  317.362091]  [<ffffffff811d9bae>] me_huge_page+0x3e/0x50
  [  317.362094]  [<ffffffff811dab9b>] memory_failure+0x4bb/0xc20
  [  317.362096]  [<ffffffff8106661e>] mce_process_work+0x3e/0x70
  [  317.362100]  [<ffffffff810b1e21>] process_one_work+0x171/0x420
  [  317.362102]  [<ffffffff810b2c1b>] worker_thread+0x11b/0x3a0
  [  317.362105]  [<ffffffff810b2b00>] ? manage_workers.isra.25+0x2b0/0x2b0
  [  317.362109]  [<ffffffff810b93c4>] kthread+0xe4/0x100
  [  317.362112]  [<ffffffff810b92e0>] ? kthread_create_on_node+0x190/0x190
  [  317.362117]  [<ffffffff816e3c6c>] ret_from_fork+0x7c/0xb0
  [  317.362119]  [<ffffffff810b92e0>] ? kthread_create_on_node+0x190/0x190
  ...
  [  317.362162] RIP  [<ffffffff811b7cd1>] dequeue_hwpoisoned_huge_page+0x131/0x1e0
  [  317.362163]  RSP <ffff880426699cf0>
  [  317.362164] CR2: 0000000000000058

The reasoning of this problem is shown below:
 - when we have a memory error on a thp tail page, the memory error
   handler grabs a refcount of the head page to keep the thp under us.
 - Before unmapping the error page from processes, we split the thp,
   where page refcounts of both of head/tail pages don't change.
 - Then we call try_to_unmap() over the error page (which was a tail
   page before). We didn't pin the error page to handle the memory error,
   this error page is freed and removed from LRU list.
 - We never have the error page on LRU list, so the first page state
   check returns "unknown page," then we move to the second check
   with the saved page flag.
 - The saved page flag have PG_tail set, so the second page state check
   returns "hugepage."
 - We call me_huge_page() for freed error page, then we hit the above panic.

The root cause is that we didn't move refcount from the head page to the
tail page after split thp.  So this patch suggests to do this.

This panic was introduced by commit 524fca1e73 ("HWPOISON: fix
misjudgement of page_action() for errors on mlocked pages").  Note that we
did have the same refcount problem before this commit, but it was just
ignored because we had only first page state check which returned "unknown
page." The commit changed the refcount problem from "doesn't work" to
"kernel panic."

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/memory-failure.c~mm-memory-failurec-transfer-page-count-from-head-page-to-tail-page-after-split-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-transfer-page-count-from-head-page-to-tail-page-after-split-thp
+++ a/mm/memory-failure.c
@@ -938,6 +938,16 @@ static int hwpoison_user_mappings(struct
 				BUG_ON(!PageHWPoison(p));
 				return SWAP_FAIL;
 			}
+			/*
+			 * We pinned the head page for hwpoison handling,
+			 * now we split the thp and we are interested in
+			 * the hwpoisoned raw page, so move the refcount
+			 * to it.
+			 */
+			if (hpage != p) {
+				put_page(hpage);
+				get_page(p);
+			}
 			/* THP is split, so ppage should be the real poisoned page. */
 			ppage = p;
 		}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

