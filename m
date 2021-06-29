Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79337C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608FC61D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF2Cld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB6E461D0C;
        Tue, 29 Jun 2021 02:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934346;
        bh=FISaQSOnbrfKBp6DvWvnLs12TUKeytatBAwhZVVt+N0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Os7sql8ZXZoUtr3SZTAXsG8hPcZckg6qZiMU2dR42iJ3VepHJ1INtPsYITillw/aN
         qd3AkSE07XEq0YXzOvm0lMLW1/Y7RTkgavGjHkmfZsWVDm8l8jShNpYkO6XniSNgj4
         FaRpXfEFN76m4wIZ9ySabC5NiuDJsg8BdSI4u7Dc=
Date:   Mon, 28 Jun 2021 19:39:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 110/192] arch/powerpc/kvm/book3s: use vma_lookup()
 in kvmppc_hv_setup_htab_rma()
Message-ID: <20210629023905.PSZpvGc2i%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/powerpc/kvm/book3s: use vma_lookup() in kvmppc_hv_setup_htab_rma()

Using vma_lookup() removes the requirement to check if the address is
within the returned vma.  The code is easier to understand and more
compact.

Link: https://lkml.kernel.org/r/20210521174745.2219620-7-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c~arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -4758,8 +4758,8 @@ static int kvmppc_hv_setup_htab_rma(stru
 	/* Look up the VMA for the start of this memory slot */
 	hva = memslot->userspace_addr;
 	mmap_read_lock(kvm->mm);
-	vma = find_vma(kvm->mm, hva);
-	if (!vma || vma->vm_start > hva || (vma->vm_flags & VM_IO))
+	vma = vma_lookup(kvm->mm, hva);
+	if (!vma || (vma->vm_flags & VM_IO))
 		goto up_out;
 
 	psize = vma_kernel_pagesize(vma);
_
