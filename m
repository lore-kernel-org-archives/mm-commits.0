Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9553ACCA486
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiGRAdg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C652515729
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71FE2B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC6C3411E;
        Mon, 18 Jul 2022 00:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104375;
        bh=pyBmKnFL4OzoJ4hX7sJNdmWS1yZaEu/mqfiJb4Q3BWY=;
        h=Date:To:From:Subject:From;
        b=hPkWlI/ghFprtnldbOtBllCYGQWes1wIt6kVRP6mvn2rnfNhqJ+Ffycr1oWV6+FSR
         28y1uoPDlV1rkc8nCYL5924H4by7m2FcCamz+e+o13pPidt4mYh4+z9FEM28bAFSZb
         EOObxNEqFfOc5FziQwp1+gTYiFkpBVuVi6Psd24w=
Date:   Sun, 17 Jul 2022 17:32:54 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jrdr.linux@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-old_rr4-added-under-config_hugetlb_page.patch removed from -mm tree
Message-Id: <20220718003255.1ACC6C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: old_rr4 added under CONFIG_HUGETLB_PAGE
has been removed from the -mm tree.  Its filename was
     ia64-old_rr4-added-under-config_hugetlb_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Subject: ia64: old_rr4 added under CONFIG_HUGETLB_PAGE
Date: Sun, 26 Jun 2022 07:51:14 +0530

kernel test robot throws below warning ->

arch/ia64/include/asm/mmu_context.h: In function 'reload_context':
   arch/ia64/include/asm/mmu_context.h:127:48: warning: variable
'old_rr4' set but not used [-Wunused-but-set-variable]
     127 |         unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;

Add it under CONFIG_HUGETLB_PAGE

Link: https://lkml.kernel.org/r/20220626022114.4020-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/mmu_context.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/ia64/include/asm/mmu_context.h~ia64-old_rr4-added-under-config_hugetlb_page
+++ a/arch/ia64/include/asm/mmu_context.h
@@ -124,9 +124,12 @@ reload_context (nv_mm_context_t context)
 {
 	unsigned long rid;
 	unsigned long rid_incr = 0;
-	unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
+	unsigned long rr0, rr1, rr2, rr3, rr4;
 
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long old_rr4;
 	old_rr4 = ia64_get_rr(RGN_BASE(RGN_HPAGE));
+#endif
 	rid = context << 3;	/* make space for encoding the region number */
 	rid_incr = 1 << 8;
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

