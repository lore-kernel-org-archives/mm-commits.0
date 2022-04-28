Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167A4C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiD1XWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353251AbiD1XWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:22:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0E0BB0B4
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43D93CE2F77
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69774C385A9;
        Thu, 28 Apr 2022 23:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651187925;
        bh=9EF2YqrcP7ZbeenEAHjudwlCkbX8UfO98JlWKyYHq+0=;
        h=Date:To:From:Subject:From;
        b=ilWvVQC8ZSKko5OB+jCYNse29w/TsP1MK8xXj8Bl7CM5tAKckMMDZKS4+FGn2nt5F
         NMu450DvlxUg+CqL1ogBmtce18WUcR1a7e3qRv2an/HuK6HUvGCf6DSixeb2Yz11d7
         RfGuQL0Me0bTOznEsnaSYfhBDYVEHXTJTIjIkHHY=
Date:   Thu, 28 Apr 2022 16:18:44 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, naoya.horiguchi@nec.com, hughd@google.com,
        apopple@nvidia.com, zhanghongchen@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapops-make-is_pmd_migration_entry-more-strict.patch added to -mm tree
Message-Id: <20220428231845.69774C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapops: make is_pmd_migration_entry more strict
has been added to the -mm tree.  Its filename is
     mm-swapops-make-is_pmd_migration_entry-more-strict.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapops-make-is_pmd_migration_entry-more-strict.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapops-make-is_pmd_migration_entry-more-strict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hongchen Zhang <zhanghongchen@loongson.cn>
Subject: mm/swapops: make is_pmd_migration_entry more strict

A pmd migration entry should first be a swap pmd,so use is_swap_pmd(pmd)
instead of !pmd_present(pmd).

On the other hand, some architecture (MIPS for example) may misjudge a
pmd_none entry as a pmd migration entry.

Link: https://lkml.kernel.org/r/1651131333-6386-1-git-send-email-zhanghongchen@loongson.cn
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swapops.h~mm-swapops-make-is_pmd_migration_entry-more-strict
+++ a/include/linux/swapops.h
@@ -424,7 +424,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 
 static inline int is_pmd_migration_entry(pmd_t pmd)
 {
-	return !pmd_present(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
+	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
 #else
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
_

Patches currently in -mm which might be from zhanghongchen@loongson.cn are

mm-swapops-make-is_pmd_migration_entry-more-strict.patch

