From: akpm@linux-foundation.org
Subject: + mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch added to -mm tree
Date: Fri, 01 Feb 2013 15:45:19 -0800
Message-ID: <20130201234519.B567531C1B0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61293 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3BAXpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:45:21 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so137093qah.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:45:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, viro@ZenIV.linux.org.uk


The patch titled
     Subject: mm/mlock.c: document scary-looking stack expansion mlock chain
has been added to the -mm tree.  Its filename is
     mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/mlock.c: document scary-looking stack expansion mlock chain

The fact that mlock calls get_user_pages, and get_user_pages might
call mlock when expanding a stack looks like a potential recursion.

However, mlock makes sure the requested range is already contained
within a vma, so no stack expansion will actually happen from mlock.

Should this ever change: the stack expansion mlocks only the newly
expanded range and so will not result in recursive expansion.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mlock.c~mm-mlockc-document-scary-looking-stack-expansion-mlock-chain mm/mlock.c
--- a/mm/mlock.c~mm-mlockc-document-scary-looking-stack-expansion-mlock-chain
+++ a/mm/mlock.c
@@ -185,6 +185,10 @@ long __mlock_vma_pages_range(struct vm_a
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
 		gup_flags |= FOLL_FORCE;
 
+	/*
+	 * We made sure addr is within a VMA, so the following will
+	 * not result in a stack expansion that recurses back here.
+	 */
 	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-fix-typo-in-kmemcg-cache-walk-macro.patch
linux-next.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
mm-shmem-use-new-radix-tree-iterator.patch
mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch
mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

