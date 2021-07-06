Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5EDC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4611360C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhGFTPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhGFTPU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846E060FEE;
        Tue,  6 Jul 2021 19:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598760;
        bh=pMtucLHjfgBfng7pTUi/ZmFZpFoYpuqbAZ75wUFiPQc=;
        h=Date:From:To:Subject:From;
        b=KYKw/UXCtx99o/W4/JH7wcxowczONp1j/0ZwW+6mC+cpPASKrnoZi7G0WMaIJ2Xwp
         1WPneRe0L9C6pzYpcSSTVMgcuCSKRNaMrDoAZSIeiytJY1i1s0OGvJp7FSdDiHQWnH
         1qmAYRwDim8hOJF34+w7EZ+LcU4TVnkeqLoglQAs=
Date:   Tue, 06 Jul 2021 12:12:40 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 virt-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch removed from
 -mm tree
Message-ID: <20210706191240.2QmqIw78I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virt/kvm: use vma_lookup() instead of find_vma_intersection()
has been removed from the -mm tree.  Its filename was
     virt-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: virt/kvm: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-11-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c~virt-kvm-use-vma_lookup-instead-of-find_vma_intersection
+++ a/virt/kvm/kvm_main.c
@@ -2170,7 +2170,7 @@ static kvm_pfn_t hva_to_pfn(unsigned lon
 	}
 
 retry:
-	vma = find_vma_intersection(current->mm, addr, addr + 1);
+	vma = vma_lookup(current->mm, addr);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


