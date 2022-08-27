Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50485ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiH0Wkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiH0Wkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:40:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4C52DF2
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8841BB807E8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495BCC433D6;
        Sat, 27 Aug 2022 22:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661640032;
        bh=xapooAYx6SuQPv+LM9MEqumOQ/4dfeWYA2GGKImpVPI=;
        h=Date:To:From:Subject:From;
        b=m5kp9lR5fbX3HMfk9sYsF1HE7C2UT7C4nUOzubfHPBNe8lOjsTrnAxsqJ/b+Rv88v
         Xl73+3sGAxrHaAmXLFP4l88cXptsWk6WMkM2hoQZbQGrlY6Kp7PKm7MsRxmZRo3+Wl
         unN0PAPq75ZqgbKICE06OKoDT7bP+BQ3A4yKiCpw=
Date:   Sat, 27 Aug 2022 15:40:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch added to mm-unstable branch
Message-Id: <20220827224032.495BCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: remove comparison between mm and last_mm when checking region accesses
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch

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
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/vaddr: remove comparison between mm and last_mm when checking region accesses
Date: Sat, 27 Aug 2022 17:02:51 +0800

The damon regions that belong to the same damon target have the same
'struct mm_struct *mm', so it's unnecessary to compare the mm and last_mm
objects among the damon regions in one damon target when checking
accesses.  But the check is necessary when the target changed in
'__damon_va_check_accesses()', so we can simplify the whole operation by
using the bool 'same_target' to indicate whether the target changed.

Link: https://lkml.kernel.org/r/1661590971-20893-3-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses
+++ a/mm/damon/vaddr.c
@@ -544,15 +544,14 @@ static bool damon_va_young(struct mm_str
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r)
+				struct damon_region *r, bool same_target)
 {
-	static struct mm_struct *last_mm;
 	static unsigned long last_addr;
 	static unsigned long last_page_sz = PAGE_SIZE;
 	static bool last_accessed;
 
 	/* If the region is in the last checked page, reuse the result */
-	if (mm == last_mm && (ALIGN_DOWN(last_addr, last_page_sz) ==
+	if (same_target && (ALIGN_DOWN(last_addr, last_page_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_page_sz))) {
 		if (last_accessed)
 			r->nr_accesses++;
@@ -563,7 +562,6 @@ static void __damon_va_check_access(stru
 	if (last_accessed)
 		r->nr_accesses++;
 
-	last_mm = mm;
 	last_addr = r->sampling_addr;
 }
 
@@ -573,14 +571,17 @@ static unsigned int damon_va_check_acces
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
+	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
 		if (!mm)
 			continue;
+		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r);
+			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
+			same_target = true;
 		}
 		mmput(mm);
 	}
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch
mm-damon-simplify-the-parameter-passing-for-check_accesses.patch
mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch

