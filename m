Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DFCC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 18:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F0061352
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 18:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEBSMx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 May 2021 14:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhEBSMx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 2 May 2021 14:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8344B61139;
        Sun,  2 May 2021 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619979120;
        bh=kmokx4tOa6Cfsod0PLMH4eEHP+yRoZWqNspGHxchu7I=;
        h=Date:From:To:Subject:From;
        b=W1PuaI4PvQg+5ZIhPa0xSDDbX/8adAm3R6AZnezYYvgt1fLRYvzr/tLOGSVLhVqIB
         pJ8d/27X1L1DAwVknc1DCRgEnyA70Jv4aeWKGI3RPO6MO3BAnkuYTUCTkwn4aCHUAs
         4YJxllQUJAa9QOar//9OZmdXsexrNrUPcsD77h9o=
Date:   Sun, 02 May 2021 11:11:59 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        npiggin@gmail.com
Subject:  + mm-huge_vmap-arch-support-cleanup-fix.patch added to
 -mm tree
Message-ID: <20210502181159.uP_7D48gF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ioremap: fix iomap_max_page_shift
has been added to the -mm tree.  Its filename is
     mm-huge_vmap-arch-support-cleanup-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_vmap-arch-support-cleanup-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_vmap-arch-support-cleanup-fix.patch

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

iomap_max_page_shift is expected to contain a page shift,
so it can't be a 'bool', has to be an 'unsigned int'

And fix the default values: P4D_SHIFT is when huge iomap is allowed.

Link: https://lkml.kernel.org/r/0d615a242c4470462da547dc332e4ec5f00479dd.1619855673.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ioremap.c~mm-huge_vmap-arch-support-cleanup-fix
+++ a/mm/ioremap.c
@@ -16,16 +16,16 @@
 #include "pgalloc-track.h"
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static bool __ro_after_init iomap_max_page_shift = PAGE_SHIFT;
+static unsigned int __ro_after_init iomap_max_page_shift = P4D_SHIFT;
 
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
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-huge_vmap-arch-support-cleanup-fix.patch

