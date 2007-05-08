From: akpm@linux-foundation.org
Subject: - readahead-remove-noaction-shrink-events.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:52 -0700
Message-ID: <200705080815.l488FquX019076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934564AbXEHIQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: remove noaction/shrink events
has been removed from the -mm tree.  Its filename was
     readahead-remove-noaction-shrink-events.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: remove noaction/shrink events
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Tear down the following ra_account(NULL, ...) calls:

	ra_account(RA_EVENT_LOOKAHEAD_NOACTION)
	ra_account(RA_EVENT_READAHEAD_SHRINK)

The two events are not as useful and do not have clear meanings.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN mm/readahead.c~readahead-remove-noaction-shrink-events mm/readahead.c
--- a/mm/readahead.c~readahead-remove-noaction-shrink-events
+++ a/mm/readahead.c
@@ -87,10 +87,8 @@ enum ra_event {
 	RA_EVENT_READAHEAD_HIT,		/* read-ahead page hit */
 	RA_EVENT_LOOKAHEAD,		/* look-ahead issued */
 	RA_EVENT_LOOKAHEAD_HIT,		/* look-ahead mark hit */
-	RA_EVENT_LOOKAHEAD_NOACTION,	/* look-ahead mark ignored */
 	RA_EVENT_READAHEAD_MMAP,	/* read-ahead for mmap access */
 	RA_EVENT_READAHEAD_EOF,		/* read-ahead reaches EOF */
-	RA_EVENT_READAHEAD_SHRINK,	/* ra_size falls under previous la_size */
 	RA_EVENT_READAHEAD_THRASHING,	/* read-ahead thrashing happened */
 	RA_EVENT_READAHEAD_MUTILATE,	/* read-ahead mutilated by imbalanced aging */
 	RA_EVENT_READAHEAD_RESCUE,	/* read-ahead rescued */
@@ -454,8 +452,6 @@ int force_page_cache_readahead(struct ad
 		nr_to_read -= this_chunk;
 	}
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -498,8 +494,6 @@ int do_page_cache_readahead(struct addre
 
 	ret = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -522,7 +516,6 @@ blockable_page_cache_readahead(struct ad
 
 	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, actual);
 	dprintk("blockable-readahead(ino=%lu, ra=%lu+%lu) = %d\n",
 			mapping->host->i_ino, offset, nr_to_read, actual);
 
@@ -1010,7 +1003,6 @@ static int adjust_rala(unsigned long *ra
 	 * if there is a major upsurge of load, or fall of this stream's speed.
 	 */
 	if (*ra_size <= *la_size * 2) {
-		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
 		return 0;
 	}
 
@@ -1713,8 +1705,6 @@ page_cache_readahead_adaptive(struct add
 
 	/* No action on look-ahead time? */
 	if (page) {
-		ra_account(ra, RA_EVENT_LOOKAHEAD_NOACTION,
-						ra->readahead_index - offset);
 		return 0;
 	}
 
@@ -1810,10 +1800,8 @@ static const char * const ra_event_name[
 	"readahead_hit",
 	"lookahead",
 	"lookahead_hit",
-	"lookahead_ignore",
 	"readahead_mmap",
 	"readahead_eof",
-	"readahead_shrink",
 	"readahead_thrash",
 	"readahead_mutilt",
 	"readahead_rescue"
@@ -1828,13 +1816,11 @@ static void ra_account(struct file_ra_st
 	if (!readahead_debug_level)
 		return;
 
-	if (e == RA_EVENT_READAHEAD_HIT && pages < 0) {
-		c = ra_class_old(ra);
+	if (pages < 0) {
 		pages = -pages;
-	} else if (ra)
+		c = ra_class_old(ra);
+	} else
 		c = ra_class_new(ra);
-	else
-		c = RA_CLASS_NONE;
 
 	if (!c)
 		c = RA_CLASS_NONE;
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
