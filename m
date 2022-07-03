Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB87AC43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiGCWoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiGCWoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05F2C5A
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E7AD6122B
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E830C341C6;
        Sun,  3 Jul 2022 22:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888233;
        bh=/FqTglAGIowTKj2+YkP1r6PRpYskXJDRbRqgh2QhfgA=;
        h=Date:To:From:Subject:From;
        b=DLcqg5O/9GiW3nI6EAhJiLu+MjIczScMhnNn7G4Qf65hTnKJx+UuKzob6sxpuOdUu
         rjs44845/7LuLtP1h/21jj34pLgXXj7UtY0W+2GKvP4lA38mCPVsry+hPB9Mxv5P4s
         wCM1HskwJ+T4rxgm2uhshTWTjMEj6gSjrROVYx38=
Date:   Sun, 03 Jul 2022 15:43:53 -0700
To:     mm-commits@vger.kernel.org, thomas.hellstrom@linux.intel.com,
        jschoenh@amazon.de, christian.koenig@amd.com, jgowans@amazon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-split-huge-pud-on-wp_huge_pud-fallback.patch removed from -mm tree
Message-Id: <20220703224353.9E830C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: split huge PUD on wp_huge_pud fallback
has been removed from the -mm tree.  Its filename was
     mm-split-huge-pud-on-wp_huge_pud-fallback.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Gowans, James" <jgowans@amazon.com>
Subject: mm: split huge PUD on wp_huge_pud fallback
Date: Thu, 23 Jun 2022 05:24:03 +0000

Currently the implementation will split the PUD when a fallback is taken
inside the create_huge_pud function.  This isn't where it should be done:
the splitting should be done in wp_huge_pud, just like it's done for PMDs.
Reason being that if a callback is taken during create, there is no PUD
yet so nothing to split, whereas if a fallback is taken when encountering
a write protection fault there is something to split.

It looks like this was the original intention with the commit where the
splitting was introduced, but somehow it got moved to the wrong place
between v1 and v2 of the patch series.  Rebase mistake perhaps.

Link: https://lkml.kernel.org/r/6f48d622eb8bce1ae5dd75327b0b73894a2ec407.camel@amazon.com
Fixes: 327e9fd48972 ("mm: Split huge pages on write-notify or COW")
Signed-off-by: James Gowans <jgowans@amazon.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-split-huge-pud-on-wp_huge_pud-fallback
+++ a/mm/memory.c
@@ -4802,6 +4802,19 @@ static vm_fault_t create_huge_pud(struct
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vmf->vma))
+		return VM_FAULT_FALLBACK;
+	if (vmf->vma->vm_ops->huge_fault)
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	return VM_FAULT_FALLBACK;
+}
+
+static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	/* No support for anonymous transparent PUD pages yet */
+	if (vma_is_anonymous(vmf->vma))
 		goto split;
 	if (vmf->vma->vm_ops->huge_fault) {
 		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
@@ -4812,19 +4825,7 @@ static vm_fault_t create_huge_pud(struct
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
 	__split_huge_pud(vmf->vma, vmf->pud, vmf->address);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-	return VM_FAULT_FALLBACK;
-}
-
-static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	/* No support for anonymous transparent PUD pages yet */
-	if (vma_is_anonymous(vmf->vma))
-		return VM_FAULT_FALLBACK;
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 	return VM_FAULT_FALLBACK;
 }
 
_

Patches currently in -mm which might be from jgowans@amazon.com are


