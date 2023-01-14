Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1027FC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjANFHL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjANFHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:07:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B711230F7
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC3EB822BC
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E794C433D2;
        Sat, 14 Jan 2023 05:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673672821;
        bh=gbS2lkVTNCeoEK9k50xggkfxKF8EW2Y33jCd7wSHzZk=;
        h=Date:To:From:Subject:From;
        b=IbL2MYLsasj4zsdlFupe7WO8mPvCHn/KiOZVThQk+bDYFLLCsu9FOJeOm6UeXN47y
         Vv8xpcKLil5esCLsyJ94uuC3ppIMDAUm+o3F66hb62K/Y9Ox8iLnMw8XviV6ikAbzo
         BWZPkvdiENuERNkH2q8NoJUhVNAkn+FwX9SEuw2E=
Date:   Fri, 13 Jan 2023 21:07:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch added to mm-unstable branch
Message-Id: <20230114050701.0E794C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: allow vread() to read out vm_map_ram areas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch

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

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

