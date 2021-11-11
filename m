Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC61C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2704A61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhKKCrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 775DA6113B;
        Thu, 11 Nov 2021 02:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598672;
        bh=4OlyRlHhWZQCczmQJIJLObwtVdLcJI9owS8FkTwFFoo=;
        h=Date:From:To:Subject:From;
        b=czKwskbHM4nsK1esn6kJfwRm/90JIB3NBRS/PgU5A8SdN/u95iDN07kEncdHd5RmO
         ajiUHdKua6F7fjEZz80sKFsm8im5CZDU18ez5Uhvb7IwwYVBqYEfyL9A4D5hhOzOX4
         2QbTT/f4x8pjNEOQImIFg0nESP3vzbOqxUp2F+7Q=
Date:   Wed, 10 Nov 2021 18:44:32 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, rikard.falkeborn@gmail.com
Subject:  [merged]
 mm-memory_failure-constify-static-mm_walk_ops.patch removed from -mm tree
Message-ID: <20211111024432.eUtkymWgj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_failure: constify static mm_walk_ops
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-constify-static-mm_walk_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/memory_failure: constify static mm_walk_ops

The only usage of hwp_walk_ops is to pass its address to walk_page_range()
which takes a pointer to const mm_walk_ops as argument.  Make it const to
allow the compiler to put it in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-3-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory_failure-constify-static-mm_walk_ops
+++ a/mm/memory-failure.c
@@ -674,7 +674,7 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
-static struct mm_walk_ops hwp_walk_ops = {
+static const struct mm_walk_ops hwp_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
 };
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are


