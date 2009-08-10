From: akpm@linux-foundation.org
Subject: [merged] fix-printk-enable-the-use-of-more-than-one-con_boot-early-console.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:56 -0700
Message-ID: <200908101927.n7AJRu2a026758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbZHJT2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sonic.Zhang@analog.com, mingo@elte.hu, rgetz@analog.com, mm-commits@vger.kernel.org


The patch titled
     fix "printk: Enable the use of more than one CON_BOOT (early console)"
has been removed from the -mm tree.  Its filename was
     fix-printk-enable-the-use-of-more-than-one-con_boot-early-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

