Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66806C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221EB65011
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCECMv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCECMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 21:12:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA5164FDB;
        Fri,  5 Mar 2021 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614910371;
        bh=FEJj5mNiEDklFJIG6SF/yYNOibh3o0xJSvBXyAD39P0=;
        h=Date:From:To:Subject:From;
        b=1l/FYbDgjBy7lLGi8z+ubgT1D8BxpRqcSHtkhN8FMDa7LIXcEQGiOYI4bjSJc00/B
         iiynQvAWZNMrhiSFJXamHSWTtKeBNzz68HjqFZBhllRQjCkvPEuplup7iCSFbfI8L5
         lv+rkx4SEn6nkz7RZGGNyryJ7Cl5t/4ahHFF51gM=
Date:   Thu, 04 Mar 2021 18:12:50 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  +
 hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch added to
 -mm tree
Message-ID: <20210305021250.hzPbHmuhg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix
has been added to the -mm tree.  Its filename is
     hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5392,7 +5392,7 @@ int huge_pmd_unshare(struct mm_struct *m
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
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch

