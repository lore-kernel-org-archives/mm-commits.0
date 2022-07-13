Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2EEC43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 14:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiGMO4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 10:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiGMO4E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 10:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27593D5BA
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 07:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 756DEB82019
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 14:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1474FC34114;
        Wed, 13 Jul 2022 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657724159;
        bh=PbDhBQUOzz2OatvsXIyHsDSUJvlb3NPshIHUo/LEz2c=;
        h=Date:To:From:Subject:From;
        b=JZWixKk5VSQBsA1RbE4D7xUglC8A/ydlg9VI9Z8t71mysbwvEsoLIYaW7Lm0IZ248
         YV29yU6ZD7+ml63xPjV/7RV6kke+S9vA2rHtkGda/X3x5lZGaEX4faKwY8CgAzCBZv
         rV1m2Hl7YQwQ9x2o3sxnCbARpj+pti9XF5qOdOkE=
Date:   Wed, 13 Jul 2022 07:55:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20220713145559.1474FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
Date: Wed, 13 Jul 2022 10:13:37 -0400

Link: https://lkml.kernel.org/r/e90c8f0dbae836632b669c2afc434006a00d4a67.1657721478.git.josef@toxicpanda.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
+++ a/mm/memory.c
@@ -4369,7 +4369,10 @@ vm_fault_t finish_fault(struct vm_fault
 			return VM_FAULT_OOM;
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch
mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch

