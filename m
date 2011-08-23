From: akpm@linux-foundation.org
Subject: + vmscan-promote-shared-file-mapped-pages.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:57:06 -0700
Message-ID: <201108232057.p7NKv6JL006157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab1HWU5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@kernel.dk, penberg@kernel.org, riel@redhat.com, shaohua.li@intel.com


The patch titled
     vmscan: promote shared file mapped pages
has been added to the -mm tree.  Its filename is
     vmscan-promote-shared-file-mapped-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: promote shared file mapped pages
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Commit 645747462435 ("vmscan: detect mapped file pages used only once")
greatly decreases lifetime of single-used mapped file pages. 
Unfortunately it also decreases life time of all shared mapped file pages.
Because after commit bf3f3bc5e7347 ("mm: don't mark_page_accessed
in fault path") page-fault handler does not mark page active or even
referenced.

Thus page_check_references() activates file page only if it was used twice
while it stays in inactive list, meanwhile it activates anon pages after
first access.  Inactive list can be small enough, this way reclaimer can
accidentally throw away any widely used page if it wasn't used twice in
short period.

After this patch page_check_references() also activate file mapped page at
first inactive list scan if this page is already used multiple times via
several ptes.

I found this while trying to fix degragation in rhel6 (~2.6.32) from rhel5
(~2.6.18).  There a complete mess with >100 web/mail/spam/ftp containers,
they share all their files but there a lot of anonymous pages: ~500mb
shared file mapped memory and 15-20Gb non-shared anonymous memory.  In
this situation major-pagefaults are very costly, because all containers
share the same page.  In my load kernel created a disproportionate
pressure on the file memory, compared with the anonymous, they equaled
only if I raise swappiness up to 150 =)

These patches actually wasn't helped a lot in my problem, but I saw
noticable (10-20 times) reduce in count and average time of
major-pagefault in file-mapped areas.

Actually both patches are fixes for commit v2.6.33-5448-g6457474, because
it was aimed at one scenario (singly used pages), but it breaks the logic
in other scenarios (shared and/or executable pages)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-promote-shared-file-mapped-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-promote-shared-file-mapped-pages
+++ a/mm/vmscan.c
@@ -715,7 +715,7 @@ static enum page_references page_check_r
 		 */
 		SetPageReferenced(page);
 
-		if (referenced_page)
+		if (referenced_page || referenced_ptes > 1)
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch

