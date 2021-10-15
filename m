Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F363C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2347C61151
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhJOVoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238695AbhJOVoA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 17:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5E6610D1;
        Fri, 15 Oct 2021 21:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634334113;
        bh=fBQsVdGwEW9McHQmoovy0qt+839XEm57ZKSRri0niJg=;
        h=Date:From:To:Subject:From;
        b=dFwhK9C3ezUePmvYizRWmMqNUcbongeO1ouDp/O87SfQ1qbJuxum1VcVXY66eeb5e
         ZL6kfGjAZZOc9le9APgxhAozotX0x6ye8hre1VN0gdxBJq9Feyx8iBEjiWbm9/ZOs6
         KLEaD4NM818qwFw9d70PGowO1SnRFcl/mYAwYQ7U=
Date:   Fri, 15 Oct 2021 14:41:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        rikard.falkeborn@gmail.com
Subject:  + mm-memory_failure-constify-static-mm_walk_ops.patch
 added to -mm tree
Message-ID: <20211015214153._uC5UCP8Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_failure: constify static mm_walk_ops
has been added to the -mm tree.  Its filename is
     mm-memory_failure-constify-static-mm_walk_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_failure-constify-static-mm_walk_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_failure-constify-static-mm_walk_ops.patch

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
Subject: mm/memory_failure: constify static mm_walk_ops

The only usage of hwp_walk_ops is to pass its address to walk_page_range()
which takes a pointer to const mm_walk_ops as argument.  Make it const to
allow the compiler to put it in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-3-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory_failure-constify-static-mm_walk_ops
+++ a/mm/memory-failure.c
@@ -675,7 +675,7 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
-static struct mm_walk_ops hwp_walk_ops = {
+static const struct mm_walk_ops hwp_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
 };
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

mm-memory_failure-constify-static-mm_walk_ops.patch
mm-damon-vaddr-constify-static-mm_walk_ops.patch
const_structscheckpatch-add-a-few-sound-ops-structs.patch

