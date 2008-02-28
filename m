From: akpm@linux-foundation.org
Subject: + acpi-add-acpi-aliases-to-toshiba_acpi-module.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:49:00 -0800
Message-ID: <200802280049.m1S0n0Cq007519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbYB1Ata (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, blino@mandriva.com, lenb@kernel.org


The patch titled
     ACPI: add ACPI aliases to toshiba_acpi module
has been added to the -mm tree.  Its filename is
     acpi-add-acpi-aliases-to-toshiba_acpi-module.patch

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
Subject: ACPI: add ACPI aliases to toshiba_acpi module
From: Andrey Borzenkov < arvidjaar@mail.ru>

This adds aliases to enable autoloading of toishiba_acpi.  Two aliases are
defined - TOS6200 (for \\_SB_.VALD.GHCI) and TSO1900 (for \\_SB_.VALZ.GHCI). 
This allows toishiba_acpi to be autoloaded on systems that provide those
devices.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Olivier Blin <blino@mandriva.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/acpi/toshiba_acpi.c~acpi-add-acpi-aliases-to-toshiba_acpi-module drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~acpi-add-acpi-aliases-to-toshiba_acpi-module
+++ a/drivers/acpi/toshiba_acpi.c
@@ -99,6 +99,13 @@ MODULE_LICENSE("GPL");
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
 
+static const struct acpi_device_id toshiba_device_ids[] = {
+	{"TOS6200", 0},
+	{"TOS1900", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
+
 /* utility
  */
 
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

e100-do-suspend-shutdown-like-e1000.patch
acpi-add-acpi-aliases-to-toshiba_acpi-module.patch
