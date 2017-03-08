From: akpm@linux-foundation.org
Subject: + sh-cayman-ide-support-fix.patch added to -mm tree
Date: Wed, 08 Mar 2017 15:01:25 -0800
Message-ID: <58c08d45.5u17drsYUt+oCyJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752094AbdCHXBl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2017 18:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, dalias@libc.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: cayman: IDE support fix
has been added to the -mm tree.  Its filename is
     sh-cayman-ide-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-cayman-ide-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-cayman-ide-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: sh: cayman: IDE support fix

Remove incorrect CONFIG_IDE ifdef (CONFIG_IDE config option is for
internal drivers/ide/ use) and make IDE hardware interface always
initialized (not only when IDE subsystem is built-in).

This patch allows Cayman board to work with modular IDE subsystem support
and removes the requirement of having the whole core IDE subsystem
built-in when using libata PATA support.

Link: http://lkml.kernel.org/r/1990884.yFoE6lSB9G@amdc3058
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/mach-cayman/setup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/sh/boards/mach-cayman/setup.c~sh-cayman-ide-support-fix arch/sh/boards/mach-cayman/setup.c
--- a/arch/sh/boards/mach-cayman/setup.c~sh-cayman-ide-support-fix
+++ a/arch/sh/boards/mach-cayman/setup.c
@@ -128,7 +128,6 @@ static int __init smsc_superio_setup(voi
 	SMSC_SUPERIO_WRITE_INDEXED(1, SMSC_PRIMARY_INT_INDEX);
 	SMSC_SUPERIO_WRITE_INDEXED(12, SMSC_SECONDARY_INT_INDEX);
 
-#ifdef CONFIG_IDE
 	/*
 	 * Only IDE1 exists on the Cayman
 	 */
@@ -158,7 +157,6 @@ static int __init smsc_superio_setup(voi
 	SMSC_SUPERIO_WRITE_INDEXED(0x01, 0xc5); /* GP45 = IDE1_IRQ */
 	SMSC_SUPERIO_WRITE_INDEXED(0x00, 0xc6); /* GP46 = nIOROP */
 	SMSC_SUPERIO_WRITE_INDEXED(0x00, 0xc7); /* GP47 = nIOWOP */
-#endif
 
 	/* Exit the configuration state */
 	outb(SMSC_EXIT_CONFIG_KEY, SMSC_CONFIG_PORT_ADDR);
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

sh-cayman-ide-support-fix.patch

