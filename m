Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193F6C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2DE661422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhEEBlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBlE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60985611AB;
        Wed,  5 May 2021 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178807;
        bh=F7d4VaU1nEEJ0d8TNL4sFFueZMMFSVWT8H/a953VKO4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1ZSgrKmHetBbq7Iu85o5dXdgQA4d4Z0qIGTINoOw5BHJ7NMZz9Sw/y2G9BoSPxu0H
         RtgP16zhb8FEV0ewHn0U0Y8NYLXGFOK8jdF5SC1usFxtXLps8Opd1VnGDhq4mvTO6g
         Gx4tXxg1F4P5w/O4DVhWcUfvnk6A3wg1XMPKyJiM=
Date:   Tue, 04 May 2021 18:40:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chaitanya.kulkarni@wdc.com, clm@fb.com,
        dsterba@suse.com, ira.weiny@intel.com, josef@toxicpanda.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 136/143] btrfs: use memzero_page() instead of open
 coded kmap pattern
Message-ID: <20210505014007.GIiX6gfrP%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: btrfs: use memzero_page() instead of open coded kmap pattern

There are many places where kmap/memset/kunmap patterns occur.

Use the newly lifted memzero_page() to eliminate direct uses of kmap and
leverage the new core functions use of kmap_local_page().

The development of this patch was aided by the following coccinelle
script:

// <smpl>
// SPDX-License-Identifier: GPL-2.0-only
// Find kmap/memset/kunmap pattern and replace with memset*page calls
//
// NOTE: Offsets and other expressions may be more complex than what the script
// will automatically generate.  Therefore a catchall rule is provided to find
// the pattern which then must be evaluated by hand.
//
// Confidence: Low
// Copyright: (C) 2021 Intel Corporation
// URL: http://coccinelle.lip6.fr/
// Comments:
// Options:

//
// Then the memset pattern
//
@ memset_rule1 @
expression page, V, L, Off;
identifier ptr;
type VP;
@@

(
-VP ptr = kmap(page);
|
-ptr = kmap(page);
|
-VP ptr = kmap_atomic(page);
|
-ptr = kmap_atomic(page);
)
<+...
(
-memset(ptr, 0, L);
+memzero_page(page, 0, L);
|
-memset(ptr + Off, 0, L);
+memzero_page(page, Off, L);
|
-memset(ptr, V, L);
+memset_page(page, V, 0, L);
|
-memset(ptr + Off, V, L);
+memset_page(page, V, Off, L);
)
...+>
(
-kunmap(page);
|
-kunmap_atomic(ptr);
)

// Remove any pointers left unused
@
depends on memset_rule1
@
identifier memset_rule1.ptr;
type VP, VP1;
@@

-VP ptr;
	... when != ptr;
? VP1 ptr;

//
// Catch all
//
@ memset_rule2 @
expression page;
identifier ptr;
expression GenTo, GenSize, GenValue;
type VP;
@@

(
-VP ptr = kmap(page);
|
-ptr = kmap(page);
|
-VP ptr = kmap_atomic(page);
|
-ptr = kmap_atomic(page);
)
<+...
(
//
// Some call sites have complex expressions within the memset/memcpy
// The follow are catch alls which need to be evaluated by hand.
//
-memset(GenTo, 0, GenSize);
+memzero_pageExtra(page, GenTo, GenSize);
|
-memset(GenTo, GenValue, GenSize);
+memset_pageExtra(page, GenValue, GenTo, GenSize);
)
...+>
(
-kunmap(page);
|
-kunmap_atomic(ptr);
)

// Remove any pointers left unused
@
depends on memset_rule2
@
identifier memset_rule2.ptr;
type VP, VP1;
@@

-VP ptr;
	... when != ptr;
? VP1 ptr;

// </smpl>

Link: https://lkml.kernel.org/r/20210309212137.2610186-4-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c |    5 +----
 fs/btrfs/extent_io.c   |   22 ++++------------------
 fs/btrfs/inode.c       |   33 ++++++++++-----------------------
 fs/btrfs/reflink.c     |    6 +-----
 fs/btrfs/zlib.c        |    5 +----
 fs/btrfs/zstd.c        |    5 +----
 6 files changed, 18 insertions(+), 58 deletions(-)

--- a/fs/btrfs/compression.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/compression.c
@@ -591,16 +591,13 @@ static noinline int add_ra_bio_pages(str
 		free_extent_map(em);
 
 		if (page->index == end_index) {
-			char *userpage;
 			size_t zero_offset = offset_in_page(isize);
 
 			if (zero_offset) {
 				int zeros;
 				zeros = PAGE_SIZE - zero_offset;
-				userpage = kmap_atomic(page);
-				memset(userpage + zero_offset, 0, zeros);
+				memzero_page(page, zero_offset, zeros);
 				flush_dcache_page(page);
-				kunmap_atomic(userpage);
 			}
 		}
 
--- a/fs/btrfs/extent_io.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/extent_io.c
@@ -3421,15 +3421,12 @@ int btrfs_do_readpage(struct page *page,
 	}
 
 	if (page->index == last_byte >> PAGE_SHIFT) {
-		char *userpage;
 		size_t zero_offset = offset_in_page(last_byte);
 
 		if (zero_offset) {
 			iosize = PAGE_SIZE - zero_offset;
-			userpage = kmap_atomic(page);
-			memset(userpage + zero_offset, 0, iosize);
+			memzero_page(page, zero_offset, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage);
 		}
 	}
 	begin_page_read(fs_info, page);
@@ -3438,14 +3435,11 @@ int btrfs_do_readpage(struct page *page,
 		u64 disk_bytenr;
 
 		if (cur >= last_byte) {
-			char *userpage;
 			struct extent_state *cached = NULL;
 
 			iosize = PAGE_SIZE - pg_offset;
-			userpage = kmap_atomic(page);
-			memset(userpage + pg_offset, 0, iosize);
+			memzero_page(page, pg_offset, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
@@ -3528,13 +3522,10 @@ int btrfs_do_readpage(struct page *page,
 
 		/* we've found a hole, just zero and go on */
 		if (block_start == EXTENT_MAP_HOLE) {
-			char *userpage;
 			struct extent_state *cached = NULL;
 
-			userpage = kmap_atomic(page);
-			memset(userpage + pg_offset, 0, iosize);
+			memzero_page(page, pg_offset, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
@@ -3845,12 +3836,7 @@ static int __extent_writepage(struct pag
 	}
 
 	if (page->index == end_index) {
-		char *userpage;
-
-		userpage = kmap_atomic(page);
-		memset(userpage + pg_offset, 0,
-		       PAGE_SIZE - pg_offset);
-		kunmap_atomic(userpage);
+		memzero_page(page, pg_offset, PAGE_SIZE - pg_offset);
 		flush_dcache_page(page);
 	}
 
--- a/fs/btrfs/inode.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/inode.c
@@ -646,17 +646,12 @@ again:
 		if (!ret) {
 			unsigned long offset = offset_in_page(total_compressed);
 			struct page *page = pages[nr_pages - 1];
-			char *kaddr;
 
 			/* zero the tail end of the last page, we might be
 			 * sending it down to disk
 			 */
-			if (offset) {
-				kaddr = kmap_atomic(page);
-				memset(kaddr + offset, 0,
-				       PAGE_SIZE - offset);
-				kunmap_atomic(kaddr);
-			}
+			if (offset)
+				memzero_page(page, offset, PAGE_SIZE - offset);
 			will_compress = 1;
 		}
 	}
@@ -4833,7 +4828,6 @@ int btrfs_truncate_block(struct btrfs_in
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
-	char *kaddr;
 	bool only_release_metadata = false;
 	u32 blocksize = fs_info->sectorsize;
 	pgoff_t index = from >> PAGE_SHIFT;
@@ -4925,15 +4919,13 @@ again:
 	if (offset != blocksize) {
 		if (!len)
 			len = blocksize - offset;
-		kaddr = kmap(page);
 		if (front)
-			memset(kaddr + (block_start - page_offset(page)),
-				0, offset);
+			memzero_page(page, (block_start - page_offset(page)),
+				     offset);
 		else
-			memset(kaddr + (block_start - page_offset(page)) +  offset,
-				0, len);
+			memzero_page(page, (block_start - page_offset(page)) + offset,
+				     len);
 		flush_dcache_page(page);
-		kunmap(page);
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
@@ -6832,11 +6824,9 @@ static noinline int uncompress_inline(st
 	 * cover that region here.
 	 */
 
-	if (max_size + pg_offset < PAGE_SIZE) {
-		char *map = kmap(page);
-		memset(map + pg_offset + max_size, 0, PAGE_SIZE - max_size - pg_offset);
-		kunmap(page);
-	}
+	if (max_size + pg_offset < PAGE_SIZE)
+		memzero_page(page,  pg_offset + max_size,
+			     PAGE_SIZE - max_size - pg_offset);
 	kfree(tmp);
 	return ret;
 }
@@ -8506,7 +8496,6 @@ vm_fault_t btrfs_page_mkwrite(struct vm_
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
-	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
 	vm_fault_t ret;
@@ -8620,10 +8609,8 @@ again:
 		zero_start = PAGE_SIZE;
 
 	if (zero_start != PAGE_SIZE) {
-		kaddr = kmap(page);
-		memset(kaddr + zero_start, 0, PAGE_SIZE - zero_start);
+		memzero_page(page, zero_start, PAGE_SIZE - zero_start);
 		flush_dcache_page(page);
-		kunmap(page);
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
--- a/fs/btrfs/reflink.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/reflink.c
@@ -129,12 +129,8 @@ static int copy_inline_to_page(struct bt
 	 * So what's in the range [500, 4095] corresponds to zeroes.
 	 */
 	if (datal < block_size) {
-		char *map;
-
-		map = kmap(page);
-		memset(map + datal, 0, block_size - datal);
+		memzero_page(page, datal, block_size - datal);
 		flush_dcache_page(page);
-		kunmap(page);
 	}
 
 	SetPageUptodate(page);
--- a/fs/btrfs/zlib.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/zlib.c
@@ -375,7 +375,6 @@ int zlib_decompress(struct list_head *ws
 	unsigned long bytes_left;
 	unsigned long total_out = 0;
 	unsigned long pg_offset = 0;
-	char *kaddr;
 
 	destlen = min_t(unsigned long, destlen, PAGE_SIZE);
 	bytes_left = destlen;
@@ -455,9 +454,7 @@ next:
 	 * end of the inline extent (destlen) to the end of the page
 	 */
 	if (pg_offset < destlen) {
-		kaddr = kmap_atomic(dest_page);
-		memset(kaddr + pg_offset, 0, destlen - pg_offset);
-		kunmap_atomic(kaddr);
+		memzero_page(dest_page, pg_offset, destlen - pg_offset);
 	}
 	return ret;
 }
--- a/fs/btrfs/zstd.c~btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern
+++ a/fs/btrfs/zstd.c
@@ -631,7 +631,6 @@ int zstd_decompress(struct list_head *ws
 	size_t ret2;
 	unsigned long total_out = 0;
 	unsigned long pg_offset = 0;
-	char *kaddr;
 
 	stream = ZSTD_initDStream(
 			ZSTD_BTRFS_MAX_INPUT, workspace->mem, workspace->size);
@@ -696,9 +695,7 @@ int zstd_decompress(struct list_head *ws
 	ret = 0;
 finish:
 	if (pg_offset < destlen) {
-		kaddr = kmap_atomic(dest_page);
-		memset(kaddr + pg_offset, 0, destlen - pg_offset);
-		kunmap_atomic(kaddr);
+		memzero_page(dest_page, pg_offset, destlen - pg_offset);
 	}
 	return ret;
 }
_
