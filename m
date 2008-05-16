From: akpm@linux-foundation.org
Subject: - char-select-fw_loader-by-moxa.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:29 -0700
Message-ID: <200805162253.m4GMrTJX003144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbYEPWxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, p.o.roussel@free.fr, mm-commits@vger.kernel.org


The patch titled
     char: select fw_loader by moxa
has been removed from the -mm tree.  Its filename was
     char-select-fw_loader-by-moxa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: select fw_loader by moxa
From: Jiri Slaby <jirislaby@gmail.com>

Select FW_LOADER since moxa needs it, otherwise we face link problems such
as:

drivers/built-in.o: In function
moxa_pci_probe':moxa.c:(.devinit.text+0x76d8): undefined reference to
request_firmware'
:moxa.c:(.devinit.text+0x7e6e): undefined reference to release_firmware'
make: *** [.tmp_vmlinux1] Error 1

Reported-by: Philippe Roussel <p.o.roussel@free.fr>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/Kconfig~char-select-fw_loader-by-moxa drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-select-fw_loader-by-moxa
+++ a/drivers/char/Kconfig
@@ -196,6 +196,7 @@ config ESPSERIAL
 config MOXA_INTELLIO
 	tristate "Moxa Intellio support"
 	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	select FW_LOADER
 	help
 	  Say Y here if you have a Moxa Intellio multiport serial card.
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

