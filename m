From: akpm@linux-foundation.org
Subject: + drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:23:41 -0700
Message-ID: <201104112323.p3BNNfZc010391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab1DKXXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wanlong.gao@gmail.com, steiner@sgi.com, tglx@linutronix.de


The patch titled
     drivers/misc/sgi-gru/grufile.c: fix the wrong members of gru_chip
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip.patch

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
Subject: drivers/misc/sgi-gru/grufile.c: fix the wrong members of gru_chip
From: Wanlong Gao <wanlong.gao@gmail.com>

Fix the wrong members and the wrong function's definition, since the
irq_chip had changed.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -348,15 +348,15 @@ static unsigned long gru_chiplet_cpu_to_
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_data *d)
 {
 }
 
 static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
 	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
+		.irq_mask	= gru_noop,
+		.irq_unmask	= gru_noop,
+		.irq_ack	= gru_noop
 	}
 };
 
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are

drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip.patch
avr32-s-irq_chip-irq_data-in-various-places.patch
xtensa-s-irq_chip-irq_data-in-various-places.patch

