Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6EDC761A6
	for <mm-commits@archiver.kernel.org>; Fri, 31 Mar 2023 22:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjCaWPn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjCaWPh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2023 18:15:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E3020619
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 15:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F6EB8321E
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 22:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D87C433D2;
        Fri, 31 Mar 2023 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680300819;
        bh=V8O03vcmAeJEzRwUe5rdNGVndy4BJhdEYaI6MZmEYzI=;
        h=Date:To:From:Subject:From;
        b=C/ZBTLweZa3S6XVBrtnFd6nqThmqi2b9DK6EVNR850XI4fqHITGClervjXh1nIW8T
         9z5StQO4WhntOSCNWTUNIXGmtxbnRgsJU+p0Oyi5V+XrKATDoe63t+kZF0vqx4fDS4
         1K4Bfdpsfiiq+dTSeTakKdZjvfKtKSg8s/AuVzyE=
Date:   Fri, 31 Mar 2023 15:13:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-rename-addr_to_vb_xarray-function.patch added to mm-unstable branch
Message-Id: <20230331221339.D4D87C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: rename addr_to_vb_xarray() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-rename-addr_to_vb_xarray-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-rename-addr_to_vb_xarray-function.patch

This patch will later appear in the mm-unstable branch at
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
@@ -1945,7 +1945,7 @@ static DEFINE_PER_CPU(struct vmap_block_
  * used as a hash table. When used as a hash a 'cpu' passed to
  * per_cpu() is not actually a CPU but rather a hash index.
  *
- * A hash function is addr_to_vb_xarray() which hashes any address
+ * A hash function is addr_to_vb_xa() which hashes any address
  * to a specific index(in a hash) it belongs to. This then uses a
  * per_cpu() macro to access an array with generated index.
  *
@@ -1971,7 +1971,7 @@ static DEFINE_PER_CPU(struct vmap_block_
  * however xarray spinlocks protect against any contention that remains.
  */
 static struct xarray *
-addr_to_vb_xarray(unsigned long addr)
+addr_to_vb_xa(unsigned long addr)
 {
 	int index = (addr / VMAP_BLOCK_SIZE) % num_possible_cpus();
 
@@ -2048,7 +2048,7 @@ static void *new_vmap_block(unsigned int
 	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
 
-	xa = addr_to_vb_xarray(va->va_start);
+	xa = addr_to_vb_xa(va->va_start);
 	vb_idx = addr_to_vb_idx(va->va_start);
 	err = xa_insert(xa, vb_idx, vb, gfp_mask);
 	if (err) {
@@ -2070,7 +2070,7 @@ static void free_vmap_block(struct vmap_
 	struct vmap_block *tmp;
 	struct xarray *xa;
 
-	xa = addr_to_vb_xarray(vb->va->va_start);
+	xa = addr_to_vb_xa(vb->va->va_start);
 	tmp = xa_erase(xa, addr_to_vb_idx(vb->va->va_start));
 	BUG_ON(tmp != vb);
 
@@ -2193,7 +2193,7 @@ static void vb_free(unsigned long addr,
 	order = get_order(size);
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
 
-	xa = addr_to_vb_xarray(addr);
+	xa = addr_to_vb_xa(addr);
 	vb = xa_load(xa, addr_to_vb_idx(addr));
 
 	spin_lock(&vb->lock);
@@ -3592,7 +3592,7 @@ static size_t vmap_ram_vread_iter(struct
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

mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch
mm-vmalloc-rename-addr_to_vb_xarray-function.patch

