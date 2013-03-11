From: akpm@linux-foundation.org
Subject: [merged] alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:57 -0700
Message-ID: <20130311201658.772985A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:56610 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3CKUQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:59 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so423853yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, david.rusling@linaro.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: boot: fix build breakage introduced by system.h disintegration
has been removed from the -mm tree.  Its filename was
     alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: alpha: boot: fix build breakage introduced by system.h disintegration

Commit ec2212088c42 ("Disintegrate asm/system.h for Alpha") removed the
system.h include from boot/head.S, which puts the PAL_* asm constants out
of scope.

Include <asm/pal.h> so we can get building again.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: David Rusling <david.rusling@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/head.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/boot/head.S~alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration arch/alpha/boot/head.S
--- a/arch/alpha/boot/head.S~alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration
+++ a/arch/alpha/boot/head.S
@@ -4,6 +4,7 @@
  * initial bootloader stuff..
  */
 
+#include <asm/pal.h>
 
 	.set noreorder
 	.globl	__start
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch

