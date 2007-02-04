From: akpm@linux-foundation.org
Subject: - mm-be-sure-to-trim-blocks.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:05:41 -0800
Message-ID: <200702040905.l1495f7N026110@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbXBDJFp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     From: Nick Piggin <npiggin@suse.de>
has been removed from the -mm tree.  Its filename was
     mm-be-sure-to-trim-blocks.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: From: Nick Piggin <npiggin@suse.de>
From: Nick Piggin <npiggin@suse.de>
Return-Path: <npiggin@suse.de>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l148oufN016774
	for <akpm@localhost>; Sun, 4 Feb 2007 00:50:57 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sun, 04 Feb 2007 00:50:57 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l148onUo025854
	for <akpm@mail.gateway.osdl.net>; Sun, 4 Feb 2007 00:50:49 -0800
Received: from mx1.suse.de (mail.suse.de [195.135.220.2])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l148ofob002457
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@osdl.org>; Sun, 4 Feb 2007 00:50:44 -0800
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 1EF851224E;
	Sun,  4 Feb 2007 09:50:41 +0100 (CET)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Filesystems <linux-fsdevel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063803.23659.95411.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 6/9] mm: be sure to trim blocks
Date: Sun,  4 Feb 2007 09:50:38 +0100 (CET)
Received-SPF: none (domain of npiggin@suse.de does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.173 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=2.0 tests=AWL,BAYES_00 autolearn=ham 
	version=3.0.2

If prepare_write fails with AOP_TRUNCATED_PAGE, or if commit_write fails, then
we may have failed the write operation despite prepare_write having
instantiated blocks past i_size. Fix this, and consolidate the trimming into
one place.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2120,22 +2120,9 @@ generic_file_buffered_write(struct kiocb
 		}
 
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
-		if (unlikely(status)) {
-			loff_t isize = i_size_read(inode);
+		if (unlikely(status))
+			goto fs_write_aop_error;
 
-			if (status != AOP_TRUNCATED_PAGE)
-				unlock_page(page);
-			page_cache_release(page);
-			if (status == AOP_TRUNCATED_PAGE)
-				continue;
-			/*
-			 * prepare_write() may have instantiated a few blocks
-			 * outside i_size.  Trim these off again.
-			 */
-			if (pos + bytes > isize)
-				vmtruncate(inode, isize);
-			break;
-		}
 		if (likely(nr_segs == 1))
 			copied = filemap_copy_from_user(page, offset,
 							buf, bytes);
@@ -2144,40 +2131,53 @@ generic_file_buffered_write(struct kiocb
 						cur_iov, iov_offset, bytes);
 		flush_dcache_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
-		if (status == AOP_TRUNCATED_PAGE) {
-			page_cache_release(page);
-			continue;
+		if (unlikely(status < 0))
+			goto fs_write_aop_error;
+		if (unlikely(copied != bytes)) {
+			status = -EFAULT;
+			goto fs_write_aop_error;
 		}
-		if (likely(copied > 0)) {
-			if (!status)
-				status = copied;
+		if (unlikely(status > 0)) /* filesystem did partial write */
+			copied = status;
 
-			if (status >= 0) {
-				written += status;
-				count -= status;
-				pos += status;
-				buf += status;
-				if (unlikely(nr_segs > 1)) {
-					filemap_set_next_iovec(&cur_iov,
-							&iov_offset, status);
-					if (count)
-						buf = cur_iov->iov_base +
-							iov_offset;
-				} else {
-					iov_offset += status;
-				}
+		if (likely(copied > 0)) {
+			written += copied;
+			count -= copied;
+			pos += copied;
+			buf += copied;
+			if (unlikely(nr_segs > 1)) {
+				filemap_set_next_iovec(&cur_iov,
+						&iov_offset, copied);
+				if (count)
+					buf = cur_iov->iov_base + iov_offset;
+			} else {
+				iov_offset += copied;
 			}
 		}
-		if (unlikely(copied != bytes))
-			if (status >= 0)
-				status = -EFAULT;
 		unlock_page(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
-		if (status < 0)
-			break;
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
+		continue;
+
+fs_write_aop_error:
+		if (status != AOP_TRUNCATED_PAGE)
+			unlock_page(page);
+		page_cache_release(page);
+
+		/*
+		 * prepare_write() may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + bytes > inode->i_size)
+			vmtruncate(inode, inode->i_size);
+		if (status == AOP_TRUNCATED_PAGE)
+			continue;
+		else
+			break;
+
 	} while (count);
 	*ppos = pos;
 

Patches currently in -mm which might be from npiggin@suse.de are

mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch
git-block.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch
