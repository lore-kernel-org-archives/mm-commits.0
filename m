From: akpm@linux-foundation.org
Subject: - watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:29 -0800
Message-ID: <200803062222.m26MMTKR020812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146AbYCFWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, Thomas.Mingarelli@hp.com, rolandd@cisco.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: hpwdt: fix declaration of struct smbios_entry_point()
has been removed from the -mm tree.  Its filename was
     watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-watchdog.patch

