Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2774EC001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjIBXaL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBXaL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:30:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A791A4
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 839E1CE08BE
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1A4C433C7;
        Sat,  2 Sep 2023 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693697404;
        bh=Y9C3D1sJVFtzAiLJFibuurA5UGY/eMdL2bQD9qlwKIc=;
        h=Date:To:From:Subject:From;
        b=i66wXN96uWBx8h+t9QvmaeIX7nKq10y6BL0hBqG7bQcXcPwP14IJ6ck3lGRkSib26
         eHgRX+vc9uykfnqSNS6b3TJuFDejGz+xBrMFFzDe3cFk34cCEO6Lrx8xySH/5aZE+f
         PGGG5AHPOnJcfEifFOMlnfKiz+i7Fj4RiiHZshkM=
Date:   Sat, 02 Sep 2023 16:30:03 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, rusty@rustcorp.com.au,
        nathan@kernel.org, mmarek@suse.com, luc.vanoostenryck@gmail.com,
        jbeulich@suse.com, arnd@arndb.de, ndesaulniers@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-unify-__unique_id.patch added to mm-nonmm-unstable branch
Message-Id: <20230902233004.BC1A4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: unify __UNIQUE_ID
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compilerh-unify-__unique_id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-unify-__unique_id.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

compilerh-unify-__unique_id.patch

