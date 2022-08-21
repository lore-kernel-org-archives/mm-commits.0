Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968E0C00140
	for <mm-commits@archiver.kernel.org>; Sun, 21 Aug 2022 23:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiHUXmO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Aug 2022 19:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiHUXmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Aug 2022 19:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A2F1FCFA
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 16:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8BB760DFF
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 23:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E0C433C1;
        Sun, 21 Aug 2022 23:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661125329;
        bh=mfu0Ho7AktSda2J5J0E+Ay4FNOILPC0jEuuxix3oDn8=;
        h=Date:To:From:Subject:From;
        b=a/L5Bm5Zdw6PIYZxR1C8boQF8j88kOFcfHqX2YZL8Ozkkx9LZswyszNR3dSGLjxMq
         PhUQykpV8enHFr8Z12mV2VUtMgrjbKlL5NTQ2e7m+keFryqh2gYmDWH8UoXnP0asKZ
         8fvBnDTqDBMmM4bIgJfb/yZv4ek28gKOluUZp108=
Date:   Sun, 21 Aug 2022 16:42:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        songmuchun@bytedance.com, slava@dubeyko.com,
        roman.gushchin@linux.dev, martin.petersen@oracle.com,
        keescook@chromium.org, kch@nvidia.com, jlayton@kernel.org,
        ira.weiny@intel.com, damien.lemoal@opensource.wdc.com,
        brauner@kernel.org, axboe@kernel.dk, arnd@arndb.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfs-replace-kmap-with-kmap_local_page-in-btreec.patch added to mm-nonmm-unstable branch
Message-Id: <20220821234209.253E0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: replace kmap() with kmap_local_page() in btree.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfs-replace-kmap-with-kmap_local_page-in-btreec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfs-replace-kmap-with-kmap_local_page-in-btreec.patch

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
Subject: hfs: replace kmap() with kmap_local_page() in btree.c
Date: Sun, 21 Aug 2022 20:04:00 +0200

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

Since its use in btree.c is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in btree.c.  Where
possible, use the suited standard helpers (memzero_page(), memcpy_page())
instead of open coding kmap_local_page() plus memset() or memcpy().

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220821180400.8198-4-fmdefrancesco@gmail.com
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

 fs/hfs/btree.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/fs/hfs/btree.c~hfs-replace-kmap-with-kmap_local_page-in-btreec
+++ a/fs/hfs/btree.c
@@ -80,7 +80,8 @@ struct hfs_btree *hfs_btree_open(struct
 		goto free_inode;
 
 	/* Load the header */
-	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
+	head = (struct hfs_btree_header_rec *)(kmap_local_page(page) +
+					       sizeof(struct hfs_bnode_desc));
 	tree->root = be32_to_cpu(head->root);
 	tree->leaf_count = be32_to_cpu(head->leaf_count);
 	tree->leaf_head = be32_to_cpu(head->leaf_head);
@@ -119,12 +120,12 @@ struct hfs_btree *hfs_btree_open(struct
 	tree->node_size_shift = ffs(size) - 1;
 	tree->pages_per_bnode = (tree->node_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	kunmap(page);
+	kunmap_local(head);
 	put_page(page);
 	return tree;
 
 fail_page:
-	kunmap(page);
+	kunmap_local(head);
 	put_page(page);
 free_inode:
 	tree->inode->i_mapping->a_ops = &hfs_aops;
@@ -170,7 +171,8 @@ void hfs_btree_write(struct hfs_btree *t
 		return;
 	/* Load the header */
 	page = node->page[0];
-	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
+	head = (struct hfs_btree_header_rec *)(kmap_local_page(page) +
+					       sizeof(struct hfs_bnode_desc));
 
 	head->root = cpu_to_be32(tree->root);
 	head->leaf_count = cpu_to_be32(tree->leaf_count);
@@ -181,7 +183,7 @@ void hfs_btree_write(struct hfs_btree *t
 	head->attributes = cpu_to_be32(tree->attributes);
 	head->depth = cpu_to_be16(tree->depth);
 
-	kunmap(page);
+	kunmap_local(head);
 	set_page_dirty(page);
 	hfs_bnode_put(node);
 }
@@ -269,7 +271,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 
 	off += node->page_offset;
 	pagep = node->page + (off >> PAGE_SHIFT);
-	data = kmap(*pagep);
+	data = kmap_local_page(*pagep);
 	off &= ~PAGE_MASK;
 	idx = 0;
 
@@ -282,7 +284,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 						idx += i;
 						data[off] |= m;
 						set_page_dirty(*pagep);
-						kunmap(*pagep);
+						kunmap_local(data);
 						tree->free_nodes--;
 						mark_inode_dirty(tree->inode);
 						hfs_bnode_put(node);
@@ -291,14 +293,14 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 				}
 			}
 			if (++off >= PAGE_SIZE) {
-				kunmap(*pagep);
-				data = kmap(*++pagep);
+				kunmap_local(data);
+				data = kmap_local_page(*++pagep);
 				off = 0;
 			}
 			idx += 8;
 			len--;
 		}
-		kunmap(*pagep);
+		kunmap_local(data);
 		nidx = node->next;
 		if (!nidx) {
 			printk(KERN_DEBUG "create new bmap node...\n");
@@ -314,7 +316,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 		off = off16;
 		off += node->page_offset;
 		pagep = node->page + (off >> PAGE_SHIFT);
-		data = kmap(*pagep);
+		data = kmap_local_page(*pagep);
 		off &= ~PAGE_MASK;
 	}
 }
@@ -361,20 +363,20 @@ void hfs_bmap_free(struct hfs_bnode *nod
 	}
 	off += node->page_offset + nidx / 8;
 	page = node->page[off >> PAGE_SHIFT];
-	data = kmap(page);
+	data = kmap_local_page(page);
 	off &= ~PAGE_MASK;
 	m = 1 << (~nidx & 7);
 	byte = data[off];
 	if (!(byte & m)) {
 		pr_crit("trying to free free bnode %u(%d)\n",
 			node->this, node->type);
-		kunmap(page);
+		kunmap_local(data);
 		hfs_bnode_put(node);
 		return;
 	}
 	data[off] = byte & ~m;
 	set_page_dirty(page);
-	kunmap(page);
+	kunmap_local(data);
 	hfs_bnode_put(node);
 	tree->free_nodes++;
 	mark_inode_dirty(tree->inode);
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

