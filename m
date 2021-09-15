Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD59BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C8161211
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhIOBps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 21:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhIOBpq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 21:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D02DD60F6C;
        Wed, 15 Sep 2021 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631670268;
        bh=U4wgAdnX4jgFXVJUlyBqTXWLsd7sRqaW5BSchLDuqP0=;
        h=Date:From:To:Subject:From;
        b=1sjswJlSsNSUeeZL/JTFi6R2bB9HOdMgvjNS5HQDlsmCOlppymSAm9WUWt/ollXcb
         GrNYrqKd1uBijeO1ob6oUIfTdcJz3eRqO6IS1C2kSdokc6aVJiCjXiU+kHKfNbnJVq
         Bzh6oSbrhFmss00bUfycr8MUFmjgXjh+vlktThB4=
Date:   Tue, 14 Sep 2021 18:44:28 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210915014428.ex-G4tE_d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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

