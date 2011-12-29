From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-typo-in-isolating-lru-pages.patch added to -mm tree
Date: Thu, 29 Dec 2011 15:08:03 -0800
Message-ID: <20111229230803.B0DF1100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:44723 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab1L2XIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2011 18:08:04 -0500
Received: by ghrr15 with SMTP id r15so1334762ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2011 15:08:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     From: Hillf Danton <dhillf@gmail.com>
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-typo-in-isolating-lru-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: vmscan: fix typo in isolating lru pages

It is not the tag page but the cursor page that we should process, and it
looks a typo.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-typo-in-isolating-lru-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-typo-in-isolating-lru-pages
+++ a/mm/vmscan.c
@@ -1173,7 +1173,7 @@ static unsigned long isolate_lru_pages(u
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-				nr_taken += hpage_nr_pages(page);
+				nr_taken += hpage_nr_pages(cursor_page);
 				nr_lumpy_taken++;
 				if (PageDirty(cursor_page))
 					nr_lumpy_dirty++;
_
Subject: From: Hillf Danton <dhillf@gmail.com>

Patches currently in -mm which might be from dhillf@gmail.com are

mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch

