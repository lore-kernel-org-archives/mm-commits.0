From: akpm@linux-foundation.org
Subject: + char-select-fw_loader-by-moxa.patch added to -mm tree
Date: Tue, 13 May 2008 13:23:29 -0700
Message-ID: <200805132023.m4DKNTir030343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760307AbYEMUYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 16:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, p.o.roussel@free.fr


The patch titled
     char: select fw_loader by moxa
has been added to the -mm tree.  Its filename is
     char-select-fw_loader-by-moxa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

char-select-fw_loader-by-moxa.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

