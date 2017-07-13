From: akpm@linux-foundation.org
Subject: [merged]
 sh-mark-end-of-bug-implementation-as-unreachable.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:42:28 -0700
Message-ID: <20170713204228.RfUXWTZZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUm3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, danielmicay@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: mark end of BUG() implementation as unreachable
has been removed from the -mm tree.  Its filename was
     sh-mark-end-of-bug-implementation-as-unreachable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are


