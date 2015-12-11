From: akpm@linux-foundation.org
Subject: +
 printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch added to -mm tree
Date: Fri, 11 Dec 2015 14:58:34 -0800
Message-ID: <566b551a.Hu426q6+7jw12our%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbbLKW6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 17:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, arnd@arndb.de, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix
has been added to the -mm tree.  Its filename is
     printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix init/Kconfig
--- a/init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix
+++ a/init/Kconfig
@@ -870,7 +870,7 @@ config NMI_LOG_BUF_SHIFT
 	int "Temporary per-CPU NMI log buffer size (12 => 4KB, 13 => 8KB)"
 	range 10 21
 	default 13
-	depends on PRINTK && HAVE_NMI
+	depends on PRINTK_NMI
 	help
 	  Select the size of a per-CPU buffer where NMI messages are temporary
 	  stored. They are copied to the main log buffer in a safe context
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-use-irq-work-only-when-ready.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch

