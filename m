From: akpm@linux-foundation.org
Subject: - cris-add-missed-local_irq_restore-call.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:30 -0800
Message-ID: <200801290147.m0T1lUNX027285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbYA2BsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: add missed local_irq_restore call
has been removed from the -mm tree.  Its filename was
     cris-add-missed-local_irq_restore-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS: add missed local_irq_restore call
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
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

git-powerpc.patch
git-dvb.patch
wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch
git-x86.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
