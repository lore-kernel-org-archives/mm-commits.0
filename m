Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8226EC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E86161073
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhELWkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 18:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443494AbhELWTG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 18:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883FE61408;
        Wed, 12 May 2021 22:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620857876;
        bh=so9+tKw0k67qljVDfGe3eV6Rp0Vhna71ajlxtqE9NwQ=;
        h=Date:From:To:Subject:From;
        b=LOs9hB0lZObvQJeX8PNkoY9tvY6Mlbk1G4boTHAkQiOmNxYfFUwCm0/dAv5lNx+9E
         kSYUUz/1BghJy99qHh1Fdp+eLU+LI39ZHDiI4G/bb4LXOCvwOL/Z3jw0cL/UANS4YO
         QBGvSTEsjmpcSOn4Vd6rkzXnFttn02VlXEzVbnLw=
Date:   Wed, 12 May 2021 15:17:55 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org
Subject:  [failures]
 mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
 removed from -mm tree
Message-ID: <20210512221755.MA0VVy8uf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: make ALLOC_SPLIT_PTLOCKS dependent on USE_SPLIT_PTE_PTLOCKS
has been removed from the -mm tree.  Its filename was
     mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: make ALLOC_SPLIT_PTLOCKS dependent on USE_SPLIT_PTE_PTLOCKS

Split ptlocks need not be defined and allocated unless they are being
used.  ALLOC_SPLIT_PTLOCKS is inherently dependent on
USE_SPLIT_PTE_PTLOCKS.  This just makes it explicit and clear.

Link: https://lkml.kernel.org/r/1620618390-9999-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types_task.h |    5 +++++
 mm/memory.c                   |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types_task.h~mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks
+++ a/include/linux/mm_types_task.h
@@ -22,7 +22,12 @@
 #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
 #define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
 		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
+
+#if USE_SPLIT_PTE_PTLOCKS
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
+#else
+#define ALLOC_SPLIT_PTLOCKS	0
+#endif
 
 /*
  * The per task VMA cache array:
--- a/mm/memory.c~mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks
+++ a/mm/memory.c
@@ -5260,7 +5260,7 @@ long copy_huge_page_from_user(struct pag
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
-#if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
+#if ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-define-default-value-for-first_user_address.patch

