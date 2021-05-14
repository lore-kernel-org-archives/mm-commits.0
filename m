Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262FFC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 20:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F157C61446
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 20:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhENVAS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhENVAR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8B4613EB;
        Fri, 14 May 2021 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621025946;
        bh=Rc+53ThdSy0kwBfnJcFwdgx3flICFvmGnfJh/Vqv9Bc=;
        h=Date:From:To:Subject:From;
        b=IAyodBfPCr0CXA8uGtCrqdTsGKAbr2dgEGqs/c50iiSVGlygMNWHoVgj88oxjlnYn
         rLx4GKRpR3Emv37BXMFYr6qVHhmhtgF35WG0TpogPGJtXMMvidlIo1tFUgSSLE3y8y
         hVQWQuJrGRW4oea9/cIGc/ybAPv9MEKIGZgcNfys=
Date:   Fri, 14 May 2021 13:59:05 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dan.j.williams@intel.com, david@redhat.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, richard.weiyang@linux.alibaba.com
Subject:  + mm-shuffle-fix-section-mismatch-warning.patch added to
 -mm tree
Message-ID: <20210514205905.PAgM1fHoc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shuffle: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     mm-shuffle-fix-section-mismatch-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shuffle-fix-section-mismatch-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shuffle-fix-section-mismatch-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/shuffle: fix section mismatch warning

clang sometimes decides not to inline shuffle_zone(), but it calls a
__meminit function.  Without the extra __meminit annotation we get this
warning:

WARNING: modpost: vmlinux.o(.text+0x2a86d4): Section mismatch in reference from the function shuffle_zone() to the function .meminit.text:__shuffle_zone()
The function shuffle_zone() references
the function __meminit __shuffle_zone().
This is often because shuffle_zone lacks a __meminit
annotation or the annotation of __shuffle_zone is wrong.

shuffle_free_memory() did not show the same problem in my tests, but it
could happen in theory as well, so mark both as __meminit.

Link: https://lkml.kernel.org/r/20210514135952.2928094-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shuffle.h~mm-shuffle-fix-section-mismatch-warning
+++ a/mm/shuffle.h
@@ -10,7 +10,7 @@
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
 extern bool shuffle_pick_tail(void);
-static inline void shuffle_free_memory(pg_data_t *pgdat)
+static inline void __meminit shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
 		return;
@@ -18,7 +18,7 @@ static inline void shuffle_free_memory(p
 }
 
 extern void __shuffle_zone(struct zone *z);
-static inline void shuffle_zone(struct zone *z)
+static inline void __meminit shuffle_zone(struct zone *z)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
 		return;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-shuffle-fix-section-mismatch-warning.patch

