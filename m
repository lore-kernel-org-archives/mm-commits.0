Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC36EC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C809861D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhF2CmR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2CmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B867611AE;
        Tue, 29 Jun 2021 02:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934390;
        bh=RnbB1nQtKYNDI4Qndnf9HjT8r1vpT8GBVkvfYMtW6JE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OeTJkNayP9mj8XD/jljjqy3CTOkiSU3+qy1vkgNaHvYLUugc+pnPb2uKbLtSIJsdh
         Iw+vtvkObkLF5jOlO/TVDfEaeibhP9CR58JXcBxtW9gWHNFDagdDrOfmbjjIUHHsK+
         KuV7D763Eo0AReDj6CHGZyPVFxr7vYGIgL1n2dY8=
Date:   Mon, 28 Jun 2021 19:39:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 125/192] mm/memory.c: use vma_lookup() in
 __access_remote_vm()
Message-ID: <20210629023950.8-KUe7QK5%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
