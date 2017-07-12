From: akpm@linux-foundation.org
Subject: [patch 64/96] sh: mark end of BUG() implementation as
 unreachable
Date: Wed, 12 Jul 2017 14:36:13 -0700
Message-ID: <20170712213613.WvClPURWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbdGLVgS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dalias@libc.org, danielmicay@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ysato@users.sourceforge.jp

From: Kees Cook <keescook@chromium.org>
Subject: sh: mark end of BUG() implementation as unreachable

When building the sh architecture, the compiler doesn't realize that
BUG() doesn't return, so it will complain about functions using BUG()
that are marked with the noreturn attribute:

   lib/string.c: In function 'fortify_panic':
>> lib/string.c:986:1: warning: 'noreturn' function does return
    }
    ^

Link: http://lkml.kernel.org/r/20170627192050.GA66784@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sh/include/asm/bug.h~sh-mark-end-of-bug-implementation-as-unreachable arch/sh/include/asm/bug.h
--- a/arch/sh/include/asm/bug.h~sh-mark-end-of-bug-implementation-as-unreachable
+++ a/arch/sh/include/asm/bug.h
@@ -48,6 +48,7 @@ do {							\
 		   "i" (__FILE__),			\
 		   "i" (__LINE__), "i" (0),		\
 		   "i" (sizeof(struct bug_entry)));	\
+	unreachable();					\
 } while (0)
 
 #define __WARN_FLAGS(flags)				\
_
