Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC61C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiLAAGs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLAAEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AD591C11
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADCE5B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFFBC433D7;
        Thu,  1 Dec 2022 00:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852930;
        bh=j1EN3SytkNOpwtRwzJUkte07G8EQrYyJ/FInMLz4ZtI=;
        h=Date:To:From:Subject:From;
        b=bNNKNQqOlcL2/tGH5uOAEwkRz8avAZtOFvsK+7tWp89y0l1IIYmmfdqEUDm5RHXf0
         OgFpjsJYSz0zOMLsYRzXJP4zxY+ls70k3wNVVa3tBDiP7BwQ0FqQWCSbwR+Ki4S3e3
         YjJGC1ew03Tw7qqOQ35h7N41nooltaK3yTIWh/OA=
Date:   Wed, 30 Nov 2022 16:02:09 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch removed from -mm tree
Message-Id: <20221201000210.5FFFBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: don't call vm_ops->huge_fault() in wp_huge_pmd()/wp_huge_pud() for private mappings
has been removed from the -mm tree.  Its filename was
     mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: don't call vm_ops->huge_fault() in wp_huge_pmd()/wp_huge_pud() for private mappings
Date: Wed, 16 Nov 2022 11:26:46 +0100

If we already have a PMD/PUD mapped write-protected in a private mapping
and we want to break COW either due to FAULT_FLAG_WRITE or
FAULT_FLAG_UNSHARE, there is no need to inform the file system just like on
the PTE path.

Let's just split (->zap) + fallback in that case.

This is a preparation for more generic FAULT_FLAG_UNSHARE support in
COW mappings.

Link: https://lkml.kernel.org/r/20221116102659.70287-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings
+++ a/mm/memory.c
@@ -4802,6 +4802,7 @@ static inline vm_fault_t create_huge_pmd
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
+	vm_fault_t ret;
 
 	if (vma_is_anonymous(vmf->vma)) {
 		if (likely(!unshare) &&
@@ -4809,11 +4810,13 @@ static inline vm_fault_t wp_huge_pmd(str
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf);
 	}
-	if (vmf->vma->vm_ops->huge_fault) {
-		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vmf->vma->vm_ops->huge_fault) {
+			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	}
 
 	/* COW or write-notify handled on pte level: split pmd. */
@@ -4839,14 +4842,17 @@ static vm_fault_t wp_huge_pud(struct vm_
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	vm_fault_t ret;
+
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vmf->vma))
 		goto split;
-	if (vmf->vma->vm_ops->huge_fault) {
-		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vmf->vma->vm_ops->huge_fault) {
+			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	}
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

