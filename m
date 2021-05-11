Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA672C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6FE61448
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhEKA2H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 20:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230227AbhEKA2G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 20:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8BE610CA;
        Tue, 11 May 2021 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620692821;
        bh=K/imxfUUSnAqpb9Jy/G9G0gNExW+2OkQJM8H7BuF+Us=;
        h=Date:From:To:Subject:From;
        b=Ws1gd+1lh5PxfKhU0LinKIpF7g1W6wefe82smVmNA3zSjuO8BRZJVuJZQhVavFVjm
         MBnrqpQOJz/fiO7pL/M9OLqeSDwg2sgISotANCTEGkCxgW99I4gros3vQzV+8EBWne
         Nofo7TnLD2Eql0OVyRhf5EWfT8E70h7fSPsmx4OQ=
Date:   Mon, 10 May 2021 17:27:00 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, npiggin@gmail.com
Subject:  + mm-ioremap-fix-iomap_max_page_shift.patch added to -mm
 tree
Message-ID: <20210511002700.jpuFHBGjC%akpm@linux-foundation.org>
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

iomap_max_page_shift is expected to contain a page shift,
so it can't be a 'bool', has to be an 'unsigned int'

And fix the default values: P4D_SHIFT is when huge iomap is allowed.

Link: https://lkml.kernel.org/r/0d615a242c4470462da547dc332e4ec5f00479dd.1619855673.git.christophe.leroy@csgroup.eu
Fixes: bbc180a5adb05ee ("mm: HUGE_VMAP arch support cleanup")
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
 
 int ioremap_page_range(unsigned long addr,
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ioremap-fix-iomap_max_page_shift.patch

