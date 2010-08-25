From: akpm@linux-foundation.org
Subject: + tmio_mmc-dont-clear-unhandled-pending-interrupts.patch added to -mm tree
Date: Wed, 25 Aug 2010 16:07:30 -0700
Message-ID: <201008252307.o7PN7Uqd021164__8111.32452586225$1282777669$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab0HYXHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 19:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yusuke.goda.sx@renesas.com, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, magnus.damm@gmail.com, matt@console-pimps.org, sameo@linux.intel.com, stable@kernel.org


The patch titled
     tmio_mmc: don't clear unhandled pending interrupts
has been added to the -mm tree.  Its filename is
     tmio_mmc-dont-clear-unhandled-pending-interrupts.patch

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
Subject: tmio_mmc: don't clear unhandled pending interrupts
From: Yusuke Goda <yusuke.goda.sx@renesas.com>

Previously, it was possible for ack_mmc_irqs() to clear pending interrupt
bits in the CTL_STATUS register, even though the interrupt handler had not
been called.  This was because of a race that existed when doing a
read-modify-write sequence on CTL_STATUS.  After the read step in this
sequence, if an interrupt occurred (causing one of the bits in CTL_STATUS
to be set) the write step would inadvertently clear it.

This patch eliminates this race by only writing to CTL_STATUS and clearing
the interrupts that were passed as an argument to ack_mmc_irqs()."

[matt@console-pimps.org: rewrote changelog]
Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.h~tmio_mmc-dont-clear-unhandled-pending-interrupts drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~tmio_mmc-dont-clear-unhandled-pending-interrupts
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -82,10 +82,7 @@
 
 #define ack_mmc_irqs(host, i) \
 	do { \
-		u32 mask;\
-		mask  = sd_ctrl_read32((host), CTL_STATUS); \
-		mask &= ~((i) & TMIO_MASK_IRQ); \
-		sd_ctrl_write32((host), CTL_STATUS, mask); \
+		sd_ctrl_write32((host), CTL_STATUS, ~(i)); \
 	} while (0)
 
 
_

Patches currently in -mm which might be from yusuke.goda.sx@renesas.com are

tmio_mmc-dont-clear-unhandled-pending-interrupts.patch
tmio_mmc-revise-a-limit-of-the-data-size.patch
tmio_mmc-revise-a-limit-of-the-data-size-fix.patch

