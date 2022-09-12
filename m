Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F220C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiILE4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiILE4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6D6220EA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B2A3B80BA8
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99521C433D7;
        Mon, 12 Sep 2022 04:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958580;
        bh=hZHQYgBj+aoepqTTkUaE071+sxMisCNOGWlUiYuEVz0=;
        h=Date:To:From:Subject:From;
        b=Od3WU0v5vi5cV77Q3RZKED/uTbLQikSDqR2OMseg1fcHFY30p9VICKq9b+aganAew
         k/Yts64J1/VEZmw0gQPGvMaCG9K7yBxMUuw/5Sy12HV6PcgeZg7HUiYXrpEJgGbJUX
         wh5F1nhl45YekVyLx/4h0RpjWzHKLWKOhsD7gn/o=
Date:   Sun, 11 Sep 2022 21:56:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        pali@kernel.org, jack@suse.cz, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-isofs-replace-kmap-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20220912045620.99521C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/isofs: replace kmap() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     fs-isofs-replace-kmap-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: fs/isofs: replace kmap() with kmap_local_page()
Date: Mon, 1 Aug 2022 14:27:09 +0200

The use of kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
Tasks can be preempted and, when scheduled to run again, the kernel
virtual addresses are restored and still valid.  It is faster than kmap()
in kernels with HIGHMEM enabled.

Since kmap_local_page() can be safely used in compress.c, it should be
called everywhere instead of kmap().

Therefore, replace kmap() with kmap_local_page() in compress.c.  Where it
is needed, use memzero_page() instead of open coding kmap_local_page()
plus memset() to fill the pages with zeros.  Delete the redundant
flush_dcache_page() in the two call sites of memzero_page().

Tested with mkisofs on a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel
with HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220801122709.8164-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Pali Rohár <pali@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/isofs/compress.c~fs-isofs-replace-kmap-with-kmap_local_page
+++ a/fs/isofs/compress.c
@@ -67,8 +67,7 @@ static loff_t zisofs_uncompress_block(st
 		for ( i = 0 ; i < pcount ; i++ ) {
 			if (!pages[i])
 				continue;
-			memset(page_address(pages[i]), 0, PAGE_SIZE);
-			flush_dcache_page(pages[i]);
+			memzero_page(pages[i], 0, PAGE_SIZE);
 			SetPageUptodate(pages[i]);
 		}
 		return ((loff_t)pcount) << PAGE_SHIFT;
@@ -120,7 +119,7 @@ static loff_t zisofs_uncompress_block(st
 	       zerr != Z_STREAM_END) {
 		if (!stream.avail_out) {
 			if (pages[curpage]) {
-				stream.next_out = page_address(pages[curpage])
+				stream.next_out = kmap_local_page(pages[curpage])
 						+ poffset;
 				stream.avail_out = PAGE_SIZE - poffset;
 				poffset = 0;
@@ -176,6 +175,10 @@ static loff_t zisofs_uncompress_block(st
 				flush_dcache_page(pages[curpage]);
 				SetPageUptodate(pages[curpage]);
 			}
+			if (stream.next_out != (unsigned char *)zisofs_sink_page) {
+				kunmap_local(stream.next_out);
+				stream.next_out = NULL;
+			}
 			curpage++;
 		}
 		if (!stream.avail_in)
@@ -183,6 +186,8 @@ static loff_t zisofs_uncompress_block(st
 	}
 inflate_out:
 	zlib_inflateEnd(&stream);
+	if (stream.next_out && stream.next_out != (unsigned char *)zisofs_sink_page)
+		kunmap_local(stream.next_out);
 
 z_eio:
 	mutex_unlock(&zisofs_zlib_lock);
@@ -283,9 +288,7 @@ static int zisofs_fill_pages(struct inod
 	}
 
 	if (poffset && *pages) {
-		memset(page_address(*pages) + poffset, 0,
-		       PAGE_SIZE - poffset);
-		flush_dcache_page(*pages);
+		memzero_page(*pages, poffset, PAGE_SIZE - poffset);
 		SetPageUptodate(*pages);
 	}
 	return 0;
@@ -343,10 +346,8 @@ static int zisofs_read_folio(struct file
 	for (i = 0; i < pcount; i++, index++) {
 		if (i != full_page)
 			pages[i] = grab_cache_page_nowait(mapping, index);
-		if (pages[i]) {
+		if (pages[i])
 			ClearPageError(pages[i]);
-			kmap(pages[i]);
-		}
 	}
 
 	err = zisofs_fill_pages(inode, full_page, pcount, pages);
@@ -357,7 +358,6 @@ static int zisofs_read_folio(struct file
 			flush_dcache_page(pages[i]);
 			if (i == full_page && err)
 				SetPageError(pages[i]);
-			kunmap(pages[i]);
 			unlock_page(pages[i]);
 			if (i != full_page)
 				put_page(pages[i]);
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


