From: akpm@linux-foundation.org
Subject: +
 score-ptrace-remove-the-macros-which-not-be-used-currently.patch added to
 -mm tree
Date: Tue, 22 Jul 2014 13:41:58 -0700
Message-ID: <53cecc96.q7GM9o0XMBa0tW3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:41173 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaGVUl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:41:59 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so85813igi.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:41:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, lennox.wu@gmail.com, linux@roeck-us.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score, ptrace: remove unused macros
has been added to the -mm tree.  Its filename is
     score-ptrace-remove-the-macros-which-not-be-used-currently.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-ptrace-remove-the-macros-which-not-be-used-currently.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-ptrace-remove-the-macros-which-not-be-used-currently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: score, ptrace: remove unused macros

'COUNTER' and other same kind macros are too common to use, and easy to
get conflict with other modules.

At present, they are not used, so it is OK to simply remove them.  And the
related warning (allmodconfig with score):

    CC [M]  drivers/md/raid1.o
  In file included from drivers/md/raid1.c:42:0:
  drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
   #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
   ^
  In file included from ./arch/score/include/asm/ptrace.h:4:0,
                   from include/linux/sched.h:31,
                   from include/linux/blkdev.h:4,
                   from drivers/md/raid1.c:36:
  ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
   #define COUNTER  38

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/uapi/asm/ptrace.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/score/include/uapi/asm/ptrace.h~score-ptrace-remove-the-macros-which-not-be-used-currently arch/score/include/uapi/asm/ptrace.h
--- a/arch/score/include/uapi/asm/ptrace.h~score-ptrace-remove-the-macros-which-not-be-used-currently
+++ a/arch/score/include/uapi/asm/ptrace.h
@@ -4,17 +4,6 @@
 #define PTRACE_GETREGS		12
 #define PTRACE_SETREGS		13
 
-#define PC		32
-#define CONDITION	33
-#define ECR		34
-#define EMA		35
-#define CEH		36
-#define CEL		37
-#define COUNTER		38
-#define LDCR		39
-#define STCR		40
-#define PSR		41
