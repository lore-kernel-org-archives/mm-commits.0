From: akpm@linux-foundation.org
Subject: + sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:38:35 -0800
Message-ID: <200901290838.n0T8cZdb028855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbZA2Iiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:38:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     sgi-gru: exclude UV definitions on 32-bit x86
has been added to the -mm tree.  Its filename is
     sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: exclude UV definitions on 32-bit x86
From: Jack Steiner <steiner@sgi.com>

Eliminate compile errors on 32-bit X86 caused by UV.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/uv/uv_hub.h~sgi-gru-exclude-uv-definitions-on-32-bit-x86 arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~sgi-gru-exclude-uv-definitions-on-32-bit-x86
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -11,6 +11,7 @@
 #ifndef _ASM_X86_UV_UV_HUB_H
 #define _ASM_X86_UV_UV_HUB_H
 
+#ifdef CONFIG_X86_64
 #include <linux/numa.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
@@ -401,4 +402,5 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+#endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
_

Patches currently in -mm which might be from steiner@sgi.com are

sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

