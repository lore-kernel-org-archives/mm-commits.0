From: akpm@linux-foundation.org
Subject: [merged] x86-vdso-fix-vdso2cs-special_pages-error-checking.patch
 removed from -mm tree
Date: Thu, 25 Sep 2014 12:05:34 -0700
Message-ID: <5424677e.UotDQj730ske6s3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaIYTFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, vdso: fix vdso2c's special_pages error checking
has been removed from the -mm tree.  Its filename was
     x86-vdso-fix-vdso2cs-special_pages-error-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: x86, vdso: fix vdso2c's special_pages error checking

Stephen Rothwell's compiler did something amazing: it unrolled a loop,
discovered that one iteration of that loop contained an always-true test,
and emitted a warning that will IMO only serve to convince people to
disable the warning.

That bogus warning caused me to wonder what prompted such an absurdity
from his compiler, and I discovered that the code in question was, in
fact, completely wrong -- I was looking things up in the wrong array.

This affects 3.16 as well, but the only effect is to screw up the
error checking a bit.  vdso2c's output is unaffected.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso2c.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/x86/vdso/vdso2c.h~x86-vdso-fix-vdso2cs-special_pages-error-checking arch/x86/vdso/vdso2c.h
--- a/arch/x86/vdso/vdso2c.h~x86-vdso-fix-vdso2cs-special_pages-error-checking
+++ a/arch/x86/vdso/vdso2c.h
@@ -109,16 +109,18 @@ static void BITSFUNC(go)(void *raw_addr,
 
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
-		if (!syms[i])
+		INT_BITS symval = syms[special_pages[i]];
+
+		if (!symval)
 			continue;  /* The mapping isn't used; ignore it. */
 
-		if (syms[i] % 4096)
+		if (symval % 4096)
 			fail("%s must be a multiple of 4096\n",
 			     required_syms[i].name);
-		if (syms[sym_vvar_start] > syms[i] + 4096)
-			fail("%s underruns begin_vvar\n",
+		if (symval + 4096 < syms[sym_vvar_start])
+			fail("%s underruns vvar_start\n",
 			     required_syms[i].name);
-		if (syms[i] + 4096 > 0)
+		if (symval + 4096 > 0)
 			fail("%s is on the wrong side of the vdso text\n",
 			     required_syms[i].name);
 	}
_

Patches currently in -mm which might be from luto@amacapital.net are

linux-next.patch

