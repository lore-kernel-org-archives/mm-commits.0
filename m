From: akpm@linux-foundation.org
Subject: - readahead-rename-state_based_readahead-to-clock_based_readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:40 -0700
Message-ID: <200705080815.l488Fecq019067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934649AbXEHIQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: rename state_based_readahead() to clock_based_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-rename-state_based_readahead-to-clock_based_readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: rename state_based_readahead() to clock_based_readahead()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Rename state_based_readahead() to clock_based_readahead().  It better reflects
the property of that readahead method.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/readahead.c~readahead-rename-state_based_readahead-to-clock_based_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-rename-state_based_readahead-to-clock_based_readahead
+++ a/mm/readahead.c
@@ -66,7 +66,7 @@ int readahead_hit_rate = 1;
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
-	RA_CLASS_STATE,
+	RA_CLASS_CLOCK,
 	RA_CLASS_CONTEXT,
 	RA_CLASS_CONTEXT_AGGRESSIVE,
 	RA_CLASS_BACKWARD,
@@ -101,7 +101,7 @@ enum ra_event {
 
 #ifdef CONFIG_DEBUG_READAHEAD
 static u32 readahead_debug_level = 1;
-static u32 disable_stateful_method;
+static u32 disable_clock_readahead;
 static const char * const ra_class_name[];
 static void ra_account(struct file_ra_state *ra, enum ra_event e, int pages);
 #  define debug_inc(var)		do { var++; } while (0)
@@ -1118,7 +1118,7 @@ static unsigned long compute_thrashing_t
  * Main function for file_ra_state based read-ahead.
  */
 static unsigned long
-state_based_readahead(struct address_space *mapping, struct file *filp,
+clock_based_readahead(struct address_space *mapping, struct file *filp,
 			struct file_ra_state *ra,
 			struct page *page, pgoff_t offset,
 			unsigned long req_size, unsigned long ra_max)
@@ -1160,7 +1160,7 @@ state_based_readahead(struct address_spa
 	if (page && ra_old + ra_old / 8 >= ra_size)
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-	ra_set_class(ra, RA_CLASS_STATE);
+	ra_set_class(ra, RA_CLASS_CLOCK);
 	ra_set_index(ra, offset, ra->readahead_index);
 	ra_set_size(ra, ra_size, la_size);
 
@@ -1690,8 +1690,8 @@ page_cache_readahead_adaptive(struct add
 	 */
 	if (offset == ra->prev_index + 1 &&
 	    offset == ra->lookahead_index &&
-					!debug_option(disable_stateful_method))
-		return state_based_readahead(mapping, filp, ra, page,
+					!debug_option(disable_clock_readahead))
+		return clock_based_readahead(mapping, filp, ra, page,
 						offset, req_size, ra_max);
 
 	/*
@@ -1791,7 +1791,7 @@ void readahead_cache_hit(struct file_ra_
 static const char * const ra_class_name[] = {
 	"total",
 	"initial",
-	"state",
+	"clock",
 	"context",
 	"contexta",
 	"backward",
@@ -1973,8 +1973,8 @@ static int __init readahead_init(void)
 	debugfs_create_file("events", 0644, root, NULL, &ra_events_fops);
 
 	debugfs_create_u32("debug_level", 0644, root, &readahead_debug_level);
-	debugfs_create_bool("disable_stateful_method", 0644, root,
-			    &disable_stateful_method);
+	debugfs_create_bool("disable_clock_readahead", 0644, root,
+			    &disable_clock_readahead);
 
 	return 0;
 }
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
