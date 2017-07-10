From: akpm@linux-foundation.org
Subject: [patch 077/115] linux/bug.h: correct "space required
 before that '-'"
Date: Mon, 10 Jul 2017 15:51:04 -0700
Message-ID: <20170710225104.N2_ZhnTUJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754936AbdGJWvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org

From: Ian Abbott <abbotti@mev.co.uk>
Subject: linux/bug.h: correct "space required before that '-'"

Correct these checkpatch.pl errors:

|ERROR: space required before that '-' (ctx:OxO)
|#37: FILE: include/linux/bug.h:37:
|+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))

|ERROR: space required before that '-' (ctx:OxO)
|#38: FILE: include/linux/bug.h:38:
|+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))

I decided to wrap the bitfield expressions that begin with minus signs
in parentheses rather than insert spaces before the minus signs.

Link: http://lkml.kernel.org/r/20170525120316.24473-5-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bug.h~linux-bugh-correct-space-required-before-that include/linux/bug.h
--- a/include/linux/bug.h~linux-bugh-correct-space-required-before-that
+++ a/include/linux/bug.h
@@ -36,8 +36,8 @@ struct pt_regs;
  * e.g. in a structure initializer (or where-ever else comma expressions
  * aren't permitted).
  */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:(-!!(e)); }))
 
 /*
  * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
_
