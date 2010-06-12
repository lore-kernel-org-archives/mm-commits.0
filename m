From: akpm@linux-foundation.org
Subject: + x86-olpc-add-support-for-calling-into-openfirmware-fix.patch added to -mm tree
Date: Fri, 11 Jun 2010 19:54:34 -0700
Message-ID: <201006120254.o5C2sSiV001711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab0FLCys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 22:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, dilinger@queued.net, hpa@zytor.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-olpc-add-support-for-calling-into-openfirmware-fix
has been added to the -mm tree.  Its filename is
     x86-olpc-add-support-for-calling-into-openfirmware-fix.patch

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
Subject: x86-olpc-add-support-for-calling-into-openfirmware-fix
From: Dave Young <hidave.darkstar@gmail.com>

  AS      arch/x86/kernel/entry_32.o
/home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h: Assembler messages:
/home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h:29: Error: no such instruction: `static inline void olpc_ofw_detect_range(void){}'

Cc: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/olpc_ofw.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/include/asm/olpc_ofw.h~x86-olpc-add-support-for-calling-into-openfirmware-fix arch/x86/include/asm/olpc_ofw.h
--- a/arch/x86/include/asm/olpc_ofw.h~x86-olpc-add-support-for-calling-into-openfirmware-fix
+++ a/arch/x86/include/asm/olpc_ofw.h
@@ -26,7 +26,9 @@ void olpc_ofw_detect_range(void);
 
 #else
 
+#ifndef __ASSEMBLER__
 static inline void olpc_ofw_detect_range(void) { }
+#endif
 
 #endif
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
x86-olpc-add-support-for-calling-into-openfirmware-fix.patch
x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch

