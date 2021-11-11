Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7309FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AEF9610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhKKCwZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BB06103C;
        Thu, 11 Nov 2021 02:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598975;
        bh=sod8cDKfHe9Bjdw1W5Bro39XywH41CPlKcBPii4wHwM=;
        h=Date:From:To:Subject:From;
        b=BHsDqQH+KjLdsmW4mi4DL81/ZxdYhlhFnRjZ1hFgxVrr6rPYhW5bT8B7u265YrPIT
         Ox56gaOqervQ6DbNAC60fQ8BjqVSrpa2yECzT5O9O7gAkPACO4N+A75iTg00Nj6B2n
         mJnYwEwFvjYYXibIRk2KXzcVzDUH55HwuFFLsijA=
Date:   Wed, 10 Nov 2021 18:49:35 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, sj@kernel.org
Subject:  [merged] mm-damon-vaddr-constify-static-mm_walk_ops.patch
 removed from -mm tree
Message-ID: <20211111024935.nAb7M29HT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: constify static mm_walk_ops
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-constify-static-mm_walk_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/damon/vaddr: constify static mm_walk_ops

The only usage of these structs is to pass their addresses to
walk_page_range(), which takes a pointer to const mm_walk_ops as argument.
Make them const to allow the compiler to put them in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-2-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


