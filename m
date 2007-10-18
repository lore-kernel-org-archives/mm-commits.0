From: akpm@linux-foundation.org
Subject: - x86_64-vdso-put-vars-in-rodata.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:14 -0700
Message-ID: <200710180708.l9I78EnL031844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759816AbXJRHI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 vDSO: put vars in .rodata
has been removed from the -mm tree.  Its filename was
     x86_64-vdso-put-vars-in-rodata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 vDSO: put vars in .rodata
From: Roland McGrath <roland@redhat.com>

This adds a const to the definitions vvar.c makes, so that the vdso_*
variables go into .rodata instead of .data.  This is essentially a cosmetic
change, just giving the section headers in the vDSO file more pleasing flags. 
These variables are read-only from the perspective of the vDSO itself and user
mode, even though the contents of the DSO image were adjusted at boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/vdso/vvar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/vdso/vvar.c~x86_64-vdso-put-vars-in-rodata arch/x86_64/vdso/vvar.c
--- a/arch/x86/vdso/vvar.c~x86_64-vdso-put-vars-in-rodata
+++ a/arch/x86/vdso/vvar.c
@@ -8,5 +8,5 @@
 #include <asm/timex.h>
 #include <asm/vgtod.h>
 
-#define VEXTERN(x) typeof (__ ## x) *vdso_ ## x = (void *)VMAGIC;
+#define VEXTERN(x) typeof (__ ## x) *const vdso_ ## x = (void *)VMAGIC;
 #include "vextern.h"
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86_64-use-linux-elfcore-compath.patch
fix-tsk-exit_state-usage-resend.patch
