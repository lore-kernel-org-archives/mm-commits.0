From: akpm@linux-foundation.org
Subject: [patch 075/115] linux/bug.h: correct formatting of block
 comment
Date: Mon, 10 Jul 2017 15:50:58 -0700
Message-ID: <20170710225058.tnVCTL21R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbdGJWu7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org

From: Ian Abbott <abbotti@mev.co.uk>
Subject: linux/bug.h: correct formatting of block comment

Correct these checkpatch.pl warnings:

|WARNING: Block comments use * on subsequent lines
|#34: FILE: include/linux/bug.h:34:
|+/* Force a compilation error if condition is true, but also produce a
|+   result (of value 0 and type size_t), so the expression can be used

|WARNING: Block comments use a trailing */ on a separate line
|#36: FILE: include/linux/bug.h:36:
|+   aren't permitted). */

Link: http://lkml.kernel.org/r/20170525120316.24473-3-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/bug.h~linux-bugh-correct-formatting-of-block-comment include/linux/bug.h
--- a/include/linux/bug.h~linux-bugh-correct-formatting-of-block-comment
+++ a/include/linux/bug.h
@@ -30,10 +30,12 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
 	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
 
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
+/*
+ * Force a compilation error if condition is true, but also produce a
+ * result (of value 0 and type size_t), so the expression can be used
+ * e.g. in a structure initializer (or where-ever else comma expressions
+ * aren't permitted).
+ */
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
_
