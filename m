From: akpm@linux-foundation.org
Subject: + alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration.patch added to -mm tree
Date: Thu, 07 Mar 2013 13:56:25 -0800
Message-ID: <20130307215625.7300731C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60146 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab3CGV40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 16:56:26 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so96351ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 13:56:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, david.rusling@linaro.org, dhowells@redhat.com


The patch titled
     Subject: alpha: boot: fix build breakage introduced by system.h disintegration
has been added to the -mm tree.  Its filename is
     alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
alpha-boot-fix-build-breakage-introduced-by-systemh-disintegration.patch

