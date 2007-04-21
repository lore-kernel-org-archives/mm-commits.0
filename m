From: akpm@linux-foundation.org
Subject: + drivers-char-use-__set_current_state.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:34:41 -0700
Message-ID: <200704210034.l3L0Yfsn027468@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbXDUAeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, jirislaby@gmail.com


The patch titled
     drivers/char: use __set_current_state()
has been added to the -mm tree.  Its filename is
     drivers-char-use-__set_current_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char: use __set_current_state()
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

use __set_current_state(TASK_*) instead of current->state = TASK_*,

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    4 ++--
 drivers/char/cyclades.c  |    4 ++--
 drivers/char/epca.c      |    2 +-
 drivers/char/genrtc.c    |    2 +-
 drivers/char/n_r3964.c   |    4 ++--
 drivers/char/riscom8.c   |    2 +-
 drivers/char/rocket.c    |    4 ++--
 drivers/char/rtc.c       |    2 +-
 drivers/char/selection.c |    2 +-
 drivers/char/serial167.c |    2 +-
 drivers/char/vt_ioctl.c  |    2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/char/amiserial.c~drivers-char-use-__set_current_state drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-use-__set_current_state
+++ a/drivers/char/amiserial.c
@@ -1574,7 +1574,7 @@ static void rs_wait_until_sent(struct tt
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
@@ -1700,7 +1700,7 @@ static int block_til_ready(struct tty_st
 #endif
 		schedule();
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (extra_count)
 		state->count++;
diff -puN drivers/char/cyclades.c~drivers-char-use-__set_current_state drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~drivers-char-use-__set_current_state
+++ a/drivers/char/cyclades.c
@@ -2445,7 +2445,7 @@ block_til_ready(struct tty_struct *tty, 
 		base_addr = cinfo->base_addr;
 		firm_id = base_addr + ID_ADDRESS;
 		if (!ISZLOADED(*cinfo)) {
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&info->open_wait, &wait);
 			return -EINVAL;
 		}
@@ -2498,7 +2498,7 @@ block_til_ready(struct tty_struct *tty, 
 			schedule();
 		}
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
 		info->count++;
diff -puN drivers/char/epca.c~drivers-char-use-__set_current_state drivers/char/epca.c
--- a/drivers/char/epca.c~drivers-char-use-__set_current_state
+++ a/drivers/char/epca.c
@@ -949,7 +949,7 @@ static int block_til_ready(struct tty_st
 
 	} /* End forever while  */
 
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&ch->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		ch->count++;
diff -puN drivers/char/genrtc.c~drivers-char-use-__set_current_state drivers/char/genrtc.c
--- a/drivers/char/genrtc.c~drivers-char-use-__set_current_state
+++ a/drivers/char/genrtc.c
@@ -207,7 +207,7 @@ static ssize_t gen_rtc_read(struct file 
 			sizeof(unsigned long);
 	}
  out:
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&gen_rtc_wait, &wait);
 
 	return retval;
diff -puN drivers/char/n_r3964.c~drivers-char-use-__set_current_state drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~drivers-char-use-__set_current_state
+++ a/drivers/char/n_r3964.c
@@ -1088,13 +1088,13 @@ static ssize_t r3964_read(struct tty_str
 			/* block until there is a message: */
 			add_wait_queue(&pInfo->read_wait, &wait);
 repeat:
-			current->state = TASK_INTERRUPTIBLE;
+			__set_current_state(TASK_INTERRUPTIBLE);
 			pMsg = remove_msg(pInfo, pClient);
 			if (!pMsg && !signal_pending(current)) {
 				schedule();
 				goto repeat;
 			}
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&pInfo->read_wait, &wait);
 		}
 
diff -puN drivers/char/riscom8.c~drivers-char-use-__set_current_state drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~drivers-char-use-__set_current_state
+++ a/drivers/char/riscom8.c
@@ -980,7 +980,7 @@ static int block_til_ready(struct tty_st
 		}
 		schedule();
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		port->count++;
diff -puN drivers/char/rocket.c~drivers-char-use-__set_current_state drivers/char/rocket.c
--- a/drivers/char/rocket.c~drivers-char-use-__set_current_state
+++ a/drivers/char/rocket.c
@@ -943,7 +943,7 @@ static int block_til_ready(struct tty_st
 #endif
 		schedule();	/*  Don't hold spinlock here, will hang PC */
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1598,7 +1598,7 @@ static void rp_wait_until_sent(struct tt
 		if (signal_pending(current))
 			break;
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
diff -puN drivers/char/rtc.c~drivers-char-use-__set_current_state drivers/char/rtc.c
--- a/drivers/char/rtc.c~drivers-char-use-__set_current_state
+++ a/drivers/char/rtc.c
@@ -388,7 +388,7 @@ static ssize_t rtc_read(struct file *fil
 	if (!retval)
 		retval = count;
  out:
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&rtc_wait, &wait);
 
 	return retval;
diff -puN drivers/char/selection.c~drivers-char-use-__set_current_state drivers/char/selection.c
--- a/drivers/char/selection.c~drivers-char-use-__set_current_state
+++ a/drivers/char/selection.c
@@ -299,7 +299,7 @@ int paste_selection(struct tty_struct *t
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 
 	tty_ldisc_deref(ld);
 	return 0;
diff -puN drivers/char/serial167.c~drivers-char-use-__set_current_state drivers/char/serial167.c
--- a/drivers/char/serial167.c~drivers-char-use-__set_current_state
+++ a/drivers/char/serial167.c
@@ -1892,7 +1892,7 @@ block_til_ready(struct tty_struct *tty, 
 #endif
 		    schedule();
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
 		info->count++;
diff -puN drivers/char/vt_ioctl.c~drivers-char-use-__set_current_state drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~drivers-char-use-__set_current_state
+++ a/drivers/char/vt_ioctl.c
@@ -1061,7 +1061,7 @@ int vt_waitactive(int vt)
 		schedule();
 	}
 	remove_wait_queue(&vt_activate_queue, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	return retval;
 }
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
jfs-use-set_current_state.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
spin_lock_unlocked-cleanup-in-arch-mips.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
nfs-use-__set_current_state.patch
ocfs2-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
spin_lock_unlocked-cleanup-in-drivers-s390.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch
