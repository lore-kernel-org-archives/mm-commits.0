From: akpm@linux-foundation.org
Subject: + stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:32:56 -0700
Message-ID: <200807130532.m6D5WurL006081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYGMFdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     stallion: fix the (i)Stallion driver's putchar() and break_ctl() ops
has been added to the -mm tree.  Its filename is
     stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch

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
Subject: stallion: fix the (i)Stallion driver's putchar() and break_ctl() ops
From: David Howells <dhowells@redhat.com>

Fix the Stallion driver's putchar() and break_ctl() ops and iStallion's
putchar() to return values.

Is it actually possible for putchar() or break_ctl() to be called with tty
== NULL or can the check be discarded?

Should stl_write() be returning 0 if tty->driver_data is NULL or tx.buf is
NULL?  Is this even possible?

I've made Stallion's functions return -EINVAL as stli_breakctl() if the checks
fail.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    5 +++--
 drivers/char/stallion.c  |   16 +++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/istallion.c~stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops drivers/char/istallion.c
--- a/drivers/char/istallion.c~stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops
+++ a/drivers/char/istallion.c
@@ -598,7 +598,7 @@ static int	stli_parsebrd(struct stlconf 
 static int	stli_open(struct tty_struct *tty, struct file *filp);
 static void	stli_close(struct tty_struct *tty, struct file *filp);
 static int	stli_write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void	stli_putchar(struct tty_struct *tty, unsigned char ch);
+static int	stli_putchar(struct tty_struct *tty, unsigned char ch);
 static void	stli_flushchars(struct tty_struct *tty);
 static int	stli_writeroom(struct tty_struct *tty);
 static int	stli_charsinbuffer(struct tty_struct *tty);
@@ -1333,7 +1333,7 @@ static int stli_write(struct tty_struct 
  *	first them do the new ports.
  */
 
-static void stli_putchar(struct tty_struct *tty, unsigned char ch)
+static int stli_putchar(struct tty_struct *tty, unsigned char ch)
 {
 	if (tty != stli_txcooktty) {
 		if (stli_txcooktty != NULL)
@@ -1342,6 +1342,7 @@ static void stli_putchar(struct tty_stru
 	}
 
 	stli_txcookbuf[stli_txcooksize++] = ch;
+	return 0;
 }
 
 /*****************************************************************************/
diff -puN drivers/char/stallion.c~stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops drivers/char/stallion.c
--- a/drivers/char/stallion.c~stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops
+++ a/drivers/char/stallion.c
@@ -1025,7 +1025,7 @@ static int stl_write(struct tty_struct *
 
 /*****************************************************************************/
 
-static void stl_putchar(struct tty_struct *tty, unsigned char ch)
+static int stl_putchar(struct tty_struct *tty, unsigned char ch)
 {
 	struct stlport	*portp;
 	unsigned int	len;
@@ -1034,12 +1034,12 @@ static void stl_putchar(struct tty_struc
 	pr_debug("stl_putchar(tty=%p,ch=%x)\n", tty, ch);
 
 	if (tty == NULL)
-		return;
+		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
-		return;
+		return -EINVAL;
 	if (portp->tx.buf == NULL)
-		return;
+		return -EINVAL;
 
 	head = portp->tx.head;
 	tail = portp->tx.tail;
@@ -1053,6 +1053,7 @@ static void stl_putchar(struct tty_struc
 			head = portp->tx.buf;
 	}	
 	portp->tx.head = head;
+	return 0;
 }
 
 /*****************************************************************************/
@@ -1459,19 +1460,20 @@ static void stl_hangup(struct tty_struct
 
 /*****************************************************************************/
 
-static void stl_breakctl(struct tty_struct *tty, int state)
+static int stl_breakctl(struct tty_struct *tty, int state)
 {
 	struct stlport	*portp;
 
 	pr_debug("stl_breakctl(tty=%p,state=%d)\n", tty, state);
 
 	if (tty == NULL)
-		return;
+		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
-		return;
+		return -EINVAL;
 
 	stl_sendbreak(portp, ((state == -1) ? 1 : 2));
+	return 0;
 }
 
 /*****************************************************************************/
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-irqs_disabled-to-return-an-int-not-an-unsigned-long.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

