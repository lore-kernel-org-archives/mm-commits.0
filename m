Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD999C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiILE4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiILE4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1119220D8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F17560CFA
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DC8C433D6;
        Mon, 12 Sep 2022 04:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958572;
        bh=Vdg7BCilbugNJP85VMQ7urJd+gdgod5oGgohJTE0bGg=;
        h=Date:To:From:Subject:From;
        b=l6txwEd0NiFdKNsxnrmbANRyKZqr8+hT5sBGt3ODvbErQDW64u1+0oqIDVsyNCJqF
         QbgrNZEysRUxKRbAkbevnopzCMzQOGK0JfH4EcorRUehUOhKsvlm/GEF9tGMPXNPHA
         tT48Xh9WKPFGczrJqoe167JbysptPPn5C+r+80kQ=
Date:   Sun, 11 Sep 2022 21:56:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, slava@dubeyko.com, keescook@chromium.org,
        ira.weiny@intel.com, bvanassche@acm.org, axboe@kernel.dk,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch removed from -mm tree
Message-Id: <20220912045612.92DC8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus: convert kmap() to kmap_local_page() in bnode.c
has been removed from the -mm tree.  Its filename was
     hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfsplus: convert kmap() to kmap_local_page() in bnode.c
Date: Tue, 9 Aug 2022 22:31:03 +0200

kmap() is being deprecated in favor of kmap_local_page().

Two main problems with kmap(): (1) It comes with an overhead as mapping
space is restricted and protected by a global lock for synchronization and
(2) it also requires global TLB invalidation when the kmap's pool wraps
and it might block when the mapping space is fully utilized until a slot
becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and still valid.

Since its use in bnode.c is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in bnode.c.  Where
possible, use the suited standard helpers (memzero_page(), memcpy_page())
instead of open coding kmap_local_page() plus memset() or memcpy().

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220809203105.26183-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bnode.c |  105 +++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 57 deletions(-)

--- a/fs/hfsplus/bnode.c~hfsplus-convert-kmap-to-kmap_local_page-in-bnodec
+++ a/fs/hfsplus/bnode.c
@@ -29,14 +29,12 @@ void hfs_bnode_read(struct hfs_bnode *no
 	off &= ~PAGE_MASK;
 
 	l = min_t(int, len, PAGE_SIZE - off);
-	memcpy(buf, kmap(*pagep) + off, l);
-	kunmap(*pagep);
+	memcpy_from_page(buf, *pagep, off, l);
 
 	while ((len -= l) != 0) {
 		buf += l;
 		l = min_t(int, len, PAGE_SIZE);
-		memcpy(buf, kmap(*++pagep), l);
-		kunmap(*pagep);
+		memcpy_from_page(buf, *++pagep, 0, l);
 	}
 }
 
@@ -82,16 +80,14 @@ void hfs_bnode_write(struct hfs_bnode *n
 	off &= ~PAGE_MASK;
 
 	l = min_t(int, len, PAGE_SIZE - off);
-	memcpy(kmap(*pagep) + off, buf, l);
+	memcpy_to_page(*pagep, off, buf, l);
 	set_page_dirty(*pagep);
-	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		buf += l;
 		l = min_t(int, len, PAGE_SIZE);
-		memcpy(kmap(*++pagep), buf, l);
+		memcpy_to_page(*++pagep, 0, buf, l);
 		set_page_dirty(*pagep);
-		kunmap(*pagep);
 	}
 }
 
@@ -112,15 +108,13 @@ void hfs_bnode_clear(struct hfs_bnode *n
 	off &= ~PAGE_MASK;
 
 	l = min_t(int, len, PAGE_SIZE - off);
-	memset(kmap(*pagep) + off, 0, l);
+	memzero_page(*pagep, off, l);
 	set_page_dirty(*pagep);
-	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		l = min_t(int, len, PAGE_SIZE);
-		memset(kmap(*++pagep), 0, l);
+		memzero_page(*++pagep, 0, l);
 		set_page_dirty(*pagep);
-		kunmap(*pagep);
 	}
 }
 
@@ -142,24 +136,20 @@ void hfs_bnode_copy(struct hfs_bnode *ds
 
 	if (src == dst) {
 		l = min_t(int, len, PAGE_SIZE - src);
-		memcpy(kmap(*dst_page) + src, kmap(*src_page) + src, l);
-		kunmap(*src_page);
+		memcpy_page(*dst_page, src, *src_page, src, l);
 		set_page_dirty(*dst_page);
-		kunmap(*dst_page);
 
 		while ((len -= l) != 0) {
 			l = min_t(int, len, PAGE_SIZE);
-			memcpy(kmap(*++dst_page), kmap(*++src_page), l);
-			kunmap(*src_page);
+			memcpy_page(*++dst_page, 0, *++src_page, 0, l);
 			set_page_dirty(*dst_page);
-			kunmap(*dst_page);
 		}
 	} else {
 		void *src_ptr, *dst_ptr;
 
 		do {
-			src_ptr = kmap(*src_page) + src;
-			dst_ptr = kmap(*dst_page) + dst;
+			dst_ptr = kmap_local_page(*dst_page) + dst;
+			src_ptr = kmap_local_page(*src_page) + src;
 			if (PAGE_SIZE - src < PAGE_SIZE - dst) {
 				l = PAGE_SIZE - src;
 				src = 0;
@@ -171,9 +161,9 @@ void hfs_bnode_copy(struct hfs_bnode *ds
 			}
 			l = min(len, l);
 			memcpy(dst_ptr, src_ptr, l);
-			kunmap(*src_page);
+			kunmap_local(src_ptr);
 			set_page_dirty(*dst_page);
-			kunmap(*dst_page);
+			kunmap_local(dst_ptr);
 			if (!dst)
 				dst_page++;
 			else
@@ -185,6 +175,7 @@ void hfs_bnode_copy(struct hfs_bnode *ds
 void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 {
 	struct page **src_page, **dst_page;
+	void *src_ptr, *dst_ptr;
 	int l;
 
 	hfs_dbg(BNODE_MOD, "movebytes: %u,%u,%u\n", dst, src, len);
@@ -202,27 +193,28 @@ void hfs_bnode_move(struct hfs_bnode *no
 
 		if (src == dst) {
 			while (src < len) {
-				memmove(kmap(*dst_page), kmap(*src_page), src);
-				kunmap(*src_page);
+				dst_ptr = kmap_local_page(*dst_page);
+				src_ptr = kmap_local_page(*src_page);
+				memmove(dst_ptr, src_ptr, src);
+				kunmap_local(src_ptr);
 				set_page_dirty(*dst_page);
-				kunmap(*dst_page);
+				kunmap_local(dst_ptr);
 				len -= src;
 				src = PAGE_SIZE;
 				src_page--;
 				dst_page--;
 			}
 			src -= len;
-			memmove(kmap(*dst_page) + src,
-				kmap(*src_page) + src, len);
-			kunmap(*src_page);
+			dst_ptr = kmap_local_page(*dst_page);
+			src_ptr = kmap_local_page(*src_page);
+			memmove(dst_ptr + src, src_ptr + src, len);
+			kunmap_local(src_ptr);
 			set_page_dirty(*dst_page);
-			kunmap(*dst_page);
+			kunmap_local(dst_ptr);
 		} else {
-			void *src_ptr, *dst_ptr;
-
 			do {
-				src_ptr = kmap(*src_page) + src;
-				dst_ptr = kmap(*dst_page) + dst;
+				dst_ptr = kmap_local_page(*dst_page) + dst;
+				src_ptr = kmap_local_page(*src_page) + src;
 				if (src < dst) {
 					l = src;
 					src = PAGE_SIZE;
@@ -234,9 +226,9 @@ void hfs_bnode_move(struct hfs_bnode *no
 				}
 				l = min(len, l);
 				memmove(dst_ptr - l, src_ptr - l, l);
-				kunmap(*src_page);
+				kunmap_local(src_ptr);
 				set_page_dirty(*dst_page);
-				kunmap(*dst_page);
+				kunmap_local(dst_ptr);
 				if (dst == PAGE_SIZE)
 					dst_page--;
 				else
@@ -251,26 +243,27 @@ void hfs_bnode_move(struct hfs_bnode *no
 
 		if (src == dst) {
 			l = min_t(int, len, PAGE_SIZE - src);
-			memmove(kmap(*dst_page) + src,
-				kmap(*src_page) + src, l);
-			kunmap(*src_page);
+
+			dst_ptr = kmap_local_page(*dst_page) + src;
+			src_ptr = kmap_local_page(*src_page) + src;
+			memmove(dst_ptr, src_ptr, l);
+			kunmap_local(src_ptr);
 			set_page_dirty(*dst_page);
-			kunmap(*dst_page);
+			kunmap_local(dst_ptr);
 
 			while ((len -= l) != 0) {
 				l = min_t(int, len, PAGE_SIZE);
-				memmove(kmap(*++dst_page),
-					kmap(*++src_page), l);
-				kunmap(*src_page);
+				dst_ptr = kmap_local_page(*++dst_page);
+				src_ptr = kmap_local_page(*++src_page);
+				memmove(dst_ptr, src_ptr, l);
+				kunmap_local(src_ptr);
 				set_page_dirty(*dst_page);
-				kunmap(*dst_page);
+				kunmap_local(dst_ptr);
 			}
 		} else {
-			void *src_ptr, *dst_ptr;
-
 			do {
-				src_ptr = kmap(*src_page) + src;
-				dst_ptr = kmap(*dst_page) + dst;
+				dst_ptr = kmap_local_page(*dst_page) + dst;
+				src_ptr = kmap_local_page(*src_page) + src;
 				if (PAGE_SIZE - src <
 						PAGE_SIZE - dst) {
 					l = PAGE_SIZE - src;
@@ -283,9 +276,9 @@ void hfs_bnode_move(struct hfs_bnode *no
 				}
 				l = min(len, l);
 				memmove(dst_ptr, src_ptr, l);
-				kunmap(*src_page);
+				kunmap_local(src_ptr);
 				set_page_dirty(*dst_page);
-				kunmap(*dst_page);
+				kunmap_local(dst_ptr);
 				if (!dst)
 					dst_page++;
 				else
@@ -498,14 +491,14 @@ struct hfs_bnode *hfs_bnode_find(struct
 	if (!test_bit(HFS_BNODE_NEW, &node->flags))
 		return node;
 
-	desc = (struct hfs_bnode_desc *)(kmap(node->page[0]) +
-			node->page_offset);
+	desc = (struct hfs_bnode_desc *)(kmap_local_page(node->page[0]) +
+							 node->page_offset);
 	node->prev = be32_to_cpu(desc->prev);
 	node->next = be32_to_cpu(desc->next);
 	node->num_recs = be16_to_cpu(desc->num_recs);
 	node->type = desc->type;
 	node->height = desc->height;
-	kunmap(node->page[0]);
+	kunmap_local(desc);
 
 	switch (node->type) {
 	case HFS_NODE_HEADER:
@@ -589,14 +582,12 @@ struct hfs_bnode *hfs_bnode_create(struc
 	}
 
 	pagep = node->page;
-	memset(kmap(*pagep) + node->page_offset, 0,
-	       min_t(int, PAGE_SIZE, tree->node_size));
+	memzero_page(*pagep, node->page_offset,
+		     min_t(int, PAGE_SIZE, tree->node_size));
 	set_page_dirty(*pagep);
-	kunmap(*pagep);
 	for (i = 1; i < tree->pages_per_bnode; i++) {
-		memset(kmap(*++pagep), 0, PAGE_SIZE);
+		memzero_page(*++pagep, 0, PAGE_SIZE);
 		set_page_dirty(*pagep);
-		kunmap(*pagep);
 	}
 	clear_bit(HFS_BNODE_NEW, &node->flags);
 	wake_up(&node->lock_wq);
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


