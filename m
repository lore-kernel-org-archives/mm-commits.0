From: akpm@osdl.org
Subject: - char-mxser_new-revert-spin_lock-changes.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:56 -0800
Message-ID: <200612082006.kB8K6uhq002449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946033AbWLHUHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, revert spin_lock changes
has been removed from the -mm tree.  Its filename was
     char-mxser_new-revert-spin_lock-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, revert spin_lock changes
From: Jiri Slaby <jirislaby@gmail.com>

Some spinlock changes were introduced in 1.9.1 original moxa driver.  Revert
them, since they cause machine not responding.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-revert-spin_lock-changes drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-revert-spin_lock-changes
+++ a/drivers/char/mxser_new.c
@@ -1687,22 +1687,12 @@ static void mxser_startrx(struct tty_str
  */
 static void mxser_throttle(struct tty_struct *tty)
 {
-	struct mxser_port *info = tty->driver_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&info->slock, flags);
 	mxser_stoprx(tty);
-	spin_unlock_irqrestore(&info->slock, flags);
 }
 
 static void mxser_unthrottle(struct tty_struct *tty)
 {
-	struct mxser_port *info = tty->driver_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&info->slock, flags);
 	mxser_startrx(tty);
-	spin_unlock_irqrestore(&info->slock, flags);
 }
 
 static void mxser_set_termios(struct tty_struct *tty, struct termios *old_termios)
@@ -1930,7 +1920,6 @@ static irqreturn_t mxser_interrupt(int i
 				}
 				/* above add by Victor Yu. 09-13-2002 */
 
-				spin_lock(&port->slock);
 				/* following add by Victor Yu. 09-02-2002 */
 				status = inb(port->ioaddr + UART_LSR);
 
@@ -1981,7 +1970,6 @@ static irqreturn_t mxser_interrupt(int i
 					if (status & UART_LSR_THRE)
 						mxser_transmit_chars(port);
 				}
-				spin_unlock(&port->slock);
 			} while (int_cnt++ < MXSER_ISR_PASS_LIMIT);
 		}
 		if (pass_counter++ > MXSER_ISR_PASS_LIMIT)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-revert-spin_lock-changes.patch
char-mxser_new-remove-request-for-testers-line.patch
char-mxser_new-debug-printk-dependent-on-debug.patch
char-mxser_new-alter-license-terms.patch
char-mxser_new-code-upside-down.patch
char-mxser_new-cmspar-is-defined.patch
char-remove-unneded-termbits-redefinitions-mxser_new.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
char-mxser_new-clean-macros.patch
maintainers-add-me-to-isicom-mxser.patch
mxser_new-correct-tty-driver-name.patch
mxser-workqueue-fixes.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

