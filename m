Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0F3C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FBC613CD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEEAyn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhEEAym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F00561168;
        Wed,  5 May 2021 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176026;
        bh=zchL9WBWapYyLb6BgCCDmFZRfyNJzeqjm8bntwYAuxQ=;
        h=Date:From:To:Subject:From;
        b=XPDL3RfIY5JTsQjIMue9WrZJMVNp8BUKEnY96tw8FbFOtmTz2fJtfFLEzqBy2knLm
         JGIDHYQcf/QQlDnrdcV1xXbsZ4EKRZkC7aGgafA5QRYCm7IZq7hdx6mw+uhBn6EfEf
         N1uc2E1Ru5y0DQFVKEsa9nwcoZvoZ+nPxcYqb7+w=
Date:   Tue, 04 May 2021 17:53:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [folded-merged]
 hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch removed
 from -mm tree
Message-ID: <20210505005345.ZNBq3ntNv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch

This patch was dropped because it was folded into hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix

build fix

Link: https://lkml.kernel.org/r/20210304164653.GB397383@xz-x1

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix
+++ a/mm/hugetlb.c
@@ -5450,7 +5450,7 @@ int huge_pmd_unshare(struct mm_struct *m
 }
 #define want_pmd_share()	(1)
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
-pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct vma,
+pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
 	return NULL;
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch

