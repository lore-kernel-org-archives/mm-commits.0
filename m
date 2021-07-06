Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87740C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7172360FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhGFTPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhGFTPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C49660C3D;
        Tue,  6 Jul 2021 19:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598782;
        bh=elegLkbK4S+gwH4TUTzNwjZZ/8QGlLI1XqzrdgG+gws=;
        h=Date:From:To:Subject:From;
        b=vFR4tnGwuJb26xZHw2wl/bfjzf4gVXiLJIXA9zpDwDMSovmswKb12X3HdICXMyT+V
         LO7cNFgd6sedfWvEXYTU3W+SD+NyRxgnvXzmBYwAbdsso0Ag2OpUAmVSWWtQU/EfyI
         6JDSZoMX1u+ekhyZvkblA4Tbj6Xi3bX4HFHPAla0=
Date:   Tue, 06 Jul 2021 12:13:02 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memoryc-use-vma_lookup-in-__access_remote_vm.patch removed from -mm tree
Message-ID: <20210706191302.A1h1tlsmG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use vma_lookup() in __access_remote_vm()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-use-vma_lookup-in-__access_remote_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/memory.c: use vma_lookup() in __access_remote_vm()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-22-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memoryc-use-vma_lookup-in-__access_remote_vm
+++ a/mm/memory.c
@@ -4994,8 +4994,8 @@ int __access_remote_vm(struct mm_struct
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
 			 */
-			vma = find_vma(mm, addr);
-			if (!vma || vma->vm_start > addr)
+			vma = vma_lookup(mm, addr);
+			if (!vma)
 				break;
 			if (vma->vm_ops && vma->vm_ops->access)
 				ret = vma->vm_ops->access(vma, addr, buf,
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


