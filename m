Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DBCC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65AF460FE3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhGFTPJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhGFTPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C1BF60C3D;
        Tue,  6 Jul 2021 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598750;
        bh=8p+9fJ8GAdh2YRI+iuR2dnSEuc1FrOVatZ6dFLeCF7g=;
        h=Date:From:To:Subject:From;
        b=rDWirraaUNcWLN9CIsViUNpOVqFivApzEscPK3yIFAg9guAcfYftYHyhjMMyXAU92
         NIWGRMBsIN9B7Sh77xqmTG/XaikZV7/ug1MpvDbm7EMJjO6uMgKjt86hRKPJHlLNNx
         ltguANzQXCiwalwcnKbgTfofA8mms5Llmp0TaAlE=
Date:   Tue, 06 Jul 2021 12:12:30 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?arch-powerpc-kvm-book3s=5Fhv=5Fuvmem-use-vma=5Flookup-instea?=
 =?US-ASCII?Q?d-of-find=5Fvma=5Fintersection.patch?= removed from -mm tree
Message-ID: <20210706191230.m69O9jyJ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/kvm/book3s_hv_uvmem: use vma_lookup() instead of find_vma_intersection()
has been removed from the -mm tree.  Its filename was
     arch-powerpc-kvm-book3s_hv_uvmem-use-vma_lookup-instead-of-find_vma_intersection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/powerpc/kvm/book3s_hv_uvmem: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-6-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~arch-powerpc-kvm-book3s_hv_uvmem-use-vma_lookup-instead-of-find_vma_intersection
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -614,7 +614,7 @@ void kvmppc_uvmem_drop_pages(const struc
 
 		/* Fetch the VMA if addr is not in the latest fetched one */
 		if (!vma || addr >= vma->vm_end) {
-			vma = find_vma_intersection(kvm->mm, addr, addr+1);
+			vma = vma_lookup(kvm->mm, addr);
 			if (!vma) {
 				pr_err("Can't find VMA for gfn:0x%lx\n", gfn);
 				break;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


