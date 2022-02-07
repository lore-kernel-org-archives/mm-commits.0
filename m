Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60ABC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiBGVAd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiBGVAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D7BC043189
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8480B816FF
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D4C004E1;
        Mon,  7 Feb 2022 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267620;
        bh=YrWahkIyBlq4ID6kB1blx2gmz+se4f7T3wPRhzLiFIs=;
        h=Date:To:From:Subject:From;
        b=aan1r036jtTGGVI6b6RvUSO3iHX6ENmlHHXfE1bDc/Rb9SJpRMIHfMoGlhxCrgtpj
         WSnFo2BlFvncPqUwrdXWnkerdpKEoj5ldX0l3agw2TfbS/dAs8MIsAycAvjNZz4GXd
         6/LSXgn/hNvxiKGFs4McAo2ih2GMHcCQKmuHtGrs=
Date:   Mon, 07 Feb 2022 13:00:19 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch added to -mm tree
Message-Id: <20220207210020.5B1D4C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: avoid unused variable warning in pagemap_pmd_range()
has been added to the -mm tree.  Its filename is
     proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: proc: avoid unused variable warning in pagemap_pmd_range()

When building with CONFIG_TRANSPARENT_HUGEPAGE=n, there is a warning about
migration being unused:

  fs/proc/task_mmu.c:1444:7: warning: unused variable 'migration' [-Wunused-variable]
          bool migration = false;
               ^
  1 warning generated.

Move the ifdef preprocessor directive up to include migration so it is
only included in the file when it is used.

Link: https://lkml.kernel.org/r/20220207171049.1102239-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-avoid-unused-variable-warning-in-pagemap_pmd_range
+++ a/fs/proc/task_mmu.c
@@ -1441,9 +1441,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool migration = false;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
 		u64 flags = 0, frame = 0;
_

Patches currently in -mm which might be from nathan@kernel.org are

proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch

