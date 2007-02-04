From: akpm@linux-foundation.org
Subject: - mm-revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:05:36 -0800
Message-ID: <200702040905.l1495aVw026098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbXBDJFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:05:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     From: Nick Piggin <npiggin@suse.de>
has been removed from the -mm tree.  Its filename was
     mm-revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: From: Nick Piggin <npiggin@suse.de>
From: Nick Piggin <npiggin@suse.de>
Return-Path: <npiggin@suse.de>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l148oufJ016774
	for <akpm@localhost>; Sun, 4 Feb 2007 00:50:56 -0800
Received: from bix [127.0.0.1]
	by localhost with POP3 (fetchmail-6.2.0)
	for akpm@localhost (single-drop); Sun, 04 Feb 2007 00:50:56 -0800 (PST)
Received: from smtp1.osdl.org (smtp1.osdl.org [65.172.181.25])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l148oBZU025833
	for <akpm@mail.gateway.osdl.net>; Sun, 4 Feb 2007 00:50:11 -0800
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by smtp1.osdl.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l148o3oe002422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <akpm@osdl.org>; Sun, 4 Feb 2007 00:50:06 -0800
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 599FE2162A;
	Sun,  4 Feb 2007 09:50:03 +0100 (CET)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Filesystems <linux-fsdevel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063726.23659.83287.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 2/9] mm: revert "generic_file_buffered_write(): handle zero length iovec segments"
Date: Sun,  4 Feb 2007 09:50:00 +0100 (CET)
Received-SPF: none (domain of npiggin@suse.de does not designate permitted sender hosts)
X-MIMEDefang-Filter: osdl$Revision: 1.173 $
X-Scanned-By: MIMEDefang 2.53 on 65.172.181.25
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=2.0 tests=AWL,BAYES_00 autolearn=ham 
	version=3.0.2


Revert 81b0c8713385ce1b1b9058e916edcf9561ad76d6.

This was a bugfix against 6527c2bdf1f833cc18e8f42bd97973d583e4aa83, which we
also revert.

Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2120,12 +2120,6 @@ generic_file_buffered_write(struct kiocb
 			break;
 		}
 
-		if (unlikely(bytes == 0)) {
-			status = 0;
-			copied = 0;
-			goto zero_length_segment;
-		}
-
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
 		if (unlikely(status)) {
 			loff_t isize = i_size_read(inode);
@@ -2155,8 +2149,7 @@ generic_file_buffered_write(struct kiocb
 			page_cache_release(page);
 			continue;
 		}
-zero_length_segment:
-		if (likely(copied >= 0)) {
+		if (likely(copied > 0)) {
 			if (!status)
 				status = copied;
 
Index: linux-2.6/mm/filemap.h
===================================================================
--- linux-2.6.orig/mm/filemap.h
+++ linux-2.6/mm/filemap.h
@@ -87,7 +87,7 @@ filemap_set_next_iovec(const struct iove
 	const struct iovec *iov = *iovp;
 	size_t base = *basep;
 
-	do {
+	while (bytes) {
 		int copy = min(bytes, iov->iov_len - base);
 
 		bytes -= copy;
@@ -96,7 +96,7 @@ filemap_set_next_iovec(const struct iove
 			iov++;
 			base = 0;
 		}
-	} while (bytes);
+	}
 	*iovp = iov;
 	*basep = base;
 }

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
