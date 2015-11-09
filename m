From: akpm@linux-foundation.org
Subject: [merged] arch-sh-use-sign_extend64-for-sign-extension.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:28 -0800
Message-ID: <5640fe2c.v+aduwxwXItMMubG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbKIUM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.p.zijlstra@chello.nl, acme@kernel.org, dvlasenk@redhat.com, hpa@zytor.com, linux@horizon.com, linux@rasmusvillemoes.dk, martin.kepplinger@theobroma-systems.com, maxime.coquelin@st.com, mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/kernel/traps_64.c: use sign_extend64() for sign extension
has been removed from the -mm tree.  Its filename was
     arch-sh-use-sign_extend64-for-sign-extension.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: arch/sh/kernel/traps_64.c: use sign_extend64() for sign extension

Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: George Spelvin <linux@horizon.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh5/unwind.c |    2 +-
 arch/sh/kernel/traps_64.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sh/kernel/cpu/sh5/unwind.c~arch-sh-use-sign_extend64-for-sign-extension arch/sh/kernel/cpu/sh5/unwind.c
--- a/arch/sh/kernel/cpu/sh5/unwind.c~arch-sh-use-sign_extend64-for-sign-extension
+++ a/arch/sh/kernel/cpu/sh5/unwind.c
@@ -159,7 +159,7 @@ static int lookup_prev_stack_frame(unsig
 
 			/* Sign extend */
 			regcache[dest] =
-				((((s64)(u64)op >> 10) & 0xffff) << 54) >> 54;
+				sign_extend64((((u64)op >> 10) & 0xffff), 9);
 			break;
 		case (0xd0 >> 2): /* addi */
 		case (0xd4 >> 2): /* addi.l */
diff -puN arch/sh/kernel/traps_64.c~arch-sh-use-sign_extend64-for-sign-extension arch/sh/kernel/traps_64.c
--- a/arch/sh/kernel/traps_64.c~arch-sh-use-sign_extend64-for-sign-extension
+++ a/arch/sh/kernel/traps_64.c
@@ -101,7 +101,7 @@ static int generate_and_check_address(st
 	if (displacement_not_indexed) {
 		__s64 displacement;
 		displacement = (opcode >> 10) & 0x3ff;
-		displacement = ((displacement << 54) >> 54); /* sign extend */
+		displacement = sign_extend64(displacement, 9);
 		addr = (__u64)((__s64)base_address + (displacement << width_shift));
 	} else {
 		__u64 offset;
_

Patches currently in -mm which might be from martink@posteo.de are


