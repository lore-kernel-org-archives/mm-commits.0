From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:47 -0700
Message-ID: <20120723213047.A18921E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53995 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2GWVas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:48 -0400
Received: by ggeh3 with SMTP id h3so783864gge.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: remove duplicate definition of PTRACE_O_TRACESYSGOOD
has been removed from the -mm tree.  Its filename was
     m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
