From: akpm@linux-foundation.org
Subject: + vmscan-activate-executable-pages-after-first-usage.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:57:09 -0700
Message-ID: <201108232057.p7NKvArl006160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab1HWU5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@kernel.dk, penberg@kernel.org, riel@redhat.com, shaohua.li@intel.com


The patch titled
     vmscan: activate executable pages after first usage
has been added to the -mm tree.  Its filename is
     vmscan-activate-executable-pages-after-first-usage.patch

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
Subject: vmscan: activate executable pages after first usage
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Logic added in commit 8cab4754d24a0 ("vmscan: make mapped executable pages
the first class citizen") was noticeably weakened in commit
645747462435d84 ("vmscan: detect mapped file pages used only once").

Currently these pages can become "first class citizens" only after second
usage.  After this patch page_check_references() will activate they after
first usage, and executable code gets yet better chance to stay in memory.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmscan.c~vmscan-activate-executable-pages-after-first-usage mm/vmscan.c
--- a/mm/vmscan.c~vmscan-activate-executable-pages-after-first-usage
+++ a/mm/vmscan.c
@@ -718,6 +718,12 @@ static enum page_references page_check_r
 		if (referenced_page || referenced_ptes > 1)
 			return PAGEREF_ACTIVATE;
 
+		/*
+		 * Activate file-backed executable pages after first usage.
+		 */
+		if (vm_flags & VM_EXEC)
+			return PAGEREF_ACTIVATE;
+
 		return PAGEREF_KEEP;
 	}
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch

