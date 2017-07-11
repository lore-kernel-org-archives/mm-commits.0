From: akpm@linux-foundation.org
Subject: [merged] linux-bugh-correct-foo-should-be-foo.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:57 -0700
Message-ID: <20170711192557.AXojyqNLW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKTZ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, jakub.kicinski@netronome.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org


The patch titled
     Subject: linux/bug.h: correct "(foo*)" should be "(foo *)"
has been removed from the -mm tree.  Its filename was
     linux-bugh-correct-foo-should-be-foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from abbotti@mev.co.uk are

kernelh-handle-pointers-to-arrays-better-in-container_of.patch

