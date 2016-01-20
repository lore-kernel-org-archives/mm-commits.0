From: akpm@linux-foundation.org
Subject: [alternative-merged]
 um-fix-build-error-and-kconfig-for-i386.patch removed from -mm tree
Date: Wed, 20 Jan 2016 13:46:30 -0800
Message-ID: <56a00036./prfqpFiKKlLjAOf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbcATVqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:46:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mic@digikod.net, mm-commits@vger.kernel.org


The patch titled
     Subject: um: fix build error and kconfig for i386
has been removed from the -mm tree.  Its filename was
     um-fix-build-error-and-kconfig-for-i386.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
=46rom: Micka=EBl Sala=FCn <mic@digikod.net>
Subject: um: fix build error and kconfig for i386

=46ix build error by selecting COREDUMP when X86_32 is selected:

arch/x86/um/built-in.o: In function `elf_core_write_extra_phdrs':
(.text+0x3e62): undefined reference to `dump_emit'
arch/x86/um/built-in.o: In function `elf_core_write_extra_data':
(.text+0x3eef): undefined reference to `dump_emit'

=46ixes: 5d2acfc7b974 ("kconfig: make allnoconfig disable options behin=
d EMBEDDED and EXPERT")
Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/um/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/um/Kconfig~um-fix-build-error-and-kconfig-for-i386 a=
rch/x86/um/Kconfig
--- a/arch/x86/um/Kconfig~um-fix-build-error-and-kconfig-for-i386
+++ a/arch/x86/um/Kconfig
@@ -26,6 +26,7 @@ config X86_32
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select COREDUMP
=20
 config X86_64
 	def_bool 64BIT
_

Patches currently in -mm which might be from mic@digikod.net are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
