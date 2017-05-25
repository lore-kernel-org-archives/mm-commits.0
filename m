From: akpm@linux-foundation.org
Subject: + linux-bugh-correct-space-required-before-that.patch added to
 -mm tree
Date: Thu, 25 May 2017 16:09:51 -0700
Message-ID: <5927643f.pwEwamUoBXziuOfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163136AbdEYXJw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, peterz@infradead.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/bug.h: correct "space required before that '-'"
has been added to the -mm tree.  Its filename is
     linux-bugh-correct-space-required-before-that.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-bugh-correct-space-required-before-that.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-bugh-correct-space-required-before-that.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from abbotti@mev.co.uk are

asm-generic-bugh-declare-struct-pt_regs-before-function-prototype.patch
linux-bugh-correct-formatting-of-block-comment.patch
linux-bugh-correct-foo-should-be-foo.patch
linux-bugh-correct-space-required-before-that.patch
bug-split-build_bug-stuff-out-into-linux-build_bugh.patch
kernelh-handle-pointers-to-arrays-better-in-container_of.patch

