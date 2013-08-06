From: akpm@linux-foundation.org
Subject: + printk-fix-return-of-braille_register_console.patch added to
 -mm tree
Date: Tue, 06 Aug 2013 13:52:21 -0700
Message-ID: <52016205.LUtD488dhq315N5/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3HFUwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 16:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, rostedt@goodmis.org

Subject: + printk-fix-return-of-braille_register_console.patch added to -mm tree
To: rostedt@goodmis.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 13:52:21 -0700


The patch titled
     Subject: printk: fix return of braille_register_console()
has been added to the -mm tree.  Its filename is
     printk-fix-return-of-braille_register_console.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-return-of-braille_register_console.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-return-of-braille_register_console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: printk: fix return of braille_register_console()

Some of my configs I test with have CONFIG_A11Y_BRAILLE_CONSOLE set.  When
I started testing against v3.11-rc4 my console went bonkers.  Using ktest
to bisect the issue, it came down to bbeddf52a ("printk: move braille
console support into separate braille.[ch] files").

Looking into the patch I found the problem.  It's with the return of
braille_register_console().  As anything other than NULL is considered a
failure.

But for those of us that have CONFIG_A11Y_BRAILLE_CONSOLE set but do not
define a "brl" or "brl=" on the command line, we still may want a console
that those with sight can still use.

Return NULL (success) if "brl" or "brl=" is not on the console line.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/braille.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk/braille.c~printk-fix-return-of-braille_register_console kernel/printk/braille.c
--- a/kernel/printk/braille.c~printk-fix-return-of-braille_register_console
+++ a/kernel/printk/braille.c
@@ -19,7 +19,8 @@ char *_braille_console_setup(char **str,
 			pr_err("need port name after brl=\n");
 		else
 			*((*str)++) = 0;
-	}
+	} else
+		return NULL;
 
 	return *str;
 }
_

Patches currently in -mm which might be from rostedt@goodmis.org are

printk-fix-return-of-braille_register_console.patch
linux-next.patch

