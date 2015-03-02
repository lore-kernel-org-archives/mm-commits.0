From: akpm@linux-foundation.org
Subject: + console-fix-console-name-size-mismatch.patch added to -mm tree
Date: Mon, 02 Mar 2015 15:57:32 -0800
Message-ID: <54f4f8ec.GeoxIeumLhMvqZh8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbbCBX5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 18:57:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, gregkh@linuxfoundation.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: console: fix console name size mismatch
has been added to the -mm tree.  Its filename is
     console-fix-console-name-size-mismatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/console-fix-console-name-size-mismatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/console-fix-console-name-size-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: console: fix console name size mismatch

commit 6ae9200f2cab7 ("enlarge console.name") increased the storage for
the console name to 16 bytes, but not the corresponding struct
console_cmdline::name storage.  Console names longer than 8 bytes cause
read beyond end-of-string and failure to match console; I'm not sure if
there are other unexpected consequences.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Cc: <stable@vger.kernel.org>	[2.6.22+]
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/console_cmdline.h |    2 +-
 kernel/printk/printk.c          |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk/console_cmdline.h~console-fix-console-name-size-mismatch kernel/printk/console_cmdline.h
--- a/kernel/printk/console_cmdline.h~console-fix-console-name-size-mismatch
+++ a/kernel/printk/console_cmdline.h
@@ -3,7 +3,7 @@
 
 struct console_cmdline
 {
-	char	name[8];			/* Name of the driver	    */
+	char	name[16];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
 #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
diff -puN kernel/printk/printk.c~console-fix-console-name-size-mismatch kernel/printk/printk.c
--- a/kernel/printk/printk.c~console-fix-console-name-size-mismatch
+++ a/kernel/printk/printk.c
@@ -2464,6 +2464,7 @@ void register_console(struct console *ne
 	for (i = 0, c = console_cmdline;
 	     i < MAX_CMDLINECONSOLES && c->name[0];
 	     i++, c++) {
+		BUILD_BUG_ON(sizeof(c->name) != sizeof(newcon->name));
 		if (strcmp(c->name, newcon->name) != 0)
 			continue;
 		if (newcon->index >= 0 &&
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

console-fix-console-name-size-mismatch.patch
linux-next.patch

