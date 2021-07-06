Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA921C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F6A61057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhGFTPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhGFTPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8588860FEE;
        Tue,  6 Jul 2021 19:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598756;
        bh=+VmTZIsd6Qq3IOARGyMjL/Tmj2XcdJvCbyI04unLbto=;
        h=Date:From:To:Subject:From;
        b=zclGh3M4TH5eml423x6NnXEytN5X48MTmu5wyfxXpojjqsSPNlCQPbcUTD6b1Xhjn
         NISn07K3bWqPY/t4X7vQrMGolPFX9CGzEAjytKpPj7PYDKMXFxTbjU7V74+j0gyLKw
         D1DKe5OiCbX3MLOfxbgLofPu7lU9i6UoUinvU0wg=
Date:   Tue, 06 Jul 2021 12:12:36 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 arch-m68k-kernel-sys_m68k-use-vma_lookup-in-sys_cacheflush.patch removed
 from -mm tree
Message-ID: <20210706191236.YKU1k2vyw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/m68k/kernel/sys_m68k: use vma_lookup() in sys_cacheflush()
has been removed from the -mm tree.  Its filename was
     arch-m68k-kernel-sys_m68k-use-vma_lookup-in-sys_cacheflush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/m68k/kernel/sys_m68k: use vma_lookup() in sys_cacheflush()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-9-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/sys_m68k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/sys_m68k.c~arch-m68k-kernel-sys_m68k-use-vma_lookup-in-sys_cacheflush
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -402,8 +402,8 @@ sys_cacheflush (unsigned long addr, int
 		 * to this process.
 		 */
 		mmap_read_lock(current->mm);
-		vma = find_vma(current->mm, addr);
-		if (!vma || addr < vma->vm_start || addr + len > vma->vm_end)
+		vma = vma_lookup(current->mm, addr);
+		if (!vma || addr + len > vma->vm_end)
 			goto out_unlock;
 	}
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


