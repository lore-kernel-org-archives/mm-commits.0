Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26D7C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6488613B6
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345198AbhDMRoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231512AbhDMRoV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8484360200;
        Tue, 13 Apr 2021 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618335841;
        bh=djENDid/se6zvobOAvNR22Vq9IhqEuMXOyP5hkSehmc=;
        h=Date:From:To:Subject:From;
        b=O7pD4iHrd8s2NsHTlDaDNc/XPh+VCXN6glheZtU1aaojxQvHinY7sWwA86LB1nazo
         zjt2CpSQyEnSNMgGhtS9I9qyrN6eFZe6Kxyg2V6W77/SDcaohtOWKxHMdFFRR5HTxD
         mKqz5ihcFz5a8LZ+NKKNNNkrQYBrTzqDIX+gSfEI=
Date:   Tue, 13 Apr 2021 10:44:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, andreyknvl@gmail.com, elver@google.com
Subject:  + kasan-fix-hwasan-build-for-gcc-fix.patch added to -mm
 tree
Message-ID: <20210413174401.pLAzV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-hwasan-build-for-gcc-fix
has been added to the -mm tree.  Its filename is
     kasan-fix-hwasan-build-for-gcc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-hwasan-build-for-gcc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-hwasan-build-for-gcc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan-fix-hwasan-build-for-gcc-fix

fixup for "kasan: fix hwasan build for gcc"

Link: https://lkml.kernel.org/r/YHQZVfVVLE/LDK2v@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-byh: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.kasan~kasan-fix-hwasan-build-for-gcc-fix
+++ a/scripts/Makefile.kasan
@@ -2,6 +2,8 @@
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
 KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
+cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -12,8 +14,6 @@ endif
 
 CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
-cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
-
 # -fasan-shadow-offset fails without -fsanitize
 CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
 			-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-hwasan-build-for-gcc-fix.patch
kfence-zero-guard-page-after-out-of-bounds-access.patch

