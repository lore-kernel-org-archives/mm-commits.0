Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABF1E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbjJDUYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244960AbjJDUXT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DEF5
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711D1C433C7;
        Wed,  4 Oct 2023 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450994;
        bh=JHhM2nzoYoTrJ87YduWLlIDpK8R2EoqLSTUy6Mdm6xI=;
        h=Date:To:From:Subject:From;
        b=xwGwSCrMwb4BKAR8hB3WPb7ncCMhA2hiHq7vfcTZYwwbS/sPKK64bs09V045iMLM+
         c1byYrtmsYDuH20q9McuwWV2GI/9Z0RP7ZT+bbXDFd7qYNag6ZEmNKGTn8K1dC2ZrR
         hr/4EB7zHcx/cwFRwryuxhheP2lQ/rsd47uVpm1Q=
Date:   Wed, 04 Oct 2023 13:23:12 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, rusty@rustcorp.com.au,
        nathan@kernel.org, mmarek@suse.com, luc.vanoostenryck@gmail.com,
        jbeulich@suse.com, arnd@arndb.de, ndesaulniers@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compilerh-unify-__unique_id.patch removed from -mm tree
Message-Id: <20231004202314.711D1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler.h: unify __UNIQUE_ID
has been removed from the -mm tree.  Its filename was
     compilerh-unify-__unique_id.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: compiler.h: unify __UNIQUE_ID
Date: Thu, 31 Aug 2023 09:33:40 -0700

commit 6f33d58794ef ("__UNIQUE_ID()")
added a fallback definition of __UNIQUE_ID because gcc 4.2 and older did
not support __COUNTER__.

Also, this commit is effectively a revert of
commit b41c29b0527c ("Kbuild: provide a __UNIQUE_ID for clang")
which mentions clang 2.6+ supporting __COUNTER__.

Documentation/process/changes.rst currently lists the minimum supported
version of these compilers as:
- gcc: 5.1
- clang: 11.0.0
It should be safe to say that __COUNTER__ is well supported by this
point.

Link: https://lkml.kernel.org/r/20230831-unique_id-v1-1-28bacd18eb1d@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Michal rarek <mmarek@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Paul Russel <rusty@rustcorp.com.au>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    5 -----
 include/linux/compiler-gcc.h   |    2 --
 include/linux/compiler.h       |    5 +----
 3 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/compiler-clang.h~compilerh-unify-__unique_id
+++ a/include/linux/compiler-clang.h
@@ -14,11 +14,6 @@
 #undef __cleanup
 #define __cleanup(func) __maybe_unused __attribute__((__cleanup__(func)))
 
-/* same as gcc, this was present in clang-2.6 so we can assume it works
- * with any version that can compile the kernel
- */
-#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
-
 /* all clang versions usable with the kernel support KASAN ABI version 5 */
 #define KASAN_ABI_VERSION 5
 
--- a/include/linux/compiler-gcc.h~compilerh-unify-__unique_id
+++ a/include/linux/compiler-gcc.h
@@ -39,8 +39,6 @@
 #define __noretpoline __attribute__((__indirect_branch__("keep")))
 #endif
 
-#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
-
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 #define __latent_entropy __attribute__((latent_entropy))
 #endif
--- a/include/linux/compiler.h~compilerh-unify-__unique_id
+++ a/include/linux/compiler.h
@@ -177,10 +177,7 @@ void ftrace_likely_update(struct ftrace_
 	__asm__ ("" : "=r" (var) : "0" (var))
 #endif
 
-/* Not-quite-unique ID. */
-#ifndef __UNIQUE_ID
-# define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
-#endif
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
 /**
  * data_race - mark an expression as containing intentional data races
_

Patches currently in -mm which might be from ndesaulniers@google.com are


