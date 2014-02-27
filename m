From: akpm@linux-foundation.org
Subject: + parport-fix-interruptible_sleep_on-race.patch added to -mm tree
Date: Wed, 26 Feb 2014 16:26:34 -0800
Message-ID: <530e863a.gj3qqxIkK/F7Nosm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaB0A0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 19:26:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de

Subject: + parport-fix-interruptible_sleep_on-race.patch added to -mm tree
To: arnd@arndb.de,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 16:26:34 -0800


The patch titled
     Subject: parport: fix interruptible_sleep_on() race
has been added to the -mm tree.  Its filename is
     parport-fix-interruptible_sleep_on-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parport-fix-interruptible_sleep_on-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parport-fix-interruptible_sleep_on-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: parport: fix interruptible_sleep_on() race

interruptible_sleep_on() can still lead to the deadlock mentioned in the
comment above the caller, and we want to remove it soon, so replace it now
with the race-free wait_event_interruptible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/share.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/parport/share.c~parport-fix-interruptible_sleep_on-race drivers/parport/share.c
--- a/drivers/parport/share.c~parport-fix-interruptible_sleep_on-race
+++ a/drivers/parport/share.c
@@ -905,7 +905,8 @@ int parport_claim_or_block(struct pardev
 		/* If dev->waiting is clear now, an interrupt
 		   gave us the port and we would deadlock if we slept.  */
 		if (dev->waiting) {
-			interruptible_sleep_on (&dev->wait_q);
+			wait_event_interruptible(dev->wait_q,
+						 !dev->waiting);
 			if (signal_pending (current)) {
 				return -EINTR;
 			}
_

Patches currently in -mm which might be from arnd@arndb.de are

kconfig-rename-has_ioport-to-has_ioport_map.patch
parport-fix-interruptible_sleep_on-race.patch
linux-next.patch
asm-systemh-clean-asm-systemh-from-docs.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

