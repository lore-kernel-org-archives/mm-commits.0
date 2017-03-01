From: akpm@linux-foundation.org
Subject: + correct-function-definition-for-c.patch added to -mm tree
Date: Tue, 28 Feb 2017 17:06:08 -0800
Message-ID: <58b61e80.2A26+CH2Hg+jH+aG%akpm__13938.0364482806$1488333743$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdCACBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 21:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joakim.tjernlund@infinera.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/printk.h: correct function definition for C++
has been added to the -mm tree.  Its filename is
     correct-function-definition-for-c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/correct-function-definition-for-c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/correct-function-definition-for-c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: include/linux/printk.h: correct function definition for C++

C++ does does not like the extra extern before asmlinkage, remove it.

Link: http://lkml.kernel.org/r/20170221151044.5499-1-joakim.tjernlund@infinera.com
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/printk.h~correct-function-definition-for-c include/linux/printk.h
--- a/include/linux/printk.h~correct-function-definition-for-c
+++ a/include/linux/printk.h
@@ -139,7 +139,7 @@ struct va_format {
 })
 
 #ifdef CONFIG_EARLY_PRINTK
-extern asmlinkage __printf(1, 2)
+asmlinkage  __printf(1, 2)
 void early_printk(const char *fmt, ...);
 #else
 static inline __printf(1, 2) __cold
@@ -279,7 +279,7 @@ static inline void printk_safe_flush_on_
 }
 #endif
 
-extern asmlinkage void dump_stack(void) __cold;
+asmlinkage void dump_stack(void) __cold;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
_

Patches currently in -mm which might be from joakim.tjernlund@infinera.com are

correct-function-definition-for-c.patch
compilerh-fix-c-uninitialized-const-issue.patch

