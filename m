From: akpm@linux-foundation.org
Subject: + forcdeth-increase-max_interrupt_work.patch added to -mm tree
Date: Fri, 29 Aug 2008 13:38:46 -0700
Message-ID: <200808292038.m7TKckwP003180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbYH2UlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Aug 2008 16:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, aabdulla@nvidia.com, jeff@garzik.org


The patch titled
     forcdeth: increase max_interrupt_work
has been added to the -mm tree.  Its filename is
     forcdeth-increase-max_interrupt_work.patch

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
Subject: forcdeth: increase max_interrupt_work
From: Joe Korty <joe.korty@ccur.com>

This eliminates the following often-generated warning from my 64 bit
Opteron SMP test stand:

	eth0: too many iterations (6) in nv_nic_irq

According to the web, the problem is that the forcedeth driver has a
too-low value for max_interrupt_work.  Grepping the kernel I see that
forcedeth has the second lowest value of all ethernet drivers (ie, 6). 
Most are in the 20-40 range.  So this patch increases this a bit, from 6
to 15 (at 15 forcedeth becomes the driver with third-lowest
max_interrupt_work value).

My test stand, which used to print out the above warnings repetitively
whenever it was under heavy net load, no longer does so.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcdeth-increase-max_interrupt_work drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcdeth-increase-max_interrupt_work
+++ a/drivers/net/forcedeth.c
@@ -818,7 +818,7 @@ struct fe_priv {
  * Maximum number of loops until we assume that a bit in the irq mask
  * is stuck. Overridable with module param.
  */
-static int max_interrupt_work = 5;
+static int max_interrupt_work = 15;
 
 /*
  * Optimization can be either throuput mode or cpu mode
_

Patches currently in -mm which might be from joe.korty@ccur.com are

x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
forcdeth-increase-max_interrupt_work.patch
message-queues-increase-range-limits.patch
message-queues-increase-range-limits-checkpatch-fixes.patch

