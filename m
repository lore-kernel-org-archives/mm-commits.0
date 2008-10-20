From: akpm@linux-foundation.org
Subject: - rtc-cmos-export-second-nvram-bank.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:32 -0700
Message-ID: <200810202035.m9KKZWMB011168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbYJTUg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, bjorn.helgaas@hp.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: export second NVRAM bank
has been removed from the -mm tree.  Its filename was
     rtc-cmos-export-second-nvram-bank.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: export second NVRAM bank
From: David Brownell <dbrownell@users.sourceforge.net>

Teach rtc-cmos about the second bank of registers found on most modern x86
systems, giving access to 128 bytes more NVRAM.

This version only sees that extra NVRAM when both register banks are
provided as part of *one* PNP resource.  Since BIOS on some systems
presents them using two IO resources, and nothing merges them, this can't
always show all the NVRAM.  (We're supposed to be able to use PNP id
PNP0b01 too, but BIOS tables doesn't often seem to use that particular
option.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   70 +++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-export-second-nvram-bank drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-export-second-nvram-bank
+++ a/drivers/rtc/rtc-cmos.c
@@ -143,6 +143,43 @@ static inline int hpet_unregister_irq_ha
 
 /*----------------------------------------------------------------*/
 
+#ifdef RTC_PORT
+
+/* Most newer x86 systems have two register banks, the first used
+ * for RTC and NVRAM and the second only for NVRAM.  Caller must
+ * own rtc_lock ... and we won't worry about access during NMI.
+ */
+#define can_bank2	true
+
+static inline unsigned char cmos_read_bank2(unsigned char addr)
+{
+	outb(addr, RTC_PORT(2));
+	return inb(RTC_PORT(3));
+}
+
+static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
+{
+	outb(addr, RTC_PORT(2));
+	outb(val, RTC_PORT(2));
+}
+
+#else
+
+#define can_bank2	false
+
+static inline unsigned char cmos_read_bank2(unsigned char addr)
+{
+	return 0;
+}
+
+static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
+{
+}
+
+#endif
+
+/*----------------------------------------------------------------*/
+
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
 	/* REVISIT:  if the clock has a "century" register, use
@@ -491,12 +528,21 @@ cmos_nvram_read(struct kobject *kobj, st
 
 	if (unlikely(off >= attr->size))
 		return 0;
+	if (unlikely(off < 0))
+		return -EINVAL;
 	if ((off + count) > attr->size)
 		count = attr->size - off;
 
+	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++)
-		*buf++ = CMOS_READ(off);
+	for (retval = 0; count; count--, off++, retval++) {
+		if (off < 128)
+			*buf++ = CMOS_READ(off);
+		else if (can_bank2)
+			*buf++ = cmos_read_bank2(off);
+		else
+			break;
+	}
 	spin_unlock_irq(&rtc_lock);
 
 	return retval;
@@ -512,6 +558,8 @@ cmos_nvram_write(struct kobject *kobj, s
 	cmos = dev_get_drvdata(container_of(kobj, struct device, kobj));
 	if (unlikely(off >= attr->size))
 		return -EFBIG;
+	if (unlikely(off < 0))
+		return -EINVAL;
 	if ((off + count) > attr->size)
 		count = attr->size - off;
 
@@ -520,15 +568,20 @@ cmos_nvram_write(struct kobject *kobj, s
 	 * here.  If userspace is smart enough to know what fields of
 	 * NVRAM to update, updating checksums is also part of its job.
 	 */
+	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++) {
+	for (retval = 0; count; count--, off++, retval++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
 				|| off == cmos->mon_alrm
 				|| off == cmos->century)
 			buf++;
-		else
+		else if (off < 128)
 			CMOS_WRITE(*buf++, off);
+		else if (can_bank2)
+			cmos_write_bank2(*buf++, off);
+		else
+			break;
 	}
 	spin_unlock_irq(&rtc_lock);
 
@@ -631,8 +684,8 @@ cmos_do_probe(struct device *dev, struct
 
 	/* Heuristic to deduce NVRAM size ... do what the legacy NVRAM
 	 * driver did, but don't reject unknown configs.   Old hardware
-	 * won't address 128 bytes, and for now we ignore the way newer
-	 * chips can address 256 bytes (using two more i/o ports).
+	 * won't address 128 bytes.  Newer chips have multiple banks,
+	 * though they may not be listed in one I/O resource.
 	 */
 #if	defined(CONFIG_ATARI)
 	address_space = 64;
@@ -642,6 +695,8 @@ cmos_do_probe(struct device *dev, struct
 #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.
 	address_space = 128;
 #endif
+	if (can_bank2 && ports->end > (ports->start + 1))
+		address_space = 256;
 
 	/* For ACPI systems extension info comes from the FADT.  On others,
 	 * board specific setup provides it as appropriate.  Systems where
@@ -740,7 +795,7 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s%s\n",
+	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
 			cmos_rtc.rtc->dev.bus_id,
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
@@ -749,6 +804,7 @@ cmos_do_probe(struct device *dev, struct
 						? "month" : "day"))
 				: "no",
 			cmos_rtc.century ? ", y3k" : "",
+			nvram.size,
 			is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch

