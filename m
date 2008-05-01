From: akpm@linux-foundation.org
Subject: - amiserial-prepare-for-locking-relaxation-in-caller.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:43 -0700
Message-ID: <200805010927.m419RhI6030442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYEAJ2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     amiserial: prepare for locking relaxation in caller
has been removed from the -mm tree.  Its filename was
     amiserial-prepare-for-locking-relaxation-in-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: amiserial: prepare for locking relaxation in caller
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Just wrap this one in a lock_kernel. As I understand it there is no M68K
SMP anyway.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/char/amiserial.c~amiserial-prepare-for-locking-relaxation-in-caller drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~amiserial-prepare-for-locking-relaxation-in-caller
+++ a/drivers/char/amiserial.c
@@ -1074,6 +1074,7 @@ static int get_serial_info(struct async_
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = state->type;
 	tmp.line = state->line;
 	tmp.port = state->port;
@@ -1084,6 +1085,7 @@ static int get_serial_info(struct async_
 	tmp.close_delay = state->close_delay;
 	tmp.closing_wait = state->closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
+	unlock_kernel();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1099,13 +1101,17 @@ static int set_serial_info(struct async_
 
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
+
+	lock_kernel();
 	state = info->state;
 	old_state = *state;
   
 	change_irq = new_serial.irq != state->irq;
 	change_port = (new_serial.port != state->port);
-	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size))
+	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size)) {
+	  unlock_kernel();
 	  return -EINVAL;
+	}
   
 	if (!serial_isroot()) {
 		if ((new_serial.baud_base != state->baud_base) ||
@@ -1122,8 +1128,10 @@ static int set_serial_info(struct async_
 		goto check_and_exit;
 	}
 
-	if (new_serial.baud_base < 9600)
+	if (new_serial.baud_base < 9600) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	/*
 	 * OK, past this point, all the error checking has been done.
@@ -1157,6 +1165,7 @@ check_and_exit:
 		}
 	} else
 		retval = startup(info);
+	unlock_kernel();
 	return retval;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

