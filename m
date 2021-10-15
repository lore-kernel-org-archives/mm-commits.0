Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC268C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C375661163
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbhJOVo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238695AbhJOVoZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 17:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998586101D;
        Fri, 15 Oct 2021 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634334138;
        bh=1mVvf7Trm8Lrduip8UiiLgo9IWtWYy3wfGl1iodclbo=;
        h=Date:From:To:Subject:From;
        b=ZgOFOzSvUmaZs5EUIBqMEXWmKsBo8ARLM26gxFosVBBPh5kqvcdhFPkJU/Mb/pML6
         JSx+VkC53u8VWf/KyRriVGIsiv9sPqqCTkyyhpa1iy5Vnnlz8pfXNgPSOAwldkSU4C
         0BNbkKpFiWQXMP1zQnqaP0Sxs6e9FCFH91Ss9jIc=
Date:   Fri, 15 Oct 2021 14:42:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        sj@kernel.org
Subject:  + mm-damon-vaddr-constify-static-mm_walk_ops.patch added
 to -mm tree
Message-ID: <20211015214218.zumNXbrht%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: constify static mm_walk_ops
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-constify-static-mm_walk_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-constify-static-mm_walk_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-constify-static-mm_walk_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/damon/vaddr: constify static mm_walk_ops

The only usage of these structs is to pass their addresses to
walk_page_range(), which takes a pointer to const mm_walk_ops as argument.
Make them const to allow the compiler to put them in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-2-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-constify-static-mm_walk_ops
+++ a/mm/damon/vaddr.c
@@ -394,7 +394,7 @@ out:
 	return 0;
 }
 
-static struct mm_walk_ops damon_mkold_ops = {
+static const struct mm_walk_ops damon_mkold_ops = {
 	.pmd_entry = damon_mkold_pmd_entry,
 };
 
@@ -490,7 +490,7 @@ out:
 	return 0;
 }
 
-static struct mm_walk_ops damon_young_ops = {
+static const struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
 };
 
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

mm-memory_failure-constify-static-mm_walk_ops.patch
mm-damon-vaddr-constify-static-mm_walk_ops.patch
const_structscheckpatch-add-a-few-sound-ops-structs.patch

