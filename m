Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70B1C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiEMWdP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiEMWdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23F213F28
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F726020F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1793C34114;
        Fri, 13 May 2022 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481190;
        bh=+mKVPfMF6vusQxd61Cc8METAKZUCqbP1WlvXzQecOsw=;
        h=Date:To:From:Subject:From;
        b=FDYTHzoY95D30upBYkQIjx2KvSOxyVou/bBrQtKgFtQRwUIzmI/jgxH+sbQVq6pIh
         FdiwUBHqIJNMnri/Xth46dZ39/jNx2mtadt5nNIgXbvJeSn4NmTXrl277hAaaqdtHp
         CkFnwtl9aISxB93evvO38S2EkloLab2gM5yKaHrk=
Date:   Fri, 13 May 2022 15:33:10 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch removed from -mm tree
Message-Id: <20220513223310.D1793C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fix up for "mm: change huge_ptep_clear_flush() to return the original pte"
has been removed from the -mm tree.  Its filename was
     mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix.patch

This patch was dropped because it was folded into mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch

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

mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch

