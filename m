From: akpm@linux-foundation.org
Subject: - ps3-fix-build-with-32-bit-toolchains.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:39 -0700
Message-ID: <200707230934.l6N9Ydp5016411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758864AbXGWJpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, geert@linux-m68k.org, grant.likely@secretlab.ca, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PS3: Fix build with 32-bit toolchains
has been removed from the -mm tree.  Its filename was
     ps3-fix-build-with-32-bit-toolchains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kgdb.patch
