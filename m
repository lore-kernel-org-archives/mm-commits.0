From: akpm@linux-foundation.org
Subject: + serio-fix-modpost-warning.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:02:19 -0700
Message-ID: <200708152302.l7FN2Jvk019610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758063AbXHOXDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, akpm@linux-foundation.org, dtor@mail.ru


The patch titled
     SERIO: Fix modpost warning
has been added to the -mm tree.  Its filename is
     serio-fix-modpost-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SERIO: Fix modpost warning
From: Ralf Baechle <ralf@linux-mips.org>

i8042_unregister_ports's only caller i8042_remove is a __devexit function
so make it __devexit too.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/serio/i8042.c~serio-fix-modpost-warning drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~serio-fix-modpost-warning
+++ a/drivers/input/serio/i8042.c
@@ -1042,7 +1042,7 @@ static void __devinit i8042_register_por
 	}
 }
 
-static void __devinit i8042_unregister_ports(void)
+static void __devexit i8042_unregister_ports(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

serial_txx9-fix-modem-control-line-handling.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
git-mtd.patch
git-netdev-all.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
