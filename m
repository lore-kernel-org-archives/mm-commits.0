Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EF5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjBJA4r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBJAzO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0440F6F8DA
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EDBF61BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3130C433D2;
        Fri, 10 Feb 2023 00:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990460;
        bh=4d/JX4wtG0iPeV5cSOZJdgqB17ETCJJsR1s6GhBPKi0=;
        h=Date:To:From:Subject:From;
        b=PMmpswMHoLHA1eb12nD1Sln5b7flp3xHGXRNRk/FkhUCsJs0sHUiugcHJVR42uadH
         Fi7RKjnZThTqfMXFwHnKfZNLouxkQRsZNDGAyhc7/CN9WIdXdP3JCTGf79BYj0sN04
         +XgRQaTAZ3KWBt1mQNmQIOuEcXxwX4z7yykPziyA=
Date:   Thu, 09 Feb 2023 16:54:19 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch removed from -mm tree
Message-Id: <20230210005419.E3130C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc.c: allow vread() to read out vm_map_ram areas
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: allow vread() to read out vm_map_ram areas
Date: Mon, 6 Feb 2023 16:40:16 +0800

Currently, vread can read out vmalloc areas which is associated with a
vm_struct.  While this doesn't work for areas created by vm_map_ram()
interface because it doesn't have an associated vm_struct.  Then in
vread(), these areas are all skipped.

Here, add a new function vmap_ram_vread() to read out vm_map_ram areas. 
The area created with vmap_ram_vread() interface directly can be handled
like the other normal vmap areas with aligned_vread().  While areas which
will be further subdivided and managed with vmap_block need carefully read
out page-aligned small regions and zero fill holes.

Link: https://lkml.kernel.org/r/20230206084020.174506-4-bhe@redhat.com
Reported-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Tested-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   88 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 81 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas
+++ a/mm/vmalloc.c
@@ -3463,6 +3463,68 @@ static int aligned_vread(char *buf, char
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
+	if (!vb)
+		goto finished;
+
+	spin_lock(&vb->lock);
+	if (bitmap_empty(vb->used_map, VMAP_BBMAP_BITS)) {
+		spin_unlock(&vb->lock);
+		goto finished;
+	}
+	for_each_set_bitrange(rs, re, vb->used_map, VMAP_BBMAP_BITS) {
+		if (!count)
+			break;
+		start = vmap_block_vaddr(vb->va->va_start, rs);
+		while (addr < start) {
+			if (count == 0)
+				goto unlock;
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
+unlock:
+	spin_unlock(&vb->lock);
+
+finished:
+	/* zero-fill the left dirty or free regions */
+	if (count)
+		memset(buf, 0, count);
+}
+
 /**
  * vread() - read vmalloc area in a safe way.
  * @buf:     buffer for reading data
@@ -3493,7 +3555,7 @@ long vread(char *buf, char *addr, unsign
 	struct vm_struct *vm;
 	char *vaddr, *buf_start = buf;
 	unsigned long buflen = count;
-	unsigned long n;
+	unsigned long n, size, flags;
 
 	addr = kasan_reset_tag(addr);
 
@@ -3514,12 +3576,21 @@ long vread(char *buf, char *addr, unsign
 		if (!count)
 			break;
 
-		if (!va->vm)
+		vm = va->vm;
+		flags = va->flags & VMAP_FLAGS_MASK;
+		/*
+		 * VMAP_BLOCK indicates a sub-type of vm_map_ram area, need
+		 * be set together with VMAP_RAM.
+		 */
+		WARN_ON(flags == VMAP_BLOCK);
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
@@ -3529,10 +3600,13 @@ long vread(char *buf, char *addr, unsign
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


