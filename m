From: akpm@linux-foundation.org
Subject: + ps3-fix-build-with-32-bit-toolchains.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:10:51 -0700
Message-ID: <200707201810.l6KIApXa009362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763473AbXGTSLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geoffrey.levand@am.sony.com, geert@linux-m68k.org, grant.likely@secretlab.ca, paulus@samba.org


The patch titled
     PS3: Fix build with 32-bit toolchains
has been added to the -mm tree.  Its filename is
     ps3-fix-build-with-32-bit-toolchains.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PS3: Fix build with 32-bit toolchains
From: Geoff Levand <geoffrey.levand@am.sony.com>

The PS3 bootwrapper files use instructions only available on 64-bit CPUs. 
Add the code generation directive '.machine "ppc64"' for toolchains
configured for 32-bit CPUs.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/ps3-head.S   |    2 ++
 arch/powerpc/boot/ps3-hvcall.S |    2 ++
 2 files changed, 4 insertions(+)

diff -puN arch/powerpc/boot/ps3-head.S~ps3-fix-build-with-32-bit-toolchains arch/powerpc/boot/ps3-head.S
--- a/arch/powerpc/boot/ps3-head.S~ps3-fix-build-with-32-bit-toolchains
+++ a/arch/powerpc/boot/ps3-head.S
@@ -20,6 +20,8 @@
 
 #include "ppc_asm.h"
 
+	.machine "ppc64"
+
 	.text
 
 /*
diff -puN arch/powerpc/boot/ps3-hvcall.S~ps3-fix-build-with-32-bit-toolchains arch/powerpc/boot/ps3-hvcall.S
--- a/arch/powerpc/boot/ps3-hvcall.S~ps3-fix-build-with-32-bit-toolchains
+++ a/arch/powerpc/boot/ps3-hvcall.S
@@ -20,6 +20,8 @@
 
 #include "ppc_asm.h"
 
+	.machine "ppc64"
+
 /*
  * The PS3 hypervisor uses a 64 bit "C" language calling convention.
  * The routines here marshal arguments between the 32 bit wrapper
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

origin.patch
git-kgdb.patch
ps3-disk-storage-driver.patch
ps3-disk-storage-driver-use-correct-bio-vector-size.patch
ps3-disk-storage-driver-updates-after-final-review.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3-fix-build-with-32-bit-toolchains.patch
