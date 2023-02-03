Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2B7C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjBCF3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBCF3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:29:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DA82201A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 411AA61D0D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CB1C4339C;
        Fri,  3 Feb 2023 05:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402181;
        bh=bN4NYeFtmynUbpq30ucWhiJVnVeU1Fi6HNdlWzeDxTY=;
        h=Date:To:From:Subject:From;
        b=0t3vqoA5iWdYiQW/UwhlR+owlSUYzb+QKeuT1ViFNG1ec745XX+yISWdAVIXmMsLJ
         LdqVY19NWW5KcyEdukOOw9BM789sFzugb/awp5zi1t0hpECWiYfqmavYLkVLaVzher
         s5dS9I9JyOd7Myy8m8zD5tVJsxdMfWpfAO0Rlv44=
Date:   Thu, 02 Feb 2023 21:29:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch removed from -mm tree
Message-Id: <20230203052941.93CB1C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc.c: allow vread() to read out vm_map_ram areas
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: allow vread() to read out vm_map_ram areas
Date: Fri, 13 Jan 2023 11:19:17 +0800

Currently, vread can read out vmalloc areas which is associated with a
vm_struct.  While this doesn't work for areas created by vm_map_ram()
interface because it doesn't have an associated vm_struct.  Then in
vread(), these areas are all skipped.

Here, add a new function vmap_ram_vread() to read out vm_map_ram areas. 
The area created with vmap_ram_vread() interface directly can be handled
like the other normal vmap areas with aligned_vread().  While areas which
will be further subdivided and managed with vmap_block need carefully read
out page-aligned small regions and zero fill holes.

Link: https://lkml.kernel.org/r/20230113031921.64716-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas
+++ a/mm/vmalloc.c
@@ -3544,6 +3544,65 @@ static int aligned_vread(char *buf, char
 	return copied;
 }
 
+static void vmap_ram_vread(char *buf, char *addr, int count, unsigned long flags)
+{
+	char *start;
+	struct vmap_block *vb;
+	unsigned long offset;
+	unsigned int rs, re, n;
+
+	/*
+	 * If it's area created by vm_map_ram() interface directly, but
+	 * not further subdividing and delegating management to vmap_block,
+	 * handle it here.
+	 */
+	if (!(flags & VMAP_BLOCK)) {
+		aligned_vread(buf, addr, count);
+		return;
+	}
+
+	/*
+	 * Area is split into regions and tracked with vmap_block, read out
+	 * each region and zero fill the hole between regions.
+	 */
+	vb = xa_load(&vmap_blocks, addr_to_vb_idx((unsigned long)addr));
+
+	spin_lock(&vb->lock);
+	if (bitmap_empty(vb->used_map, VMAP_BBMAP_BITS)) {
+		spin_unlock(&vb->lock);
+		memset(buf, 0, count);
+		return;
+	}
+	for_each_set_bitrange(rs, re, vb->used_map, VMAP_BBMAP_BITS) {
+		if (!count)
+			break;
+		start = vmap_block_vaddr(vb->va->va_start, rs);
+		while (addr < start) {
+			if (count == 0)
+				break;
+			*buf = '\0';
+			buf++;
+			addr++;
+			count--;
+		}
+		/*it could start reading from the middle of used region*/
+		offset = offset_in_page(addr);
+		n = ((re - rs + 1) << PAGE_SHIFT) - offset;
+		if (n > count)
+			n = count;
+		aligned_vread(buf, start+offset, n);
+
+		buf += n;
+		addr += n;
+		count -= n;
+	}
+	spin_unlock(&vb->lock);
+
+	/* zero-fill the left dirty or free regions */
+	if (count)
+		memset(buf, 0, count);
+}
+
 /**
  * vread() - read vmalloc area in a safe way.
  * @buf:     buffer for reading data
@@ -3574,7 +3633,7 @@ long vread(char *buf, char *addr, unsign
 	struct vm_struct *vm;
 	char *vaddr, *buf_start = buf;
 	unsigned long buflen = count;
-	unsigned long n;
+	unsigned long n, size, flags;
 
 	addr = kasan_reset_tag(addr);
 
@@ -3595,12 +3654,16 @@ long vread(char *buf, char *addr, unsign
 		if (!count)
 			break;
 
-		if (!va->vm)
+		vm = va->vm;
+		flags = va->flags & VMAP_FLAGS_MASK;
+
+		if (!vm && !flags)
 			continue;
 
-		vm = va->vm;
-		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + get_vm_area_size(vm))
+		vaddr = (char *) va->va_start;
+		size = vm ? get_vm_area_size(vm) : va_size(va);
+
+		if (addr >= vaddr + size)
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -3610,10 +3673,13 @@ long vread(char *buf, char *addr, unsign
 			addr++;
 			count--;
 		}
-		n = vaddr + get_vm_area_size(vm) - addr;
+		n = vaddr + size - addr;
 		if (n > count)
 			n = count;
-		if (!(vm->flags & VM_IOREMAP))
+
+		if (flags & VMAP_RAM)
+			vmap_ram_vread(buf, addr, n, flags);
+		else if (!(vm->flags & VM_IOREMAP))
 			aligned_vread(buf, addr, n);
 		else /* IOREMAP area is treated as memory hole */
 			memset(buf, 0, n);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

