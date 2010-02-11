From: akpm@linux-foundation.org
Subject: + printk-avoid-warning-when-config_printk-is-disabled.patch added to -mm tree
Date: Thu, 11 Feb 2010 13:19:32 -0800
Message-ID: <201002112119.o1BLJW82029240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757111Ab0BKVTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 16:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padovan@profusion.mobi, mingo@elte.hu


The patch titled
     printk: avoid warning when CONFIG_PRINTK is disabled
has been added to the -mm tree.  Its filename is
     printk-avoid-warning-when-config_printk-is-disabled.patch

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
Subject: printk: avoid warning when CONFIG_PRINTK is disabled
From: "Gustavo F. Padovan" <padovan@profusion.mobi>

kernel/printk.c:72: warning: `saved_console_loglevel' defined but not used

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-avoid-warning-when-config_printk-is-disabled kernel/printk.c
--- a/kernel/printk.c~printk-avoid-warning-when-config_printk-is-disabled
+++ a/kernel/printk.c
@@ -71,8 +71,6 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
-static int saved_console_loglevel = -1;
