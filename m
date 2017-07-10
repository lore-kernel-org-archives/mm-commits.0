From: akpm@linux-foundation.org
Subject: [patch 076/115] linux/bug.h: correct "(foo*)" should be
 "(foo *)"
Date: Mon, 10 Jul 2017 15:51:01 -0700
Message-ID: <20170710225101.WG-zEN_Ue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754987AbdGJWvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org

From: Ian Abbott <abbotti@mev.co.uk>
Subject: linux/bug.h: correct "(foo*)" should be "(foo *)"

Correct this checkpatch.pl error:

|ERROR: "(foo*)" should be "(foo *)"
|#19: FILE: include/linux/bug.h:19:
|+#define BUILD_BUG_ON_NULL(e) ((void*)0)

Link: http://lkml.kernel.org/r/20170525120316.24473-4-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bug.h~linux-bugh-correct-foo-should-be-foo include/linux/bug.h
--- a/include/linux/bug.h~linux-bugh-correct-foo-should-be-foo
+++ a/include/linux/bug.h
@@ -16,7 +16,7 @@ struct pt_regs;
 #define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
-#define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_NULL(e) ((void *)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
 #define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
_
