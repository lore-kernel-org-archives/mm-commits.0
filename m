From: akpm@linux-foundation.org
Subject: + kbuild-fix-optimization-level-choice-default.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:25:31 -0700
Message-ID: <59d55fdb.sOLBXfyS8iu95suV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdJDWZc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ulfalizer@gmail.com, arnd@arndb.de, daniel@zonque.org, keescook@chromium.org, nicolas.pitre@linaro.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: fix optimization level choice default
has been added to the -mm tree.  Its filename is
     kbuild-fix-optimization-level-choice-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kbuild-fix-optimization-level-choice-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kbuild-fix-optimization-level-choice-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulf Magnusson <ulfalizer@gmail.com>
Subject: kbuild: fix optimization level choice default

The choice containing the CC_OPTIMIZE_FOR_PERFORMANCE symbol accidentally
added a "CONFIG_" prefix when trying to make it the default, selecting an
undefined symbol as the default.

The mistake is harmless here: Since the default symbol is not visible, the
choice falls back on using the visible symbol as the default instead,
which is CC_OPTIMIZE_FOR_PERFORMANCE, as intended.

A patch that makes Kconfig print a warning in this case has been submitted
separately: http://www.spinics.net/lists/linux-kbuild/msg15566.html

Link: http://lkml.kernel.org/r/1507074806-21577-1-git-send-email-ulfalizer@gmail.com
Signed-off-by: Ulf Magnusson <ulfalizer@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Mack <daniel@zonque.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~kbuild-fix-optimization-level-choice-default init/Kconfig
--- a/init/Kconfig~kbuild-fix-optimization-level-choice-default
+++ a/init/Kconfig
@@ -1033,7 +1033,7 @@ endif
 
 choice
 	prompt "Compiler optimization level"
-	default CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
+	default CC_OPTIMIZE_FOR_PERFORMANCE
 
 config CC_OPTIMIZE_FOR_PERFORMANCE
 	bool "Optimize for performance"
_

Patches currently in -mm which might be from ulfalizer@gmail.com are

kbuild-fix-optimization-level-choice-default.patch

