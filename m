From: akpm@linux-foundation.org
Subject: - readahead-loop-case.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:20 -0700
Message-ID: <200705080815.l488FK19019046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934644AbXEHIPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: loop case
has been removed from the -mm tree.  Its filename was
     readahead-loop-case.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: loop case
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Disable look-ahead for loop file.

Loopback files normally contain filesystems, in which case there are already
proper look-aheads in the upper layer, more look-aheads on the loopback file
only ruins the read-ahead hit rate.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    6 ++++++
 include/linux/fs.h   |    1 +
 mm/readahead.c       |    4 ++++
 3 files changed, 11 insertions(+)

diff -puN drivers/block/loop.c~readahead-loop-case drivers/block/loop.c
--- a/drivers/block/loop.c~readahead-loop-case
+++ a/drivers/block/loop.c
@@ -752,6 +752,12 @@ static int loop_set_fd(struct loop_devic
 	mapping = file->f_mapping;
 	inode = mapping->host;
 
+	/* Instruct the readahead code to skip look-ahead on loop file.
+	 * The upper layer should already do proper look-ahead,
+	 * one more look-ahead here only ruins the cache hit rate.
+	 */
+	file->f_ra.flags |= RA_FLAG_LOOP;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
diff -puN include/linux/fs.h~readahead-loop-case include/linux/fs.h
--- a/include/linux/fs.h~readahead-loop-case
+++ a/include/linux/fs.h
@@ -745,6 +745,7 @@ struct file_ra_state {
 #define RA_FLAG_MISS	(1UL<<31) /* a cache miss occured against this file */
 #define RA_FLAG_INCACHE	(1UL<<30) /* file is already in cache */
 #define RA_FLAG_MMAP	(1UL<<29) /* mmap page access */
+#define RA_FLAG_LOOP	(1UL<<28) /* loopback file */
 
 struct file {
 	/*
diff -puN mm/readahead.c~readahead-loop-case mm/readahead.c
--- a/mm/readahead.c~readahead-loop-case
+++ a/mm/readahead.c
@@ -964,6 +964,10 @@ static unsigned long ra_submit(struct fi
 		    ra->lookahead_index = eof;
 	}
 
+	/* Disable look-ahead for loopback file. */
+	if (ra->flags & RA_FLAG_LOOP)
+		ra->lookahead_index = ra->readahead_index;
+
 	/* Take down the current read-ahead aging value. */
 	ra_save_node_age(ra);
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
