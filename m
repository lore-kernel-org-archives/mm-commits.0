Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7367DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiEMWeT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiEMWeS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:34:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204FA13F28
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF87AB831E5
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A9EC34100;
        Fri, 13 May 2022 22:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481254;
        bh=va7bMOb14xXJXlf2/+Y5M4bWqcHb5rXlUNemwKefB50=;
        h=Date:To:From:Subject:From;
        b=xP/MQLHDoYckIDkwPRT3+uoguipq1KtgYg15sqFEB4fEUxPeMepcR+csrW4pXc81N
         D0pWYq/vWxUcI6H4o816ZfZ4mqweVAjkV4uJqp7WHsZTY1+T+MlUaSGWceqpGDpVI1
         PI5X8+XDqxBpebXmcyyhaMVKrpBhC0M3SrCyZqec=
Date:   Fri, 13 May 2022 15:34:13 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch removed from -mm tree
Message-Id: <20220513223414.38A9EC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2
has been removed from the -mm tree.  Its filename was
     mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch

This patch was dropped because it was folded into mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2

fix build in several more architectures

Link: https://lkml.kernel.org/r/0009a4cd-2826-e8be-e671-f050d4f18d5d@linux.alibaba.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/hugetlb.h   |    1 +
 arch/parisc/include/asm/hugetlb.h |    1 +
 arch/sh/include/asm/hugetlb.h     |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/ia64/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -26,6 +26,7 @@ static inline int is_hugepage_only_range
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
+	return *ptep;
 }
 
 #include <asm-generic/hugetlb.h>
--- a/arch/parisc/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -31,6 +31,7 @@ static inline int prepare_hugepage_range
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
+	return *ptep;
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
--- a/arch/sh/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2
+++ a/arch/sh/include/asm/hugetlb.h
@@ -24,6 +24,7 @@ static inline int prepare_hugepage_range
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
+	return *ptep;
 }
 
 static inline void arch_clear_hugepage_flags(struct page *page)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

