From: akpm@linux-foundation.org
Subject: + arch-sh-use-sign_extend64-for-sign-extension.patch added to -mm tree
Date: Fri, 16 Oct 2015 14:18:45 -0700
Message-ID: <562169b5.T+U99U/DJ+uuDrN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbJPVSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 17:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.p.zijlstra@chello.nl, acme@kernel.org, dvlasenk@redhat.com, hpa@zytor.com, linux@horizon.com, linux@rasmusvillemoes.dk, martin.kepplinger@theobroma-systems.com, maxime.coquelin@st.com, mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/kernel/traps_64.c: use sign_extend64() for sign extension
has been added to the -mm tree.  Its filename is
     arch-sh-use-sign_extend64-for-sign-extension.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sh-use-sign_extend64-for-sign-extension.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sh-use-sign_extend64-for-sign-extension.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 arch/sh/kernel/traps_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

bitopsh-improve-sign_extend32s-documentation.patch
bitopsh-add-sign_extend64.patch
arch-sh-use-sign_extend64-for-sign-extension.patch
arch-sh-use-sign_extend64-for-sign-extension-2.patch
arch-x86-use-sign_extend64-for-sign-extension.patch

