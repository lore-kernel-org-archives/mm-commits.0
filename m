Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1708C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjANFHN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjANFHI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:07:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA083582
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E463EB822CD
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D73CC433F0;
        Sat, 14 Jan 2023 05:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673672824;
        bh=aTUgbta6e9IwLWWOpK5m8lqy+rjqUQLjbgsexb0k4sU=;
        h=Date:To:From:Subject:From;
        b=pVvzxoXT5LnK/J8ko9U8acySY2WK4lvZ3Zlq7zZrbNE3xzhBwcRhOLj7BU3V20jes
         LIRIbKj3xE0tDgrQZ996w6AJhYNvAJgNTOomjrPU36X3kIQ4m6k9+qNOG5esz7dLqm
         cN2/PZvuTFBQ1WxuroUt5/rUfKR8tMd87vHc3U5I=
Date:   Fri, 13 Jan 2023 21:07:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch added to mm-unstable branch
Message-Id: <20230114050704.8D73CC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: skip the uninitilized vmalloc areas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch

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
Subject: mm/vmalloc: skip the uninitilized vmalloc areas
Date: Fri, 13 Jan 2023 11:19:19 +0800

For areas allocated via vmalloc_xxx() APIs, it searches for unmapped area
to reserve and allocates new pages to map into, please see function
__vmalloc_node_range().  During the process, flag VM_UNINITIALIZED is set
in vm->flags to indicate that the pages allocation and mapping haven't
been done, until clear_vm_uninitialized_flag() is called to clear it.

For this kind of area, if VM_UNINITIALIZED is still set, let's ignore it
in vread() because pages newly allocated and being mapped in that area
only contains zero data.  reading them out by aligned_vread() is wasting
time.

Link: https://lkml.kernel.org/r/20230113031921.64716-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-skip-the-uninitilized-vmalloc-areas
+++ a/mm/vmalloc.c
@@ -3660,6 +3660,11 @@ long vread(char *buf, char *addr, unsign
 		if (!vm && !flags)
 			continue;
 
+		if (vm && (vm->flags & VM_UNINITIALIZED))
+			continue;
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+
 		vaddr = (char *) va->va_start;
 		size = vm ? get_vm_area_size(vm) : va_size(va);
 
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

