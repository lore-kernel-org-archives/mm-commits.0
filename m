Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CF3C32789
	for <mm-commits@archiver.kernel.org>; Sun, 21 Aug 2022 23:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiHUXmJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Aug 2022 19:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiHUXmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Aug 2022 19:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD7F1FCE7
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 16:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92AC760DFF
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7FEC433D7;
        Sun, 21 Aug 2022 23:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661125327;
        bh=7NjURfBVb0oODffCRC4v/YFlbY9mYH1LSIP8FMqna9Q=;
        h=Date:To:From:Subject:From;
        b=MJBVgIvdi16QLt6JY1uvE+XC9hcPvSEwf2H3EogVep2Q4im61sHRbjMkT9HJX3uM4
         nEVQDWemne3TWp129EZjHIbdFB4mIbrozj5OU+lGROXUYJL772udCJ1pGHnggLr1nK
         dFz9BSJJ83iixpdPG+fnbJuFkBI8KYiPFhHezkso=
Date:   Sun, 21 Aug 2022 16:42:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        songmuchun@bytedance.com, slava@dubeyko.com,
        roman.gushchin@linux.dev, martin.petersen@oracle.com,
        keescook@chromium.org, kch@nvidia.com, jlayton@kernel.org,
        ira.weiny@intel.com, damien.lemoal@opensource.wdc.com,
        brauner@kernel.org, axboe@kernel.dk, arnd@arndb.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfs-replace-kmap-with-kmap_local_page-in-bnodec.patch added to mm-nonmm-unstable branch
Message-Id: <20220821234206.DF7FEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: replace kmap() with kmap_local_page() in bnode.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfs-replace-kmap-with-kmap_local_page-in-bnodec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfs-replace-kmap-with-kmap_local_page-in-bnodec.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfs: replace kmap() with kmap_local_page() in bnode.c
Date: Sun, 21 Aug 2022 20:03:59 +0200

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

Link: https://lkml.kernel.org/r/20220821180400.8198-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bnode.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/fs/hfs/bnode.c~hfs-replace-kmap-with-kmap_local_page-in-bnodec
+++ a/fs/hfs/bnode.c
@@ -21,7 +21,6 @@ void hfs_bnode_read(struct hfs_bnode *no
 	int pagenum;
 	int bytes_read;
 	int bytes_to_read;
-	void *vaddr;
 
 	off += node->page_offset;
 	pagenum = off >> PAGE_SHIFT;
@@ -33,9 +32,7 @@ void hfs_bnode_read(struct hfs_bnode *no
 		page = node->page[pagenum];
 		bytes_to_read = min_t(int, len - bytes_read, PAGE_SIZE - off);
 
-		vaddr = kmap_atomic(page);
-		memcpy(buf + bytes_read, vaddr + off, bytes_to_read);
-		kunmap_atomic(vaddr);
+		memcpy_from_page(buf + bytes_read, page, off, bytes_to_read);
 
 		pagenum++;
 		off = 0; /* page offset only applies to the first page */
@@ -80,8 +77,7 @@ void hfs_bnode_write(struct hfs_bnode *n
 	off += node->page_offset;
 	page = node->page[0];
 
-	memcpy(kmap(page) + off, buf, len);
-	kunmap(page);
+	memcpy_to_page(page, off, buf, len);
 	set_page_dirty(page);
 }
 
@@ -105,8 +101,7 @@ void hfs_bnode_clear(struct hfs_bnode *n
 	off += node->page_offset;
 	page = node->page[0];
 
-	memset(kmap(page) + off, 0, len);
-	kunmap(page);
+	memzero_page(page, off, len);
 	set_page_dirty(page);
 }
 
@@ -123,9 +118,7 @@ void hfs_bnode_copy(struct hfs_bnode *ds
 	src_page = src_node->page[0];
 	dst_page = dst_node->page[0];
 
-	memcpy(kmap(dst_page) + dst, kmap(src_page) + src, len);
-	kunmap(src_page);
-	kunmap(dst_page);
+	memcpy_page(dst_page, dst, src_page, src, len);
 	set_page_dirty(dst_page);
 }
 
@@ -140,9 +133,9 @@ void hfs_bnode_move(struct hfs_bnode *no
 	src += node->page_offset;
 	dst += node->page_offset;
 	page = node->page[0];
-	ptr = kmap(page);
+	ptr = kmap_local_page(page);
 	memmove(ptr + dst, ptr + src, len);
-	kunmap(page);
+	kunmap_local(ptr);
 	set_page_dirty(page);
 }
 
@@ -346,13 +339,14 @@ struct hfs_bnode *hfs_bnode_find(struct
 	if (!test_bit(HFS_BNODE_NEW, &node->flags))
 		return node;
 
-	desc = (struct hfs_bnode_desc *)(kmap(node->page[0]) + node->page_offset);
+	desc = (struct hfs_bnode_desc *)(kmap_local_page(node->page[0]) +
+					 node->page_offset);
 	node->prev = be32_to_cpu(desc->prev);
 	node->next = be32_to_cpu(desc->next);
 	node->num_recs = be16_to_cpu(desc->num_recs);
 	node->type = desc->type;
 	node->height = desc->height;
-	kunmap(node->page[0]);
+	kunmap_local(desc);
 
 	switch (node->type) {
 	case HFS_NODE_HEADER:
@@ -436,14 +430,12 @@ struct hfs_bnode *hfs_bnode_create(struc
 	}
 
 	pagep = node->page;
-	memset(kmap(*pagep) + node->page_offset, 0,
-	       min((int)PAGE_SIZE, (int)tree->node_size));
+	memzero_page(*pagep, node->page_offset,
+		     min((int)PAGE_SIZE, (int)tree->node_size));
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

hfsplus-unmap-the-page-in-the-fail_page-label.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch
hfsplus-convert-kmap-to-kmap_local_page-in-btreec.patch
fs-isofs-replace-kmap-with-kmap_local_page.patch
kexec-replace-kmap-with-kmap_local_page.patch
hfs-unmap-the-page-in-the-fail_page-label.patch
hfs-replace-kmap-with-kmap_local_page-in-bnodec.patch
hfs-replace-kmap-with-kmap_local_page-in-btreec.patch

