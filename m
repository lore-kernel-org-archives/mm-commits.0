From: akpm@linux-foundation.org
Subject: + tty-expose-new-methods-needed-for-drivers-to-get-termios.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:01:51 -0700
Message-ID: <200709210701.l8L71p7W023650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbXIUHCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: expose new methods needed for drivers to get termios right
has been added to the -mm tree.  Its filename is
     tty-expose-new-methods-needed-for-drivers-to-get-termios.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: expose new methods needed for drivers to get termios right
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This adds three new functions (or in one case to be more exact makes it
always available)

tty_termios_copy_hw

Copies all the hardware settings from one termios structure to the other. 
This is intended for drivers that support little or no hardware setting

tty_termios_encode_baud_rate

Allows you to set the input and output baud rate in a termios structure.  A
driver is supposed to set the resulting baud rate from a request so most
will want to use this function to set the resulting input and output rates
to match the hardware values.  Internally it knows about keeping Bxxx
encoding when possible to maximise compatibility.

tty_encode_baud_rate

As above but for the tty's own current termios structure

I suspect this will initially need some tweaking as it gets enabled by
driver patches over the next few mm cycles so consider this lot -mm only
for the moment so it can stabilize and end up neat before it goes to base.

I've tried not to break any obscure architectures - if you get a speed you
can't represent the code will print warnings on non updated termios systems
but not break.

Once this is merged and seems sane I've got a growing pile of driver
updates to use it - notably for USB serial drivers.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   81 ++++++++++++++++++++++++++++++++-----
 include/linux/tty.h      |    3 +
 2 files changed, 75 insertions(+), 9 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-expose-new-methods-needed-for-drivers-to-get-termios drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-expose-new-methods-needed-for-drivers-to-get-termios
+++ a/drivers/char/tty_ioctl.c
@@ -206,8 +206,6 @@ speed_t tty_termios_input_baud_rate(stru
 
 EXPORT_SYMBOL(tty_termios_input_baud_rate);
 
-#ifdef BOTHER
-
 /**
  *	tty_termios_encode_baud_rate
  *	@termios: ktermios structure holding user requested state
@@ -225,6 +223,9 @@ EXPORT_SYMBOL(tty_termios_input_baud_rat
  *
  *	Locking: Caller should hold termios lock. This is already held
  *	when calling this function from the driver termios handler.
+ *
+ *	The ifdefs deal with platforms whose owners have yet to update them
+ *	and will all go away once this is done.
  */
 
 void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
@@ -234,9 +235,13 @@ void tty_termios_encode_baud_rate(struct
 	int iclose = ibaud/50, oclose = obaud/50;
 	int ibinput = 0;
 
+	if (obaud == 0)			/* CD dropped 		  */
+		ibaud = 0;		/* Clear ibaud to be sure */
+
 	termios->c_ispeed = ibaud;
 	termios->c_ospeed = obaud;
 
+#ifdef BOTHER
 	/* If the user asked for a precise weird speed give a precise weird
 	   answer. If they asked for a Bfoo speed they many have problems
 	   digesting non-exact replies so fuzz a bit */
@@ -247,32 +252,61 @@ void tty_termios_encode_baud_rate(struct
 		iclose = 0;
 	if ((termios->c_cflag >> IBSHIFT) & CBAUD)
 		ibinput = 1;	/* An input speed was specified */
-
+#endif
 	termios->c_cflag &= ~CBAUD;
 
+	/*
+	 *	Our goal is to find a close match to the standard baud rate
+	 *	returned. Walk the baud rate table and if we get a very close
+	 *	match then report back the speed as a POSIX Bxxxx value by
+	 *	preference
+	 */
+
 	do {
 		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
 			termios->c_cflag |= baud_bits[i];
 			ofound = i;
 		}
 		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
-			/* For the case input == output don't set IBAUD bits if the user didn't do so */
-			if (ofound != i || ibinput)
+			if (ofound == i && !ibinput)
+				ifound  = i;
+#ifdef IBSHIFT
+			else {
+				ifound = i;
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
-			ifound = i;
+			}
+#endif
 		}
 	} while (++i < n_baud_table);
+
+	/*
+	 *	If we found no match then use BOTHER if provided or warn
+	 *	the user their platform maintainer needs to wake up if not.
+	 */
+#ifdef BOTHER
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
 	/* Set exact input bits only if the input and output differ or the
 	   user already did */
 	if (ifound == -1 && (ibaud != obaud || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
+#else
+	if (ifound == -1 || ofound == -1) {
+		static int warned = 0;
+		if (!warned++)
+			printk(KERN_WARNING "tty: Unable to return correct speed data as your architecture needs updating.\n");
+	}
+#endif
 }
 
 EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
 
-#endif
+void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud)
+{
+	tty_termios_encode_baud_rate(tty->termios, ibaud, obaud);
+}
+
+EXPORT_SYMBOL_GPL(tty_encode_baud_rate);
 
 /**
  *	tty_get_baud_rate	-	get tty bit rates
@@ -304,6 +338,29 @@ speed_t tty_get_baud_rate(struct tty_str
 EXPORT_SYMBOL(tty_get_baud_rate);
 
 /**
+ *	tty_termios_copy_hw	-	copy hardware settings
+ *	@new: New termios
+ *	@old: Old termios
+ *
+ *	Propogate the hardware specific terminal setting bits from
+ *	the old termios structure to the new one. This is used in cases
+ *	where the hardware does not support reconfiguration or as a helper
+ *	in some cases where only minimal reconfiguration is supported
+ */
+
+void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old)
+{
+	/* The bits a dumb device handles in software. Smart devices need
+	   to always provide a set_termios method */
+	new->c_cflag &= HUPCL | CREAD | CLOCAL;
+	new->c_cflag |= old->c_cflag & ~(HUPCL | CREAD | CLOCAL);
+	new->c_ispeed = old->c_ispeed;
+	new->c_ospeed = old->c_ospeed;
+}
+
+EXPORT_SYMBOL(tty_termios_copy_hw);
+
+/**
  *	change_termios		-	update termios values
  *	@tty: tty to update
  *	@new_termios: desired new value
@@ -340,13 +397,12 @@ static void change_termios(struct tty_st
 		tty->erasing = 0;
 	}
 	
-	
+	/* This bit should be in the ldisc code */
 	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
 		/* Get characters left over from canonical mode. */
 		wake_up_interruptible(&tty->read_wait);
 
 	/* See if packet mode change of state. */
-
 	if (tty->link && tty->link->packet) {
 		int old_flow = ((old_termios.c_iflag & IXON) &&
 				(old_termios.c_cc[VSTOP] == '\023') &&
@@ -366,6 +422,8 @@ static void change_termios(struct tty_st
 	   
 	if (tty->driver->set_termios)
 		(*tty->driver->set_termios)(tty, &old_termios);
+	else
+		tty_termios_copy_hw(tty->termios, &old_termios);
 
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
@@ -440,6 +498,11 @@ static int set_termios(struct tty_struct
 	}
 
 	change_termios(tty, &tmp_termios);
+
+	/* FIXME: Arguably if tmp_termios == tty->termios AND the
+	   actual requested termios was not tmp_termios then we may
+	   want to return an error as no user requested change has
+	   succeeded */
 	return 0;
 }
 
diff -puN include/linux/tty.h~tty-expose-new-methods-needed-for-drivers-to-get-termios include/linux/tty.h
--- a/include/linux/tty.h~tty-expose-new-methods-needed-for-drivers-to-get-termios
+++ a/include/linux/tty.h
@@ -316,6 +316,9 @@ extern void tty_flip_buffer_push(struct 
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
+extern void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud);
+extern void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud);
+extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

dtc-fix-typo.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-update-experimental-tags-to-reflect-reality-better.patch
libata-sff-fix-documentation.patch
st340823a-hpa-and-libata.patch
libata-update-the-blacklist-with-a-few-more-devices.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
