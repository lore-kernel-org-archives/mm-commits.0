Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2340BC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 18:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345003AbiEKSdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 14:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346338AbiEKSdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 14:33:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D51B7926
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 11:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5B06CE26D7
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 18:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD541C340EE;
        Wed, 11 May 2022 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652294026;
        bh=eS+GYVR4PRSiCnPjgGkIRw+lMLHudDbhhNVmWgkiKMg=;
        h=Date:To:From:Subject:From;
        b=RtVi1qtvpXhgNg8pLXGJYRwhUlOfbPxnU9iu+ttTkVG0Zsw1YHrHwOOFkac6aOgdL
         ClKcevHKUnc7pmCc+SwEmUJKku8a1KsAw7bFs0rIYRPJXbWqFiFiD4vD+wUPRbp91w
         Phqy+Ysw5Q0OQaSSJPuq0yqUlmx0yFjyanGIw75I=
Date:   Wed, 11 May 2022 11:33:45 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch added to mm-unstable branch
Message-Id: <20220511183345.DD541C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "mm: change huge_ptep_clear_flush() to return the original pte"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "mm: change huge_ptep_clear_flush() to return the original pte"

Link: https://lkml.kernel.org/r/20220511181531.7f27a5c1@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -24,6 +24,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
+	return *ptep;
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch

