Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4353ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiILDeD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiILDc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BDB27B3D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 541E26116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8982C433D7;
        Mon, 12 Sep 2022 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953412;
        bh=9np0H/7c2Whx/xBCwYOvPB0grh7B2EPeXnQZxW8unrE=;
        h=Date:To:From:Subject:From;
        b=G6Fe8PK/QolzilIzRwXgARcwSy1xHyW+/ajJBDJQmc0qUEQE7wXNZu6PRFiPw159T
         +TyG6Kdk0SxZ46GIrEs/pSkCIebPg6LcApfOhiq3QGqpHZDQnUuU8bjpBORkp06pkO
         l1ks5TLXvRN+ZaWT9slgd3T/fXQm3zCBR6emZsvI=
Date:   Sun, 11 Sep 2022 20:30:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch removed from -mm tree
Message-Id: <20220912033012.A8982C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: remove comparison between mm and last_mm when checking region accesses
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -543,15 +543,14 @@ static bool damon_va_young(struct mm_str
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
@@ -562,7 +561,6 @@ static void __damon_va_check_access(stru
 	if (last_accessed)
 		r->nr_accesses++;
 
-	last_mm = mm;
 	last_addr = r->sampling_addr;
 }
 
@@ -572,14 +570,17 @@ static unsigned int damon_va_check_acces
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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

