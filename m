Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D494EC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF7861177
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhEMTEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231993AbhEMTEY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:04:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A601561264;
        Thu, 13 May 2021 19:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620932593;
        bh=Yyu/5ub6JK0aW/0L4Vi2N0Ar/9AbeeM6MfgoxTwkSDM=;
        h=Date:From:To:Subject:From;
        b=ugKjMRXSCbaycblgWcVa8LWi1RHaOPF/yOn5ip30gOIViX7DnDhqRAGOU5CzSd/7G
         jXmEsHFXL6jtfM74reKofTuRO0qLhKhgOtldz6H9dIFWlYjpEVci6HodvpUsIW6JIW
         y0l8iGn9ts5AYfKdbvaOGKyh5w6Y1uVXE3w/QqDM=
Date:   Thu, 13 May 2021 12:03:13 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, npiggin@gmail.com
Subject:  + mm-ioremap-fix-iomap_max_page_shift.patch added to -mm
 tree
Message-ID: <20210513190313.1Kb4HOVGE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ioremap: fix iomap_max_page_shift
has been added to the -mm tree.  Its filename is
     mm-ioremap-fix-iomap_max_page_shift.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-ioremap-fix-iomap_max_page_shift.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-ioremap-fix-iomap_max_page_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/ioremap: fix iomap_max_page_shift

iomap_max_page_shift is expected to contain a page shift, so it can't be a
'bool', has to be an 'unsigned int'

And fix the default values: P4D_SHIFT is when huge iomap is allowed.

However, on some architectures (eg: powerpc book3s/64), P4D_SHIFT is not a
constant so it can't be used to initialise a static variable.  So,
initialise iomap_max_page_shift with a maximum shift supported by the
architecture, it is gated by P4D_SHIFT in vmap_try_huge_p4d() anyway.

Link: https://lkml.kernel.org/r/ad2d366015794a9f21320dcbdd0a8eb98979e9df.1620898113.git.christophe.leroy@csgroup.eu
Fixes: bbc180a5adb0 ("mm: HUGE_VMAP arch support cleanup")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ioremap.c~mm-ioremap-fix-iomap_max_page_shift
+++ a/mm/ioremap.c
@@ -16,16 +16,16 @@
 #include "pgalloc-track.h"
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static bool __ro_after_init iomap_max_page_shift = PAGE_SHIFT;
+static unsigned int __ro_after_init iomap_max_page_shift = BITS_PER_LONG - 1;
 
 static int __init set_nohugeiomap(char *str)
 {
-	iomap_max_page_shift = P4D_SHIFT;
+	iomap_max_page_shift = PAGE_SHIFT;
 	return 0;
 }
 early_param("nohugeiomap", set_nohugeiomap);
 #else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
-static const bool iomap_max_page_shift = PAGE_SHIFT;
+static const unsigned int iomap_max_page_shift = PAGE_SHIFT;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 int ioremap_page_range(unsigned long addr,
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ioremap-fix-iomap_max_page_shift.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

