From: akpm@linux-foundation.org
Subject: + move-__attribute____cold__-functions-back-into-final-text-section.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:57:07 -0700
Message-ID: <200807010757.m617v7OT016033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYGAH5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, llipavsky@suse.cz, stable@kernel.org


The patch titled
     move __attribute__((__cold__)) functions back into final .text section
has been added to the -mm tree.  Its filename is
     move-__attribute____cold__-functions-back-into-final-text-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move __attribute__((__cold__)) functions back into final .text section
From: "Jan Beulich" <jbeulich@novell.com>

Due to the addition of __attribute__((__cold__)) to a few symbols without
adjusting the linker scripts, those symbols currently may end up outside
the [_stext,_etext) range, as they get placed in .text.unlikely by (at
least) gcc 4.3.0.  This may confuse code not only outside of the kernel,
symbol_put_addr()'s BUG() could also trigger.  Hence we need to add
.text.unlikely (and for future uses of __attribute__((__hot__)) also
.text.hot) to the TEXT_TEXT() macro.

Issue observed by Lukas Lipavsky.

Tested-by: Lukas Lipavsky <llipavsky@suse.cz>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~move-__attribute____cold__-functions-back-into-final-text-section include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~move-__attribute____cold__-functions-back-into-final-text-section
+++ a/include/asm-generic/vmlinux.lds.h
@@ -204,6 +204,7 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
+		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
 		*(.text.init.refok)					\
@@ -213,7 +214,8 @@
 	CPU_KEEP(init.text)						\
 	CPU_KEEP(exit.text)						\
 	MEM_KEEP(init.text)						\
-	MEM_KEEP(exit.text)
+	MEM_KEEP(exit.text)						\
+		*(.text.unlikely)
 
 
 /* sched.text is aling to function alignment to secure we have same
_

Patches currently in -mm which might be from jbeulich@novell.com are

move-__attribute____cold__-functions-back-into-final-text-section.patch
acpi-fix-fadt-parsing.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch

