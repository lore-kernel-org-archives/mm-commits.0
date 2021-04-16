Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1644FC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E194A60FEE
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDPWcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233822AbhDPWcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C7BC611ED;
        Fri, 16 Apr 2021 22:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618612308;
        bh=XMh9wKBHxQWBTD5+MKnsyoLNh7jwrZL9pKbFIC6XCNA=;
        h=Date:From:To:Subject:From;
        b=Rb+uA7poqWPS35I1dnN7rWlN16qbQBLibdD7V57kJxAwSUcKP15r92CHnvepDGOG/
         2+yh9Iw2MNFv5yFG9mk3AhFs6IJiPBSyvV/JWCAfUWWBHGcZxX12COp6o2r/5kTISH
         husWOVPRg1QIJEFjSzF+DuXdXA8TkWBHJvd77zVk=
Date:   Fri, 16 Apr 2021 15:31:47 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, elver@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged] kasan-fix-hwasan-build-for-gcc-fix.patch
 removed from -mm tree
Message-ID: <20210416223147.eKkIskNbC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-hwasan-build-for-gcc-fix
has been removed from the -mm tree.  Its filename was
     kasan-fix-hwasan-build-for-gcc-fix.patch

This patch was dropped because it was folded into kasan-fix-hwasan-build-for-gcc.patch

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

kasan-fix-hwasan-build-for-gcc.patch
kfence-zero-guard-page-after-out-of-bounds-access.patch

