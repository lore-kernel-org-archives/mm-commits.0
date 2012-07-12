From: akpm@linux-foundation.org
Subject: [merged] mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:15 -0700
Message-ID: <20120712193616.238385C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35495 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2GLTgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:18 -0400
Received: by eaao13 with SMTP id o13so145165eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD
has been removed from the -mm tree.  Its filename was
     mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
