From: akpm@linux-foundation.org
Subject: + m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:35:44 -0700
Message-ID: <20120713213545.6517D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:64895 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2GMVfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:35:47 -0400
Received: by wgbdt11 with SMTP id dt11so205260wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:35:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, takata@linux-m32r.org


The patch titled
     Subject: m32r: remove duplicate definition of PTRACE_O_TRACESYSGOOD
has been added to the -mm tree.  Its filename is
     m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: remove duplicate definition of PTRACE_O_TRACESYSGOOD

include/linux/ptrace.h:66:0: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]
arch/m32r/include/asm/ptrace.h:117:0: note: this is the location of the previous definition

We already have it in <linux/ptrace.h>, so remove it from <asm/ptrace.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/ptrace.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/m32r/include/asm/ptrace.h~m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood arch/m32r/include/asm/ptrace.h
--- a/arch/m32r/include/asm/ptrace.h~m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood
+++ a/arch/m32r/include/asm/ptrace.h
@@ -113,9 +113,6 @@ struct pt_regs {
 
 #define PTRACE_OLDSETOPTIONS	21
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD	0x00000001
