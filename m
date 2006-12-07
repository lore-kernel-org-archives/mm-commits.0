From: akpm@osdl.org
Subject: - memory-page_alloc-zonelist-caching-reorder-structure.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:11 -0800
Message-ID: <200612072256.kB7MuBGW029173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163572AbWLGW4Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     memory page_alloc zonelist caching reorder structure
has been removed from the -mm tree.  Its filename was
     memory-page_alloc-zonelist-caching-reorder-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory page_alloc zonelist caching reorder structure
From: Paul Jackson <pj@sgi.com>

Rearrange the struct members in the 'struct zonelist_cache' structure, so
as to put the readonly (once initialized) z_to_n[] array first, where it
will come right after the zones[] array in struct zonelist.

This pretty much eliminates the chance that the two frequently written
elements of 'struct zonelist_cache', the fullzones bitmap and last_full_zap
times, will end up on the same cache line as the performance sensitive,
frequently read, never (after init) written zones[] array.

Keeping frequently written data off frequently read cache lines is good for
performance.

Thanks to Rohit Seth for the suggestion.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~memory-page_alloc-zonelist-caching-reorder-structure include/linux/mmzone.h
--- a/include/linux/mmzone.h~memory-page_alloc-zonelist-caching-reorder-structure
+++ a/include/linux/mmzone.h
@@ -352,8 +352,8 @@ struct zone {
 
 
 struct zonelist_cache {
-	DECLARE_BITMAP(fullzones, MAX_ZONES_PER_ZONELIST);	/* zone full? */
 	unsigned short z_to_n[MAX_ZONES_PER_ZONELIST];		/* zone->nid */
+	DECLARE_BITMAP(fullzones, MAX_ZONES_PER_ZONELIST);	/* zone full? */
 	unsigned long last_full_zap;		/* when last zap'd (jiffies) */
 };
 #else
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

