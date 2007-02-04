From: akpm@linux-foundation.org
Subject: - fs-libfs-buffered-write-leak-fix.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:05:32 -0800
Message-ID: <200702040905.l1495W3o026095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXBDJFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     From: Nick Piggin <npiggin@suse.de>
has been removed from the -mm tree.  Its filename was
     fs-libfs-buffered-write-leak-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: From: Nick Piggin <npiggin@suse.de>
From: Nick Piggin <npiggin@suse.de>
Return-Path: <npiggin@suse.de>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l148oufI016774
	for <akpm@localhost>; Sun, 4 Feb 2007 00:50:56 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sun, 04 Feb 2007 00:50:56 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l148o2lH025815
	for <akpm@mail.gateway.osdl.net>; Sun, 4 Feb 2007 00:50:02 -0800
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l148nsDs002415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@osdl.org>; Sun, 4 Feb 2007 00:49:57 -0800
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 1F31D21756;
	Sun,  4 Feb 2007 09:49:54 +0100 (CET)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Filesystems <linux-fsdevel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063716.23659.90293.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 1/9] fs: libfs buffered write leak fix
Date: Sun,  4 Feb 2007 09:49:50 +0100 (CET)
Received-SPF: none (domain of npiggin@suse.de does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.173 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=2.0 tests=AWL,BAYES_00 autolearn=ham 
	version=3.0.2

simple_prepare_write and nobh_prepare_write leak uninitialised kernel data.
This happens because the prepare_write functions leave an uninitialised
"hole" over the part of the page that the write is expected to go to. This
is fine, but they then mark the page uptodate, which means a concurrent read
can come in and copy the uninitialised memory into userspace before it written
to.

Fix simple_readpage by simply initialising the whole page in the case of a
partial-page write. In the case of a full-page write, we don't SetPageDirty
until commit_write time.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -327,25 +327,32 @@ int simple_readpage(struct file *file, s
 int simple_prepare_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
-	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+	if (PageUptodate(page))
+		return 0;
+
+	if (to - from != PAGE_CACHE_SIZE) {
+		/*
+		 * Partial-page write? Initialise the complete page and
+		 * set it uptodate. We could avoid initialising the
+		 * (from, to) hole, and opt to mark it uptodate in
+		 * simple_commit_write, but that's probably only a win
+		 * for filesystems that would need to read blocks off disk.
+		 */
+		memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 	}
+
 	return 0;
 }
 
 int simple_commit_write(struct file *file, struct page *page,
-			unsigned offset, unsigned to)
+			unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	if (to - from == PAGE_CACHE_SIZE)
+		SetPageUptodate(page);
 	/*
 	 * No need to use i_size_read() here, the i_size
 	 * cannot change under us because we hold the i_mutex.
@@ -353,6 +360,7 @@ int simple_commit_write(struct file *fil
 	if (pos > inode->i_size)
 		i_size_write(inode, pos);
 	set_page_dirty(page);
+
 	return 0;
 }
 
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -2344,17 +2344,6 @@ int nobh_prepare_write(struct page *page
 
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
-	SetPageUptodate(page);
-
-	/*
-	 * Setting the page dirty here isn't necessary for the prepare_write
-	 * function - commit_write will do that.  But if/when this function is
-	 * used within the pagefault handler to ensure that all mmapped pages
-	 * have backing space in the filesystem, we will need to dirty the page
-	 * if its contents were altered.
-	 */
-	if (dirtied_it)
-		set_page_dirty(page);
 
 	return 0;
 
@@ -2384,6 +2373,7 @@ int nobh_commit_write(struct file *file,
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt
+++ linux-2.6/Documentation/filesystems/vfs.txt
@@ -617,6 +617,11 @@ struct address_space_operations {
 	In this case the prepare_write will be retried one the lock is
   	regained.
 
+	Note: the page _must not_ be marked uptodate in this function
+	(or anywhere else) unless it actually is uptodate right now. As
+	soon as a page is marked uptodate, it is possible for a concurrent
+	read(2) to copy it to userspace.
+
   commit_write: If prepare_write succeeds, new data will be copied
         into the page and then commit_write will be called.  It will
         typically update the size of the file (if appropriate) and

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
