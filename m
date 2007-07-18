From: akpm@linux-foundation.org
Subject: + isdn-sc-compile-breakage-re-check_reset.patch added to -mm tree
Date: Wed, 18 Jul 2007 13:13:48 -0700
Message-ID: <200707182013.l6IKDmkm026735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbXGRUPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 16:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, kkeil@suse.de


The patch titled
     isdn/sc: compile breakage re check_reset()
has been added to the -mm tree.  Its filename is
     isdn-sc-compile-breakage-re-check_reset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn/sc: compile breakage re check_reset()
From: Alexey Dobriyan <adobriyan@sw.ru>

There is check_reset() -- global function in drivers/isdn/sc/
There is check_reset -- variable holding module param in aacraid driver.

On allyesconfig they clash with:

  LD      drivers/built-in.o
drivers/isdn/built-in.o: In function `check_reset':
: multiple definition of `check_reset'
drivers/scsi/built-in.o:(.data+0xe458): first defined here
ld: Warning: size of symbol `check_reset' changed from 4 in drivers/scsi/built-in.o to 219 in drivers/isdn/built-in.o
ld: Warning: type of symbol `check_reset' changed from 1 to 2 in drivers/isdn/built-in.o

Rename the former.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/sc/card.h    |    2 +-
 drivers/isdn/sc/command.c |    2 +-
 drivers/isdn/sc/timer.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/sc/card.h~isdn-sc-compile-breakage-re-check_reset drivers/isdn/sc/card.h
--- a/drivers/isdn/sc/card.h~isdn-sc-compile-breakage-re-check_reset
+++ a/drivers/isdn/sc/card.h
@@ -125,7 +125,7 @@ int sendmessage(int card, unsigned int p
 int receivemessage(int card, RspMessage *rspmsg);
 int sc_ioctl(int card, scs_ioctl *data);
 int setup_buffers(int card, int c);
-void check_reset(unsigned long data);
+void sc_check_reset(unsigned long data);
 void check_phystat(unsigned long data);
 
 #endif /* CARD_H */
diff -puN drivers/isdn/sc/command.c~isdn-sc-compile-breakage-re-check_reset drivers/isdn/sc/command.c
--- a/drivers/isdn/sc/command.c~isdn-sc-compile-breakage-re-check_reset
+++ a/drivers/isdn/sc/command.c
@@ -344,7 +344,7 @@ int reset(int card)
 
 	spin_lock_irqsave(&sc_adapter[card]->lock, flags);
 	init_timer(&sc_adapter[card]->reset_timer);
-	sc_adapter[card]->reset_timer.function = check_reset;
+	sc_adapter[card]->reset_timer.function = sc_check_reset;
 	sc_adapter[card]->reset_timer.data = card;
 	sc_adapter[card]->reset_timer.expires = jiffies + CHECKRESET_TIME;
 	add_timer(&sc_adapter[card]->reset_timer);
diff -puN drivers/isdn/sc/timer.c~isdn-sc-compile-breakage-re-check_reset drivers/isdn/sc/timer.c
--- a/drivers/isdn/sc/timer.c~isdn-sc-compile-breakage-re-check_reset
+++ a/drivers/isdn/sc/timer.c
@@ -43,7 +43,7 @@ static void setup_ports(int card)
  * Then, check to see if the signate has been set. Next, set the
  * signature to a known value and issue a startproc if needed.
  */
-void check_reset(unsigned long data)
+void sc_check_reset(unsigned long data)
 {
 	unsigned long flags;
 	unsigned long sig;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
isdn-sc-compile-breakage-re-check_reset.patch
git-dvb.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
