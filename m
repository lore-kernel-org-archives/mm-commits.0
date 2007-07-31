From: akpm@linux-foundation.org
Subject: - alpha-fix-mkbb-compilation-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:08 -0700
Message-ID: <200707312356.l6VNu8Z5029295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762597AbXHAARq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix mkbb compilation warnings
has been removed from the -mm tree.  Its filename was
     alpha-fix-mkbb-compilation-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: fix mkbb compilation warnings
From: Meelis Roos <mroos@linux.ee>

In current 2.6.23-rc1+git, make bootimage gives the following warnings while
compiling mkbb.c.  The patch below fixes these warnings by using the proper
include for exit() and using appropriate printf format.

  HOSTCC  arch/alpha/boot/tools/mkbb
arch/alpha/boot/tools/mkbb.c: In function 'main':
arch/alpha/boot/tools/mkbb.c:95: warning: implicit declaration of function 'exit'
arch/alpha/boot/tools/mkbb.c:95: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:102: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:110: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:117: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
arch/alpha/boot/tools/mkbb.c:118: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:125: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
arch/alpha/boot/tools/mkbb.c:126: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:143: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:148: warning: incompatible implicit declaration of built-in function 'exit'

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/tools/mkbb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/alpha/boot/tools/mkbb.c~alpha-fix-mkbb-compilation-warnings arch/alpha/boot/tools/mkbb.c
--- a/arch/alpha/boot/tools/mkbb.c~alpha-fix-mkbb-compilation-warnings
+++ a/arch/alpha/boot/tools/mkbb.c
@@ -11,6 +11,7 @@
 
 #include <fcntl.h>
 #include <unistd.h>
+#include <stdlib.h>
 #include <stdio.h>
 
 /* Minimal definition of disklabel, so we don't have to include
@@ -114,7 +115,7 @@ int main(int argc, char ** argv)
     nread = read(fd, &bootloader_image, sizeof(bootblock));
     if(nread != sizeof(bootblock)) {
 	perror("lxboot read");
-	fprintf(stderr, "expected %d, got %d\n", sizeof(bootblock), nread);
+	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
     }
 
@@ -122,7 +123,7 @@ int main(int argc, char ** argv)
     nread = read(dev, &bootblock_from_disk, sizeof(bootblock));
     if(nread != sizeof(bootblock)) {
 	perror("bootblock read");
-	fprintf(stderr, "expected %d, got %d\n", sizeof(bootblock), nread);
+	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
     }
 
_

Patches currently in -mm which might be from mroos@linux.ee are

origin.patch
acpi-cure-run-together-printk-lines.patch
fix-runtogether-printks-in-cmd64x-ide-driver.patch
