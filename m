From: akpm@linux-foundation.org
Subject: + watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch added to -mm tree
Date: Fri, 29 Feb 2008 14:49:09 -0800
Message-ID: <200802292249.m1TMnA5h024768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbYB2W62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 17:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, Thomas.Mingarelli@hp.com, rolandd@cisco.com, wim@iguana.be


The patch titled
     watchdog: hpwdt: fix declaration of struct smbios_entry_point()
has been added to the -mm tree.  Its filename is
     watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch

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
Subject: watchdog: hpwdt: fix declaration of struct smbios_entry_point()
From: Roland Dreier <rdreier@cisco.com>

On my HP DL380 G5 system running a 64-bit kernel, loading the hpwdt driver
causes a crash because the driver attempts to ioremap an invalid physical
address.  This is because the driver has an incorrect definition of the SMBIOS
table entry point structure: the table address is only a 32-bit quantity, and
making it a u64 means that the high-order 32 bits end up containing garbage.

Correcting the structure definition fixes the driver so that it loads without
any problems on my system.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/hpwdt.c~watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point
+++ a/drivers/watchdog/hpwdt.c
@@ -88,7 +88,7 @@ struct smbios_entry_point {
 	u8 intermediate_anchor[5];
 	u8 intermediate_checksum;
 	u16 table_length;
-	u64 table_address;
+	u32 table_address;
 	u16 table_num_structs;
 	u8 bcd_revision;
 };
_

Patches currently in -mm which might be from rdreier@cisco.com are

input-i8042-fix-warning-on-non-x86-builds.patch
git-net.patch
watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch
watchdog-hpwdt-fix-return-value-warning.patch
watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch

