From: akpm@linux-foundation.org
Subject: + ppp-synchronous-tty-convert-dead_sem-to-completion.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:43:18 -0800
Message-ID: <200712120543.lBC5hIqq028076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbXLLFnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:43:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, paulus@samba.org


The patch titled
     PPP synchronous tty: convert dead_sem to completion
has been added to the -mm tree.  Its filename is
     ppp-synchronous-tty-convert-dead_sem-to-completion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPP synchronous tty: convert dead_sem to completion
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

PPP synchronous tty channel driver: convert the semaphore dead_sem to a
completion

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_synctty.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/ppp_synctty.c~ppp-synchronous-tty-convert-dead_sem-to-completion drivers/net/ppp_synctty.c
--- a/drivers/net/ppp_synctty.c~ppp-synchronous-tty-convert-dead_sem-to-completion
+++ a/drivers/net/ppp_synctty.c
@@ -42,9 +42,9 @@
 #include <linux/if_ppp.h>
 #include <linux/ppp_channel.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #define PPP_VERSION	"2.4.2"
 
@@ -70,7 +70,7 @@ struct syncppp {
 	struct tasklet_struct tsk;
 
 	atomic_t	refcnt;
-	struct semaphore dead_sem;
+	struct completion dead_cmp;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 };
 
@@ -195,7 +195,7 @@ static struct syncppp *sp_get(struct tty
 static void sp_put(struct syncppp *ap)
 {
 	if (atomic_dec_and_test(&ap->refcnt))
-		up(&ap->dead_sem);
+		complete(&ap->dead_cmp);
 }
 
 /*
@@ -225,7 +225,7 @@ ppp_sync_open(struct tty_struct *tty)
 	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
 
 	atomic_set(&ap->refcnt, 1);
-	init_MUTEX_LOCKED(&ap->dead_sem);
+	init_completion(&ap->dead_cmp);
 
 	ap->chan.private = ap;
 	ap->chan.ops = &sync_ops;
@@ -273,7 +273,7 @@ ppp_sync_close(struct tty_struct *tty)
 	 * by the time it returns.
 	 */
 	if (!atomic_dec_and_test(&ap->refcnt))
-		down(&ap->dead_sem);
+		wait_for_completion(&ap->dead_cmp);
 	tasklet_kill(&ap->tsk);
 
 	ppp_unregister_channel(&ap->chan);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch
git-dvb.patch
git-infiniband.patch
ppp-synchronous-tty-convert-dead_sem-to-completion.patch
git-netdev-all.patch
plip-driver-convert-killed_timer_sem-to-completion.patch
git-scsi-misc.patch
edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
usb-testing-driver-convert-dev-sem-to-mutex.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
