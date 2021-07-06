Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6D5C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6239C60C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhGFTPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231785AbhGFTPL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72FDF61107;
        Tue,  6 Jul 2021 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598752;
        bh=j//4G6XtWPWIpV09gLcsFT+mekV6EAEY241LAl5H8Ec=;
        h=Date:From:To:Subject:From;
        b=lID93rF/yMIGg5V0M0v/IW2kg9ZPfUb5M2sCsI4Emwm3nicQEetGlJvBVfQx/R+92
         hS+pblQm0Dw7yms7Q2YwsVukaDDUBVNt4CPuYSjvwoyUS3gtRkVfWm1U3DIN8p6q9k
         NiUad3Pnv9xMkdRQUy57AYw6bNf4VsMYUVkemQ3o=
Date:   Tue, 06 Jul 2021 12:12:32 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch
 removed from -mm tree
Message-ID: <20210706191232.p48cqvQCQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/kvm/book3s: use vma_lookup() in kvmppc_hv_setup_htab_rma()
has been removed from the -mm tree.  Its filename was
     arch-powerpc-kvm-book3s-use-vma_lookup-in-kvmppc_hv_setup_htab_rma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liam.howlett@oracle.com are


