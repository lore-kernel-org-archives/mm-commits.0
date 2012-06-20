From: akpm@linux-foundation.org
Subject: + mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:17:03 -0700
Message-ID: <20120620221703.D9BA0A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34548 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab2FTWRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:17:04 -0400
Received: by yenl3 with SMTP id l3so782990yen.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:17:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD
has been added to the -mm tree.  Its filename is
     mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch

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
Subject: mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD

include/linux/ptrace.h:66:0: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]
arch/mn10300/include/asm/ptrace.h:85:0: note: this is the location of the previous definition

We already have it in <linux/ptrace.h>, so remove it from <asm/ptrace.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/ptrace.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/mn10300/include/asm/ptrace.h~mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood arch/mn10300/include/asm/ptrace.h
--- a/arch/mn10300/include/asm/ptrace.h~mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood
+++ a/arch/mn10300/include/asm/ptrace.h
@@ -81,9 +81,6 @@ struct pt_regs {
 #define PTRACE_GETFPREGS          14
 #define PTRACE_SETFPREGS          15
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD     0x00000001
