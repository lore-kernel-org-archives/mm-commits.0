Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609B6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 01:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CB16112D
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 01:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhINBRn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 21:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhINBRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 21:17:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CE9A61108;
        Tue, 14 Sep 2021 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631582186;
        bh=hQV9xnqx5z4e+wGz/81wpL9EeHSsNIiy6q7qDEc+UTk=;
        h=Date:From:To:Subject:From;
        b=IjMA5nEQ6R15GaRs8nsl23zlbbuZ1cy8piZYlTpfxH5zKomGaHdzAXucKyfGezk3o
         eu5LgNfrmnqUoXZAOjz51V5LIPf9lRKSzbFr3a0mVnZdGW2kprag3GVoWOxTcQehhU
         xuOF8FiKedkExq7bWQ7yaiFgQHaENCRiEXML42MU=
Date:   Mon, 13 Sep 2021 18:16:25 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210914011625.FhN4MX82d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                            |    3 ---
 include/linux/compiler-gcc.h        |    5 -----
 include/linux/compiler_attributes.h |    3 ---
 include/linux/compiler_types.h      |    8 --------
 4 files changed, 19 deletions(-)

--- a/include/linux/compiler_attributes.h~linux-next-git-rejects
+++ a/include/linux/compiler_attributes.h
@@ -21,8 +21,6 @@
  */
 
 /*
-<<<<<<< HEAD
-=======
  * __has_attribute is supported on gcc >= 5, clang >= 2.9 and icc >= 17.
  * In the meantime, to support gcc < 5, we implement __has_attribute
  * by hand.
@@ -46,7 +44,6 @@
 #endif
 
 /*
->>>>>>> linux-next/akpm-base
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alias-function-attribute
  */
 #define __alias(symbol)                 __attribute__((__alias__(#symbol)))
--- a/include/linux/compiler-gcc.h~linux-next-git-rejects
+++ a/include/linux/compiler-gcc.h
@@ -41,11 +41,6 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
-<<<<<<< HEAD
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-
-=======
->>>>>>> linux-next/akpm-base
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 #define __latent_entropy __attribute__((latent_entropy))
 #endif
--- a/include/linux/compiler_types.h~linux-next-git-rejects
+++ a/include/linux/compiler_types.h
@@ -295,14 +295,6 @@ struct ftrace_likely_data {
 	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
-<<<<<<< HEAD
-/* Compile time object size, -1 for unknown */
-#ifndef __compiletime_object_size
-# define __compiletime_object_size(obj) -1
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef __OPTIMIZE__
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
--- a/Makefile~linux-next-git-rejects
+++ a/Makefile
@@ -929,8 +929,6 @@ endif
 
 DEBUG_CFLAGS	:=
 
-<<<<<<< HEAD
-=======
 # Workaround for GCC versions < 5.0
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61801
 ifdef CONFIG_CC_IS_GCC
@@ -939,7 +937,6 @@ endif
 
 DEBUG_RUSTFLAGS :=
 
->>>>>>> linux-next/akpm-base
 ifdef CONFIG_DEBUG_INFO
 
 ifdef CONFIG_DEBUG_INFO_SPLIT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

