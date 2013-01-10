From: akpm@linux-foundation.org
Subject: + mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch added to -mm tree
Date: Wed, 09 Jan 2013 16:26:15 -0800
Message-ID: <20130110002616.5B47382004A__8922.67543026737$1357777607$gmane$org@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45493 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3AJA0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 19:26:17 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so323697yhw.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 16:26:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, bfreed@google.com, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, mel@csn.ul.ie, riel@redhat.com, semenzato@google.com, sonnyrao@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm: prevent addition of pages to swap if may_writepage is unset
has been added to the -mm tree.  Its filename is
     mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: prevent addition of pages to swap if may_writepage is unset

Recently, Luigi reported there are lots of free swap space when OOM
happens.  It's easily reproduced on zram-over-swap, where many instance of
memory hogs are running and laptop_mode is enabled.

Luigi reported there was no problem when he disabled laptop_mode.  The
problem when I investigate problem is following as.

try_to_free_pages disable may_writepage if laptop_mode is enabled. 
shrink_page_list adds lots of anon pages in swap cache by add_to_swap,
which makes pages Dirty and rotate them to head of inactive LRU without
pageout.  If it is repeated, inactive anon LRU is full of Dirty and
SwapCache pages.

In case of that, isolate_lru_pages fails because it try to isolate clean
page due to may_writepage == 0.

The may_writepage could be 1 only if total_scanned is higher than
writeback_threshold in do_try_to_free_pages but unfortunately, VM can't
isolate anon pages from inactive anon lru list by above reason and we
already reclaimed all file-backed pages.  So it ends up OOM killing.

This patch prevents unnecessary addition of a page to swap cache when
may_writepage is unset so anoymous lru list isn't full of Dirty/Swapcache
page.  So the VM can isolate pages from anon lru list, which ends up
setting may_writepage to 1 and could swap out anon lru pages.  When OOM
triggers, I confirmed swap space was full.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Luigi Semenzato <semenzato@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Bryan Freed <bfreed@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset mm/vmscan.c
--- a/mm/vmscan.c~mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset
+++ a/mm/vmscan.c
@@ -780,6 +780,8 @@ static unsigned long shrink_page_list(st
 		if (PageAnon(page) && !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
+			if (!sc->may_writepage)
+				goto keep_locked;
 			if (!add_to_swap(page))
 				goto activate_locked;
 			may_enter_fs = 1;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch
mm-forcibly-swapout-when-we-are-out-of-page-cache.patch
mm-forcibly-swapout-when-we-are-out-of-page-cache-fix.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch

