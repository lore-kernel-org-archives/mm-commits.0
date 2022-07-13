Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86941C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 18:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiGMSab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGMSaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 14:30:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7812D3B
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 11:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EAFBB82121
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 18:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC8DC34114;
        Wed, 13 Jul 2022 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657737027;
        bh=trC7UQOmtKUiQuIw9WCq48KeNXigG7ci7gp9UEVP01M=;
        h=Date:To:From:Subject:From;
        b=R2cSmLvk5n3DVuT8FkJY5z0p3oZlqAQjHEhoh1ZGuidjufU6dA6ZnPdioD00zy04p
         dgiAw4cqs6psLxiUgQSOfKNuTPOoGOsymJzpefaBDZ3q77td8ZWMTGOC84B4a1pOcK
         qoBAZv/fmyjNsMczthbwO4io1M1FzPxTCH9P9Tuk=
Date:   Wed, 13 Jul 2022 11:30:25 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jrdr.linux@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-old_rr4-added-under-config_hugetlb_page.patch added to mm-nonmm-unstable branch
Message-Id: <20220713183026.DBC8DC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: old_rr4 added under CONFIG_HUGETLB_PAGE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-old_rr4-added-under-config_hugetlb_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-old_rr4-added-under-config_hugetlb_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
ia64-old_rr4-added-under-config_hugetlb_page.patch

