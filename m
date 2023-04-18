Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F12C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjDRXeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDRXd7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819C5E7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C9C639E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7E8C433D2;
        Tue, 18 Apr 2023 23:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860835;
        bh=SPoecChIP5wXfCLVsv19RTrCA1CIlwqEKBFgU2y2gLk=;
        h=Date:To:From:Subject:From;
        b=gD5am+lJPowgkTQiJkuPg+d7Gu3m5mQOJYNNPhID/RpHNdtn9HJzmXxe7UBHmEyvp
         IKDF/pIJD8DsY2NsjTyV2p5Z8SXefn8eAvW3J09PDCdqrXWtnQZjncP5hHY/UIt5Jm
         RP7BQTM8rI/APt1eGEbley3UqGQPRoWxx0oh3lyI=
Date:   Tue, 18 Apr 2023 16:33:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-rename-addr_to_vb_xarray-function.patch removed from -mm tree
Message-Id: <20230418233355.BB7E8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: rename addr_to_vb_xarray() function
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-rename-addr_to_vb_xarray-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: rename addr_to_vb_xarray() function
Date: Fri, 31 Mar 2023 09:37:27 +0200

Short the name of the addr_to_vb_xarray() function to the addr_to_vb_xa().
This aligns with other internal function abbreviations.

Link: https://lkml.kernel.org/r/20230331073727.6968-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-rename-addr_to_vb_xarray-function
+++ a/mm/vmalloc.c
@@ -1949,7 +1949,7 @@ static DEFINE_PER_CPU(struct vmap_block_
  * used as a hash table. When used as a hash a 'cpu' passed to
  * per_cpu() is not actually a CPU but rather a hash index.
  *
- * A hash function is addr_to_vb_xarray() which hashes any address
+ * A hash function is addr_to_vb_xa() which hashes any address
  * to a specific index(in a hash) it belongs to. This then uses a
  * per_cpu() macro to access an array with generated index.
  *
@@ -1975,7 +1975,7 @@ static DEFINE_PER_CPU(struct vmap_block_
  * however xarray spinlocks protect against any contention that remains.
  */
 static struct xarray *
-addr_to_vb_xarray(unsigned long addr)
+addr_to_vb_xa(unsigned long addr)
 {
 	int index = (addr / VMAP_BLOCK_SIZE) % num_possible_cpus();
 
@@ -2052,7 +2052,7 @@ static void *new_vmap_block(unsigned int
 	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
 
-	xa = addr_to_vb_xarray(va->va_start);
+	xa = addr_to_vb_xa(va->va_start);
 	vb_idx = addr_to_vb_idx(va->va_start);
 	err = xa_insert(xa, vb_idx, vb, gfp_mask);
 	if (err) {
@@ -2074,7 +2074,7 @@ static void free_vmap_block(struct vmap_
 	struct vmap_block *tmp;
 	struct xarray *xa;
 
-	xa = addr_to_vb_xarray(vb->va->va_start);
+	xa = addr_to_vb_xa(vb->va->va_start);
 	tmp = xa_erase(xa, addr_to_vb_idx(vb->va->va_start));
 	BUG_ON(tmp != vb);
 
@@ -2197,7 +2197,7 @@ static void vb_free(unsigned long addr,
 	order = get_order(size);
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
 
-	xa = addr_to_vb_xarray(addr);
+	xa = addr_to_vb_xa(addr);
 	vb = xa_load(xa, addr_to_vb_idx(addr));
 
 	spin_lock(&vb->lock);
@@ -3596,7 +3596,7 @@ static size_t vmap_ram_vread_iter(struct
 	 * Area is split into regions and tracked with vmap_block, read out
 	 * each region and zero fill the hole between regions.
 	 */
-	xa = addr_to_vb_xarray((unsigned long) addr);
+	xa = addr_to_vb_xa((unsigned long) addr);
 	vb = xa_load(xa, addr_to_vb_idx((unsigned long)addr));
 	if (!vb)
 		goto finished_zero;
_

Patches currently in -mm which might be from urezki@gmail.com are


