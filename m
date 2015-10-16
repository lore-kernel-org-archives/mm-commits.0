From: akpm@linux-foundation.org
Subject: + arch-x86-use-sign_extend64-for-sign-extension.patch added to
 -mm tree
Date: Fri, 16 Oct 2015 14:18:49 -0700
Message-ID: <562169b9.YeynvLp5gC0cH8/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbJPVSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 17:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.p.zijlstra@chello.nl, acme@kernel.org, dvlasenk@redhat.com, hpa@zytor.com, linux@horizon.com, linux@rasmusvillemoes.dk, martin.kepplinger@theobroma-systems.com, maxime.coquelin@st.com, mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/cpu/perf_event_msr.c: use sign_extend64() for sign extension
has been added to the -mm tree.  Its filename is
     arch-x86-use-sign_extend64-for-sign-extension.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-use-sign_extend64-for-sign-extension.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-use-sign_extend64-for-sign-extension.patch

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
Subject: arch/x86/kernel/cpu/perf_event_msr.c: use sign_extend64() for sign extension

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

 arch/x86/kernel/cpu/perf_event_msr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_msr.c~arch-x86-use-sign_extend64-for-sign-extension arch/x86/kernel/cpu/perf_event_msr.c
--- a/arch/x86/kernel/cpu/perf_event_msr.c~arch-x86-use-sign_extend64-for-sign-extension
+++ a/arch/x86/kernel/cpu/perf_event_msr.c
@@ -163,10 +163,9 @@ again:
 		goto again;
 
 	delta = now - prev;
-	if (unlikely(event->hw.event_base == MSR_SMI_COUNT)) {
-		delta <<= 32;
-		delta >>= 32; /* sign extend */
-	}
+	if (unlikely(event->hw.event_base == MSR_SMI_COUNT))
+		delta = sign_extend64(delta, 31);
+
 	local64_add(now - prev, &event->count);
 }
 
_

Patches currently in -mm which might be from martink@posteo.de are

bitopsh-improve-sign_extend32s-documentation.patch
bitopsh-add-sign_extend64.patch
arch-sh-use-sign_extend64-for-sign-extension.patch
arch-sh-use-sign_extend64-for-sign-extension-2.patch
arch-x86-use-sign_extend64-for-sign-extension.patch

