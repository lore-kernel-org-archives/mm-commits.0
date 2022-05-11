Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B73C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 18:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240757AbiEKSjM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 14:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346400AbiEKSjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 14:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24DE22D626
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 11:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66F31B825E6
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 18:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3C3C340EE;
        Wed, 11 May 2022 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652294348;
        bh=GGgI7rJ2I9PaPWlxQkmizzBvsky2fYr4c+D/zQuuwrs=;
        h=Date:To:From:Subject:From;
        b=vYi0FDiyruFpmYfYOpJ8E+qFNsP/mQSXJwcyffuf7JhvUHixl1M9Il7wAyNwzImnt
         XqGfAnrrzY7FgbK57TDmJZ61MqH+oORx8XksFK7fAcAOtSeaR+pbNBGOUvsZafRH5L
         mChm6ExrnBo+pa5n1ar7aUSmARI9NfI1nMRqkKc8=
Date:   Wed, 11 May 2022 11:39:07 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch added to mm-unstable branch
Message-Id: <20220511183908.1C3C3C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

