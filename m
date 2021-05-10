Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C5BC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 03:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA9561430
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 03:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhEJDtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 23:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhEJDs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 23:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A08610A7;
        Mon, 10 May 2021 03:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620618474;
        bh=EzqAqhqO5p/GeuLCIJaEwhg9JlYorpJU7vvIdtigbVI=;
        h=Date:From:To:Subject:From;
        b=Y+F6KqRb/3VpQOYzYRSaAR/Uq2cnhEv0/1hEtneppUN3zgqWCgyDoVFp/PZHzblVr
         co9qpD8iPCAD3rF/YJpaO0E9SjYuVwV+GEW5nGNXR88cJI0jWfFaILZZlLnT4WnEMO
         mnQkw97R+dDA9V8xBUUsL18ihlX2N6T1azxfxbEU=
Date:   Sun, 09 May 2021 20:47:54 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org
Subject:  +
 mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
 added to -mm tree
Message-ID: <20210510034754.JFU-XAxL-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: make ALLOC_SPLIT_PTLOCKS dependent on USE_SPLIT_PTE_PTLOCKS
has been added to the -mm tree.  Its filename is
     mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

