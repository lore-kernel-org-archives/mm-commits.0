From: akpm@linux-foundation.org
Subject: - mm-revert-generic_file_buffered_write-deadlock-on-vectored-write.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:05:37 -0800
Message-ID: <200702040905.l1495bsw026101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXBDJFl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:05:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     From: Nick Piggin <npiggin@suse.de>
has been removed from the -mm tree.  Its filename was
     mm-revert-generic_file_buffered_write-deadlock-on-vectored-write.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: From: Nick Piggin <npiggin@suse.de>
From: Nick Piggin <npiggin@suse.de>
Return-Path: <npiggin@suse.de>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l148oufK016774
	for <akpm@localhost>; Sun, 4 Feb 2007 00:50:57 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sun, 04 Feb 2007 00:50:57 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l148oNrK025836
	for <akpm@mail.gateway.osdl.net>; Sun, 4 Feb 2007 00:50:23 -0800
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l148oEm8002427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@osdl.org>; Sun, 4 Feb 2007 00:50:17 -0800
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 0F7C8124E4;
	Sun,  4 Feb 2007 09:50:13 +0100 (CET)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Filesystems <linux-fsdevel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063735.23659.95941.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 3/9] mm: revert "generic_file_buffered_write(): deadlock on vectored write"
Date: Sun,  4 Feb 2007 09:50:09 +0100 (CET)
Received-SPF: none (domain of npiggin@suse.de does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.173 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=2.0 tests=AWL,BAYES_00 autolearn=ham 
	version=3.0.2


Revert 6527c2bdf1f833cc18e8f42bd97973d583e4aa83

This patch fixed the following bug:

  When prefaulting in the pages in generic_file_buffered_write(), we only
  faulted in the pages for the firts segment of the iovec.  If the second of
  successive segment described a mmapping of the page into which we're
  write()ing, and that page is not up-to-date, the fault handler tries to lock
  the already-locked page (to bring it up to date) and deadlocks.

  An exploit for this bug is in writev-deadlock-demo.c, in
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz.

  (These demos assume blocksize < PAGE_CACHE_SIZE).

The problem with this fix is that it takes the kernel back to doing a single
prepare_write()/commit_write() per iovec segment.  So in the worst case we'll
run prepare_write+commit_write 1024 times where we previously would have run
it once. The other problem with the fix is that it fix all the locking problems.


<insert numbers obtained via ext3-tools's writev-speed.c here>

And apparently this change killed NFS overwrite performance, because, I
suppose, it talks to the server for each prepare_write+commit_write.

So just back that patch out - we'll be fixing the deadlock by other means.

Signed-off-by: Andrew Morton <akpm@osdl.org>

Nick says: also it only ever actually papered over the bug, because after
faulting in the pages, they might be unmapped or reclaimed.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2090,21 +2090,14 @@ generic_file_buffered_write(struct kiocb
 	do {
 		unsigned long index;
 		unsigned long offset;
+		unsigned long maxlen;
 		size_t copied;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
-
-		/* Limit the size of the copy to the caller's write size */
-		bytes = min(bytes, count);
-
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
-		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
+		if (bytes > count)
+			bytes = count;
 
 		/*
 		 * Bring in the user page that we will copy from _first_.
@@ -2112,7 +2105,10 @@ generic_file_buffered_write(struct kiocb
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		fault_in_pages_readable(buf, bytes);
+		maxlen = cur_iov->iov_len - iov_base;
+		if (maxlen > bytes)
+			maxlen = bytes;
+		fault_in_pages_readable(buf, maxlen);
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {

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
