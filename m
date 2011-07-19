From: akpm@linux-foundation.org
Subject: + mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix.patch added to -mm tree
Date: Tue, 19 Jul 2011 09:11:26 -0700
Message-ID: <201107191608.p6JG8RT4010117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1GSQI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jul 2011 12:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
has been added to the -mm tree.  Its filename is
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix.patch

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
Subject: mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
From: Mel Gorman <mgorman@suse.de>

mm/page_alloc.c: In function `__alloc_pages_direct_reclaim':
mm/page_alloc.c:1983:3: error: implicit declaration of function `zlc_clear_zones_full'

This patch is a build fix for !CONFIG_NUMA that should be merged with
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch .

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix
+++ a/mm/page_alloc.c
@@ -1647,6 +1647,10 @@ static int zlc_zone_worth_trying(struct 
 static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 {
 }
+
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

vmscan-fix-a-livelock-in-kswapd.patch
mm-page-allocator-initialise-zlc-for-first-zone-eligible-for-zone_reclaim.patch
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch
mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim-fix.patch
include-linux-kernelh-hide-internal-macros-from-userspace.patch

