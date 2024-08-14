Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615C195
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 00:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723594065; cv=none; b=ik/LQXAPF3j8b6GxJI9IFz9XWX9ni64V+EqaTPNbNbSsUofts0WmdccMv2TlQGUxkJTo/jScMig2PtCdF78VUgTMibB1GVxoRtYZVNaR4KWrINAwZi1s4Giw9WFl4dinln1V5Gd+h9S6mqyilVK6MO763KKXV/WsiWl6AQCGQDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723594065; c=relaxed/simple;
	bh=jtYAIGHWikT3LqXgjJsigkv4I21z7vwWyOlYoDE5HlM=;
	h=Date:To:From:Subject:Message-Id; b=Tv0OoONBWN1YMRT4Cv+HoTMTWWT0VPso1Hrt88oau/SRSeSwXuvZEJDETTbboJmA/CyYznpNHoyTySZVYLQzjLWidvifODXa4xYaBf+YLSBnXkIM/aJcI04oHHDcdZs4F0/+/SFmuNpPyxMQemzaKmtOzWPYmEAdeXhTVBc2km4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y+Hqyn2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y+Hqyn2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F529C32782;
	Wed, 14 Aug 2024 00:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723594064;
	bh=jtYAIGHWikT3LqXgjJsigkv4I21z7vwWyOlYoDE5HlM=;
	h=Date:To:From:Subject:From;
	b=y+Hqyn2/VJBU1NswmRqsoXrX7L4Jvo0UKEvvAuZfypwb5K7cHxL8rXedXx2suYx/4
	 G5o5CmkFkrl9vc/w40GqE3ggTZWwR+czWIqRG1cc3kRp6uhuPcCOSOqGkSCFY7cdxC
	 mqHLhs1ZPqzeoY2IXVZUkn7Yf4REGhubBeAyxqeA=
Date: Tue, 13 Aug 2024 17:07:43 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rdunlap@infradead.org,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,geert+renesas@glider.be,dianders@chromium.org,dave.hansen@linux.intel.com,daniel.thompson@linaro.org,christophe.leroy@csgroup.eu,christophe.jaillet@wanadoo.fr,bp@alien8.de,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch added to mm-unstable branch
Message-Id: <20240814000744.8F529C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kgdb: fix hang on failed breakpoint removal
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Florian Rommel <mail@florommel.de>
Subject: x86/kgdb: fix hang on failed breakpoint removal
Date: Mon, 12 Aug 2024 01:22:08 +0200

On x86, occasionally, the removal of a breakpoint (i.e., removal of the
int3 instruction) fails because the text_mutex is taken by another CPU
(mainly due to the static_key mechanism, I think).  The function
kgdb_skipexception catches exceptions from these spurious int3
instructions, bails out of KGDB, and continues execution from the previous
PC address.

However, this led to an endless loop between the int3 instruction and
kgdb_skipexception since the int3 instruction (being still present)
triggered again.  This effectively caused the system to hang.

With this patch, we try to remove the concerned spurious int3 instruction
in kgdb_skipexception before continuing execution.  This may take a few
attempts until the concurrent holders of the text_mutex have released it,
but eventually succeeds and the kernel can continue.

Link: https://lkml.kernel.org/r/20240811232208.234261-3-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kgdb.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/arch/x86/kernel/kgdb.c~x86-kgdb-fix-hang-on-failed-breakpoint-removal
+++ a/arch/x86/kernel/kgdb.c
@@ -723,7 +723,31 @@ void kgdb_arch_exit(void)
 int kgdb_skipexception(int exception, struct pt_regs *regs)
 {
 	if (exception == 3 && kgdb_isremovedbreak(regs->ip - 1)) {
+		struct kgdb_bkpt *bpt;
+		int i, error;
+
 		regs->ip -= 1;
+
+		/*
+		 * Try to remove the spurious int3 instruction.
+		 * These int3s can result from failed breakpoint removals
+		 * in kgdb_arch_remove_breakpoint.
+		 */
+		for (bpt = NULL, i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+			if (kgdb_break[i].bpt_addr == regs->ip &&
+			    kgdb_break[i].state == BP_REMOVED &&
+			    (kgdb_break[i].type == BP_BREAKPOINT ||
+			     kgdb_break[i].type == BP_POKE_BREAKPOINT)) {
+				bpt = &kgdb_break[i];
+				break;
+			}
+		}
+		if (!bpt)
+			return 1;
+		error = kgdb_arch_remove_breakpoint(bpt);
+		if (error)
+			pr_err("skipexception: breakpoint remove failed: %lx\n",
+			       bpt->bpt_addr);
 		return 1;
 	}
 	return 0;
_

Patches currently in -mm which might be from mail@florommel.de are

x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch
x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch

