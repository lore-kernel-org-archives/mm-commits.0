From: akpm@linux-foundation.org
Subject: - whitelist-references-from-__dbe_table-to-init.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:15 -0700
Message-ID: <200707312357.l6VNvFHA029382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757756AbXHAAQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: whitelist references from __dbe_table to .init
has been removed from the -mm tree.  Its filename was
     whitelist-references-from-__dbe_table-to-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: whitelist references from __dbe_table to .init
From: Ralf Baechle <ralf@linux-mips.org>

This is needed on MIPS where the same mechanism as get_user() is used to
intercept bus error exceptions for some hardware probes.  Without this
patch modpost will throw spurious warnings:

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/mips/sgi-ip22/built-in.o(__dbe_table+0x0): Section mismatch: reference to .init.text:

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/mod/modpost.c~whitelist-references-from-__dbe_table-to-init scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~whitelist-references-from-__dbe_table-to-init
+++ a/scripts/mod/modpost.c
@@ -1121,6 +1121,7 @@ static int initexit_section_ref_ok(const
 		".machvec",		/* ia64 + powerpc uses these */
 		".machine.desc",
 		".opd",			/* See comment [OPD] */
+		"__dbe_table",
 		".parainstructions",
 		".pdr",
 		".plt",			/* seen on ARCH=um build on x86_64. Harmless */
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-remove-some-duplicate-includes.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
git-mtd.patch
git-netdev-all.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
