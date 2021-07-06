Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5DBC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FFD61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhGFTPI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231376AbhGFTPI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C31160FE3;
        Tue,  6 Jul 2021 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598748;
        bh=YcSJkL5rTmyUGy7LNtu8PGsWkz7Xk4Sl6QqzlJf7x+U=;
        h=Date:From:To:Subject:From;
        b=qlEnGkRlj7abUH7FkOux53b3fi9q3IpTlECpCtzqOQkAu7HkjfRguUaVhZIzXctOg
         OnpW3fDENRI7FZlGe7aA2TKWBg1YuErOXHjtVA5Vb7b493R8GCCZ3+tjSeyx9U9J69
         oeVe71bPPOg4f9ZOsVjmWpKPx1kUNIuqm9/lyWqc=
Date:   Tue, 06 Jul 2021 12:12:28 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 arch-arm64-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch
 removed from -mm tree
Message-ID: <20210706191228.ovSXz6p-D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm64/kvm: use vma_lookup() instead of find_vma_intersection()
has been removed from the -mm tree.  Its filename was
     arch-arm64-kvm-use-vma_lookup-instead-of-find_vma_intersection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/arm64/kvm: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-5-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/mmu.c~arch-arm64-kvm-use-vma_lookup-instead-of-find_vma_intersection
+++ a/arch/arm64/kvm/mmu.c
@@ -855,7 +855,7 @@ static int user_mem_abort(struct kvm_vcp
 
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
 	mmap_read_lock(current->mm);
-	vma = find_vma_intersection(current->mm, hva, hva + 1);
+	vma = vma_lookup(current->mm, hva);
 	if (unlikely(!vma)) {
 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
 		mmap_read_unlock(current->mm);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


