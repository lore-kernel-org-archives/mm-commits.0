From: akpm@linux-foundation.org
Subject: + writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch added to -mm tree
Date: Thu, 27 Sep 2007 13:47:32 -0700
Message-ID: <200709272047.l8RKlWrX027368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771AbXI0Urv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 16:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, galak@kernel.crashing.org, greg@kroah.com, hirofumi@mail.parknet.co.jp, nickpiggin@yahoo.com.au, riel@redhat.com, zaitcev@redhat.com


The patch titled
     writeback: remove unnecessary wait in throttle_vm_writeout()
has been added to the -mm tree.  Its filename is
     writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: writeback: remove unnecessary wait in throttle_vm_writeout()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

We don't want to introduce pointless delays in throttle_vm_writeout() when
the writeback limits are not yet exceeded, do we?

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page-writeback.c~writeback-remove-unnecessary-wait-in-throttle_vm_writeout mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-unnecessary-wait-in-throttle_vm_writeout
+++ a/mm/page-writeback.c
@@ -502,16 +502,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	long background_thresh;
 	long dirty_thresh;
 
-	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
-		/*
-		 * The caller might hold locks which can prevent IO completion
-		 * or progress in the filesystem.  So we cannot just sit here
-		 * waiting for IO to complete.
-		 */
-		congestion_wait(WRITE, HZ/10);
-		return;
-	}
-
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 
@@ -525,6 +515,14 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
+
+		/*
+		 * The caller might hold locks which can prevent IO completion
+		 * or progress in the filesystem.  So we cannot just sit here
+		 * waiting for IO to complete.
+		 */
+		if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO))
+			break;
         }
 }
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
make-swappiness-safer-to-use.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
