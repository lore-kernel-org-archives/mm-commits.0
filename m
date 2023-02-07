Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35660C636D3
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBGBSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjBGBSP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:18:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE224CAA
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 922E161092
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E267CC433EF;
        Tue,  7 Feb 2023 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675732691;
        bh=kSqeozOGyZGb8OA2H2XHwr45Ut2pCifUYx2oTWtKxCQ=;
        h=Date:To:From:Subject:From;
        b=B56mgMEvhhGvrLjEUumeStcUfu59SDMaF0JQzogTM9Q6ylGSOvJuPFxmdlVtMVzzI
         +g2XDyYKe5QQJClTL+2wQEyCPsdwA2leOyXIqu1moWrzbKSN7+HsVh3s1Wq0cTJdCV
         JON9IMvpSRGcvVDDflatYCTuYtV8NH2CIHSQd5cQ=
Date:   Mon, 06 Feb 2023 17:18:10 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch added to mm-unstable branch
Message-Id: <20230207011810.E267CC433EF@smtp.kernel.org>
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

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

