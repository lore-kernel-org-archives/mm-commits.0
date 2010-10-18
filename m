From: akpm@linux-foundation.org
Subject: + um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.patch added to -mm tree
Date: Mon, 18 Oct 2010 15:12:23 -0700
Message-ID: <201010182212.o9IMCNLw004503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab0JRWMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 18:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com, stable@kernel.org, tabbott@ksplice.com


The patch titled
     um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
has been added to the -mm tree.  Its filename is
     um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.patch

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
Subject: um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
From: Richard Weinberger <richard@nod.at>

The linker script cleanup that I did in commit 5d150a97f93 ("um: Clean up
linker script using standard macros.") (2.6.32) accidentally introduced an
ALIGN(PAGE_SIZE) when converting to use INIT_TEXT_SECTION; Richard
Weinberger reported that this causes the kernel to segfault with
CONFIG_STATIC_LINK=y.

I'm not certain why this extra alignment is a problem, but it seems likely
it is because previously

__init_begin = _stext = _text = _sinittext

and with the extra ALIGN(PAGE_SIZE), _sinittext becomes different from the
rest.  So there is likely a bug here where something is assuming that
_sinittext is the same as one of those other symbols.  But reverting the
accidental change fixes the regression, so it seems worth committing that
now.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Reported-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/uml.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/uml.lds.S~um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault
+++ a/arch/um/kernel/uml.lds.S
@@ -22,7 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
hostfs-fix-uml-crash.patch
um-fix-global-timer-issue-when-using-config_no_hz.patch
um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch

