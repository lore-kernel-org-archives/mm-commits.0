From: akpm@linux-foundation.org
Subject: - char-epcac-remove-unused-function.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:56:15 -0800
Message-ID: <200703052356.l25NuFx4005229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbXCEX4a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     char/epca.c: remove unused function
has been removed from the -mm tree.  Its filename was
     char-epcac-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: char/epca.c: remove unused function
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

"drivers/char/epca.c:2741: warning: 'get_termio' defined but not used"

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/char/epca.c~char-epcac-remove-unused-function drivers/char/epca.c
--- a/drivers/char/epca.c~char-epcac-remove-unused-function
+++ a/drivers/char/epca.c
@@ -209,7 +209,6 @@ static void digi_send_break(struct chann
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
 void epca_setup(char *, int *);
 
-static int get_termio(struct tty_struct *, struct termio __user *);
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
 static int init_PCI(void);
@@ -2362,15 +2361,6 @@ static int pc_ioctl(struct tty_struct *t
 
 	switch (cmd) 
 	{ /* Begin switch cmd */
-
-#if 0	/* Handled by calling layer properly */
-		case TCGETS:
-			if (copy_to_user(argp, tty->termios, sizeof(struct ktermios)))
-				return -EFAULT;
-			return 0;
-		case TCGETA:
-			return get_termio(tty, argp);
-#endif
 		case TCSBRK:	/* SVID version: non-zero arg --> no break */
 			retval = tty_check_change(tty);
 			if (retval)
@@ -2735,13 +2725,6 @@ static void setup_empty_event(struct tty
 	memoff(ch);
 } /* End setup_empty_event */
 
-/* --------------------- Begin get_termio ----------------------- */
-
-static int get_termio(struct tty_struct * tty, struct termio __user * termio)
-{ /* Begin get_termio */
-	return kernel_termios_to_user_termio(termio, tty->termios);
-} /* End get_termio */
-
 /* ---------------------- Begin epca_setup  -------------------------- */
 void epca_setup(char *str, int *ints)
 { /* Begin epca_setup */
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
