From: akpm@linux-foundation.org
Subject: + whitelist-references-from-__dbe_table-to-init.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:33:50 -0700
Message-ID: <200707122333.l6CNXodD011396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355AbXGLXeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, sam@ravnborg.org


The patch titled
     kbuild: whitelist references from __dbe_table to .init
has been added to the -mm tree.  Its filename is
     whitelist-references-from-__dbe_table-to-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN scripts/mod/modpost.c~whitelist-references-from-__dbe_table-to-init scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~whitelist-references-from-__dbe_table-to-init
+++ a/scripts/mod/modpost.c
@@ -1057,6 +1057,7 @@ static int initexit_section_ref_ok(const
 		".machvec",		/* ia64 + powerpc uses these */
 		".machine.desc",
 		".opd",			/* See comment [OPD] */
+		"__dbe_table",
 		".parainstructions",
 		".pdr",
 		".plt",			/* seen on ARCH=um build on x86_64. Harmless */
_

Patches currently in -mm which might be from ralf@linux-mips.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-netdev-all.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
update-zilog-timeout.patch
zs-move-to-the-serial-subsystem.patch
zsc-drain-the-transmission-line.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
sb1250-duartc-sb1250-duart-serial-support.patch
whitelist-references-from-__dbe_table-to-init.patch
