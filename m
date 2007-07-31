From: akpm@linux-foundation.org
Subject: - alpha-fix-objstripc-compilation-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:11 -0700
Message-ID: <200707312356.l6VNuB4K029298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764168AbXHAARj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix objstrip.c compilation warnings
has been removed from the -mm tree.  Its filename was
     alpha-fix-objstripc-compilation-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: fix objstrip.c compilation warnings
From: Meelis Roos <mroos@linux.ee>

In current 2.6.23-rc1+git, make bootimage gives the following warnings while
compiling objstrip.c.  The patch below fixes these warnings by casting strncmp
argument to char * - it does not seem feasible to change its type in struct
elfhdr.

  HOSTCC  arch/alpha/boot/tools/objstrip
arch/alpha/boot/tools/objstrip.c: In function 'main':
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/tools/objstrip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/boot/tools/objstrip.c~alpha-fix-objstripc-compilation-warnings arch/alpha/boot/tools/objstrip.c
--- a/arch/alpha/boot/tools/objstrip.c~alpha-fix-objstripc-compilation-warnings
+++ a/arch/alpha/boot/tools/objstrip.c
@@ -144,7 +144,7 @@ main (int argc, char *argv[])
 #ifdef __ELF__
     elf = (struct elfhdr *) buf;
 
-    if (elf->e_ident[0] == 0x7f && strncmp(elf->e_ident + 1, "ELF", 3) == 0) {
+    if (elf->e_ident[0] == 0x7f && strncmp((char *)elf->e_ident + 1, "ELF", 3) == 0) {
 	if (elf->e_type != ET_EXEC) {
 	    fprintf(stderr, "%s: %s is not an ELF executable\n",
 		    prog_name, inname);
_

Patches currently in -mm which might be from mroos@linux.ee are

origin.patch
acpi-cure-run-together-printk-lines.patch
fix-runtogether-printks-in-cmd64x-ide-driver.patch
