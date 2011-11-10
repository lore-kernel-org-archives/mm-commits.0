From: akpm@linux-foundation.org
Subject: + mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch added to -mm tree
Date: Thu, 10 Nov 2011 15:32:23 -0800
Message-ID: <201111102332.pAANWNTT003426@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:58894 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KJXc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 18:32:28 -0500
Received: by faas12 with SMTP id s12so83369faa.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 15:32:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, alan@lxorguk.ukuu.org.uk, hannes@cmpxchg.org, minchan.kim@gmail.com


The patch titled
     Subject: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
has been added to the -mm tree.  Its filename is
     mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch

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
From: Mel Gorman <mgorman@suse.de>
Subject: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3

Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/gfp.h~mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
+++ a/include/linux/gfp.h
@@ -89,6 +89,9 @@ struct vm_area_struct;
  * 1. Do not wake kswapd (hence the flag name)
  * 2. Do not use stall in synchronous compaction for high-order allocations
  *    as this may cause the caller to stall writing out pages
+ *
+ * This flag it primarily intended for use with transparent hugepage support.
+ * If the flag is used outside the VM, linux-mm should be cc'd for review.
  */
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 
_
Subject: Subject: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3

Patches currently in -mm which might be from mgorman@suse.de are

mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch

