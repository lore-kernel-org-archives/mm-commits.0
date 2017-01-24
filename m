From: akpm@linux-foundation.org
Subject: + iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh.patch
 added to -mm tree
Date: Mon, 23 Jan 2017 16:16:53 -0800
Message-ID: <58869cf5.rq9N1wh4TUxK6+oA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdAXAQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 19:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/iopoll.h: include <linux/ktime.h> instead of <linux/hrtimer.h>
has been added to the -mm tree.  Its filename is
     iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/iopoll.h: include <linux/ktime.h> instead of <linux/hrtimer.h>

The timer APIs this header needs are ktime_get(), ktime_add_us(), and
ktime_compare().  So, including <linux/ktime.h> seems enough.  This commit
will cut unnecessary header file parsing.

Link: http://lkml.kernel.org/r/1481679225-10885-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iopoll.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/iopoll.h~iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh include/linux/iopoll.h
--- a/include/linux/iopoll.h~iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh
+++ a/include/linux/iopoll.h
@@ -17,7 +17,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/hrtimer.h>
+#include <linux/ktime.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/io.h>
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh.patch
scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

