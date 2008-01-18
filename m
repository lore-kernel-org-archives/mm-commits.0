From: akpm@linux-foundation.org
Subject: + cris-add-missed-local_irq_restore-call.patch added to -mm tree
Date: Fri, 18 Jan 2008 13:22:54 -0800
Message-ID: <200801182122.m0ILMsC1005875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124AbYARVW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 16:22:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     CRIS: add missed local_irq_restore call
has been added to the -mm tree.  Its filename is
     cris-add-missed-local_irq_restore-call.patch

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
Subject: CRIS: add missed local_irq_restore call
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/io_interface_mux.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/arch-v10/kernel/io_interface_mux.c~cris-add-missed-local_irq_restore-call arch/cris/arch-v10/kernel/io_interface_mux.c
--- a/arch/cris/arch-v10/kernel/io_interface_mux.c~cris-add-missed-local_irq_restore-call
+++ a/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -392,6 +392,7 @@ int cris_request_io_interface(enum cris_
 	if (((interfaces[ioif].gpio_g_in & gpio_in_pins) != interfaces[ioif].gpio_g_in) ||
 	    ((interfaces[ioif].gpio_g_out & gpio_out_pins) != interfaces[ioif].gpio_g_out) ||
 	    ((interfaces[ioif].gpio_b & gpio_pb_pins) != interfaces[ioif].gpio_b)) {
+		local_irq_restore(flags);
 		printk(KERN_CRIT "cris_request_io_interface: Could not get required pins for interface %u\n",
 		       ioif);
 		return -EBUSY;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

cris-add-missed-local_irq_restore-call.patch
git-powerpc.patch
git-x86.patch
