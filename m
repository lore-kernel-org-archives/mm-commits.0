Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFECEECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiILDeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILDc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7A27CCE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEF78B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692E4C433C1;
        Mon, 12 Sep 2022 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953411;
        bh=GrmiXHwJlUQodoOek/LCr9ItEZN84ybxO4K6xvesq9M=;
        h=Date:To:From:Subject:From;
        b=fg6aiY3Klgq0mb0kLE1hSPz77LFdZYD8yntNfwNpAZ52x6BYsS8iUbshTdfPh8L0C
         aMAIq2WBBn4GvTv8dQ+bOTabTQJ/usXL3DT+aKXfSAW3syW95OLhxgzzihl8fISS3i
         RkO4baXSI8eJ2z+u2VgDw5+jtxjID/UU7srXLvfc=
Date:   Sun, 11 Sep 2022 20:30:10 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-simplify-the-parameter-passing-for-check_accesses.patch removed from -mm tree
Message-Id: <20220912033011.692E4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: simplify the parameter passing for 'check_accesses'
has been removed from the -mm tree.  Its filename was
     mm-damon-simplify-the-parameter-passing-for-check_accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: simplify the parameter passing for 'check_accesses'
Date: Sat, 27 Aug 2022 17:02:50 +0800

Patch series "mm/damon: Simplify the damon regions access check", v2.

This patchset simplifies the operations when checking the damon regions
accesses.


This patch (of 2):

The parameter 'struct damon_ctx *ctx' isn't used in the functions
__damon_{p,v}a_check_access(), so we can remove it and simplify the
parameter passing.

Link: https://lkml.kernel.org/r/1661590971-20893-1-git-send-email-kaixuxia@tencent.com
Link: https://lkml.kernel.org/r/1661590971-20893-2-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 ++---
 mm/damon/vaddr.c |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-simplify-the-parameter-passing-for-check_accesses
+++ a/mm/damon/paddr.c
@@ -166,8 +166,7 @@ out:
 	return result.accessed;
 }
 
-static void __damon_pa_check_access(struct damon_ctx *ctx,
-				    struct damon_region *r)
+static void __damon_pa_check_access(struct damon_region *r)
 {
 	static unsigned long last_addr;
 	static unsigned long last_page_sz = PAGE_SIZE;
@@ -196,7 +195,7 @@ static unsigned int damon_pa_check_acces
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(ctx, r);
+			__damon_pa_check_access(r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 	}
--- a/mm/damon/vaddr.c~mm-damon-simplify-the-parameter-passing-for-check_accesses
+++ a/mm/damon/vaddr.c
@@ -542,8 +542,8 @@ static bool damon_va_young(struct mm_str
  * mm	'mm_struct' for the given virtual address space
  * r	the region to be checked
  */
-static void __damon_va_check_access(struct damon_ctx *ctx,
-			       struct mm_struct *mm, struct damon_region *r)
+static void __damon_va_check_access(struct mm_struct *mm,
+				struct damon_region *r)
 {
 	static struct mm_struct *last_mm;
 	static unsigned long last_addr;
@@ -578,7 +578,7 @@ static unsigned int damon_va_check_acces
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(ctx, mm, r);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 		mmput(mm);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

