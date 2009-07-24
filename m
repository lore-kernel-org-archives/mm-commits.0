From: akpm@linux-foundation.org
Subject: + fix-printk-enable-the-use-of-more-than-one-con_boot-early-console.patch added to -mm tree
Date: Thu, 23 Jul 2009 17:23:43 -0700
Message-ID: <200907240023.n6O0NhGG013202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbZGXAYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 20:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Sonic.Zhang@analog.com, mingo@elte.hu, rgetz@analog.com


The patch titled
     fix "printk: Enable the use of more than one CON_BOOT (early console)"
has been added to the -mm tree.  Its filename is
     fix-printk-enable-the-use-of-more-than-one-con_boot-early-console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "printk: Enable the use of more than one CON_BOOT (early console)"
From: Sonic Zhang <Sonic.Zhang@analog.com>

Don't return when we find the first bootconsole - it can leave other
bootconsoles still installed, and they can be used and cause problems
later (if they are in the init section, and eventually released), and
cause problems.  Make sure we remove all of them.

Signed-off-by: Sonic Zhang <Sonic.Zhang@analog.com>
Signed-off-by: Robin Getz <rgetz@analog.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~fix-printk-enable-the-use-of-more-than-one-con_boot-early-console kernel/printk.c
--- a/kernel/printk.c~fix-printk-enable-the-use-of-more-than-one-con_boot-early-console
+++ a/kernel/printk.c
@@ -1329,7 +1329,7 @@ static int __init disable_boot_consoles(
 		if (con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
 				con->name, con->index);
-			return unregister_console(con);
+			unregister_console(con);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from Sonic.Zhang@analog.com are

fix-printk-enable-the-use-of-more-than-one-con_boot-early-console.patch

