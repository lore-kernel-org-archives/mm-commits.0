From: akpm@linux-foundation.org
Subject: + mips-add-bcm947xx-to-makefile.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:40:38 -0700
Message-ID: <200708092040.l79KecVk018435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760068AbXHIUvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, jolt@tuxbox.org, mb@bu3sch.de, nbd@openwrt.org, ralf@linux-mips.org


The patch titled
     MIPS: Add BCM947xx to Makefile
has been added to the -mm tree.  Its filename is
     mips-add-bcm947xx-to-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MIPS: Add BCM947xx to Makefile
From: Aurelien Jarno <aurelien@aurel32.net>

Add BCM947xx to arch/mips/Makefile.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Florian Schirmer <jolt@tuxbox.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Makefile |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN arch/mips/Makefile~mips-add-bcm947xx-to-makefile arch/mips/Makefile
--- a/arch/mips/Makefile~mips-add-bcm947xx-to-makefile
+++ a/arch/mips/Makefile
@@ -533,6 +533,13 @@ libs-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mip
 load-$(CONFIG_SIBYTE_BIGSUR)	:= 0xffffffff80100000
 
 #
+# Broadcom BCM947XX boards
+#
+core-$(CONFIG_BCM947XX)		+= arch/mips/bcm947xx/
+cflags-$(CONFIG_BCM947XX)	+= -Iinclude/asm-mips/mach-bcm947xx
+load-$(CONFIG_BCM947XX)		:= 0xffffffff80001000
+
+#
 # SNI RM
 #
 core-$(CONFIG_SNI_RM)		+= arch/mips/sni/
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
git-wireless.patch
