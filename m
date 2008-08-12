From: akpm@linux-foundation.org
Subject: - m68k-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:34:17 -0700
Message-ID: <200808122034.m7CKYHdO011939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYHLUfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     m68k-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change m68k to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.

It also remove local bcd2bin/bin2bcd implementations
in favor of the global ones.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/time.c      |   35 +++++++++++++++++-----------------
 arch/m68k/bvme6000/config.c |   15 --------------
 arch/m68k/bvme6000/rtc.c    |   30 ++++++++++++++---------------
 arch/m68k/mvme16x/rtc.c     |   26 ++++++++++++-------------
 arch/m68k/q40/config.c      |   12 -----------
 arch/m68k/sun3x/time.c      |   28 +++++++++++++--------------
 6 files changed, 62 insertions(+), 84 deletions(-)

diff -puN arch/m68k/atari/time.c~m68k-use-bcd2bin-bin2bcd arch/m68k/atari/time.c
--- a/arch/m68k/atari/time.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/atari/time.c
@@ -191,13 +191,14 @@ int atari_tt_hwclk( int op, struct rtc_t
         }
 
         if (!(ctrl & RTC_DM_BINARY)) {
-            BIN_TO_BCD(sec);
-            BIN_TO_BCD(min);
-            BIN_TO_BCD(hour);
-            BIN_TO_BCD(day);
-            BIN_TO_BCD(mon);
-            BIN_TO_BCD(year);
-            if (wday >= 0) BIN_TO_BCD(wday);
+            sec = bin2bcd(sec);
+            min = bin2bcd(min);
+            hour = bin2bcd(hour);
+            day = bin2bcd(day);
+            mon = bin2bcd(mon);
+            year = bin2bcd(year);
+            if (wday >= 0)
+	        wday = bin2bcd(wday);
         }
     }
 
@@ -252,13 +253,13 @@ int atari_tt_hwclk( int op, struct rtc_t
 	}
 
 	if (!(ctrl & RTC_DM_BINARY)) {
-            BCD_TO_BIN(sec);
-            BCD_TO_BIN(min);
-            BCD_TO_BIN(hour);
-            BCD_TO_BIN(day);
-            BCD_TO_BIN(mon);
-            BCD_TO_BIN(year);
-            BCD_TO_BIN(wday);
+            sec = bcd2bin(sec);
+            min = bcd2bin(min);
+            hour = bcd2bin(hour);
+            day = bcd2bin(day);
+            mon = bcd2bin(mon);
+            year = bcd2bin(year);
+            wday = bcd2bin(wday);
         }
 
         if (!(ctrl & RTC_24H)) {
@@ -318,7 +319,7 @@ int atari_tt_set_clock_mmss (unsigned lo
 
     rtc_minutes = RTC_READ (RTC_MINUTES);
     if (!(save_control & RTC_DM_BINARY))
-        BCD_TO_BIN (rtc_minutes);
+        rtc_minutes = bcd2bin(rtc_minutes);
 
     /* Since we're only adjusting minutes and seconds, don't interfere
        with hour overflow.  This avoids messing with unknown time zones
@@ -329,8 +330,8 @@ int atari_tt_set_clock_mmss (unsigned lo
         {
             if (!(save_control & RTC_DM_BINARY))
                 {
-                    BIN_TO_BCD (real_seconds);
-                    BIN_TO_BCD (real_minutes);
+                    real_seconds = bin2bcd(real_seconds);
+                    real_minutes = bin2bcd(real_minutes);
                 }
             RTC_WRITE (RTC_SECONDS, real_seconds);
             RTC_WRITE (RTC_MINUTES, real_minutes);
diff -puN arch/m68k/bvme6000/config.c~m68k-use-bcd2bin-bin2bcd arch/m68k/bvme6000/config.c
--- a/arch/m68k/bvme6000/config.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/bvme6000/config.c
@@ -25,6 +25,7 @@
 #include <linux/genhd.h>
 #include <linux/rtc.h>
 #include <linux/interrupt.h>
+#include <linux/bcd.h>
 
 #include <asm/bootinfo.h>
 #include <asm/system.h>
@@ -46,9 +47,6 @@ extern void bvme6000_reset (void);
 extern void bvme6000_waitbut(void);
 void bvme6000_set_vectors (void);
 
-static unsigned char bcd2bin (unsigned char b);
-static unsigned char bin2bcd (unsigned char b);
-
 /* Save tick handler routine pointer, will point to do_timer() in
  * kernel/sched.c, called via bvme6000_process_int() */
 
@@ -264,17 +262,6 @@ unsigned long bvme6000_gettimeoffset (vo
     return v;
 }
 
-static unsigned char bcd2bin (unsigned char b)
-{
-	return ((b>>4)*10 + (b&15));
-}
-
-static unsigned char bin2bcd (unsigned char b)
-{
-	return (((b/10)*16) + (b%10));
-}
-
-
 /*
  * Looks like op is non-zero for setting the clock, and zero for
  * reading the clock.
diff -puN arch/m68k/bvme6000/rtc.c~m68k-use-bcd2bin-bin2bcd arch/m68k/bvme6000/rtc.c
--- a/arch/m68k/bvme6000/rtc.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/bvme6000/rtc.c
@@ -56,16 +56,16 @@ static int rtc_ioctl(struct inode *inode
 		rtc->msr = 0x40;
 		memset(&wtime, 0, sizeof(struct rtc_time));
 		do {
-			wtime.tm_sec =  BCD2BIN(rtc->bcd_sec);
-			wtime.tm_min =  BCD2BIN(rtc->bcd_min);
-			wtime.tm_hour = BCD2BIN(rtc->bcd_hr);
-			wtime.tm_mday =  BCD2BIN(rtc->bcd_dom);
-			wtime.tm_mon =  BCD2BIN(rtc->bcd_mth)-1;
-			wtime.tm_year = BCD2BIN(rtc->bcd_year);
+			wtime.tm_sec =  bcd2bin(rtc->bcd_sec);
+			wtime.tm_min =  bcd2bin(rtc->bcd_min);
+			wtime.tm_hour = bcd2bin(rtc->bcd_hr);
+			wtime.tm_mday =  bcd2bin(rtc->bcd_dom);
+			wtime.tm_mon =  bcd2bin(rtc->bcd_mth)-1;
+			wtime.tm_year = bcd2bin(rtc->bcd_year);
 			if (wtime.tm_year < 70)
 				wtime.tm_year += 100;
-			wtime.tm_wday = BCD2BIN(rtc->bcd_dow)-1;
-		} while (wtime.tm_sec != BCD2BIN(rtc->bcd_sec));
+			wtime.tm_wday = bcd2bin(rtc->bcd_dow)-1;
+		} while (wtime.tm_sec != bcd2bin(rtc->bcd_sec));
 		rtc->msr = msr;
 		local_irq_restore(flags);
 		return copy_to_user(argp, &wtime, sizeof wtime) ?
@@ -113,14 +113,14 @@ static int rtc_ioctl(struct inode *inode
 
 		rtc->t0cr_rtmr = yrs%4;
 		rtc->bcd_tenms = 0;
-		rtc->bcd_sec   = BIN2BCD(sec);
-		rtc->bcd_min   = BIN2BCD(min);
-		rtc->bcd_hr    = BIN2BCD(hrs);
-		rtc->bcd_dom   = BIN2BCD(day);
-		rtc->bcd_mth   = BIN2BCD(mon);
-		rtc->bcd_year  = BIN2BCD(yrs%100);
+		rtc->bcd_sec   = bin2bcd(sec);
+		rtc->bcd_min   = bin2bcd(min);
+		rtc->bcd_hr    = bin2bcd(hrs);
+		rtc->bcd_dom   = bin2bcd(day);
+		rtc->bcd_mth   = bin2bcd(mon);
+		rtc->bcd_year  = bin2bcd(yrs%100);
 		if (rtc_tm.tm_wday >= 0)
-			rtc->bcd_dow = BIN2BCD(rtc_tm.tm_wday+1);
+			rtc->bcd_dow = bin2bcd(rtc_tm.tm_wday+1);
 		rtc->t0cr_rtmr = yrs%4 | 0x08;
 
 		rtc->msr = msr;
diff -puN arch/m68k/mvme16x/rtc.c~m68k-use-bcd2bin-bin2bcd arch/m68k/mvme16x/rtc.c
--- a/arch/m68k/mvme16x/rtc.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/mvme16x/rtc.c
@@ -52,15 +52,15 @@ static int rtc_ioctl(struct inode *inode
 		/* Ensure clock and real-time-mode-register are accessible */
 		rtc->ctrl = RTC_READ;
 		memset(&wtime, 0, sizeof(struct rtc_time));
-		wtime.tm_sec =  BCD2BIN(rtc->bcd_sec);
-		wtime.tm_min =  BCD2BIN(rtc->bcd_min);
-		wtime.tm_hour = BCD2BIN(rtc->bcd_hr);
-		wtime.tm_mday =  BCD2BIN(rtc->bcd_dom);
-		wtime.tm_mon =  BCD2BIN(rtc->bcd_mth)-1;
-		wtime.tm_year = BCD2BIN(rtc->bcd_year);
+		wtime.tm_sec =  bcd2bin(rtc->bcd_sec);
+		wtime.tm_min =  bcd2bin(rtc->bcd_min);
+		wtime.tm_hour = bcd2bin(rtc->bcd_hr);
+		wtime.tm_mday =  bcd2bin(rtc->bcd_dom);
+		wtime.tm_mon =  bcd2bin(rtc->bcd_mth)-1;
+		wtime.tm_year = bcd2bin(rtc->bcd_year);
 		if (wtime.tm_year < 70)
 			wtime.tm_year += 100;
-		wtime.tm_wday = BCD2BIN(rtc->bcd_dow)-1;
+		wtime.tm_wday = bcd2bin(rtc->bcd_dow)-1;
 		rtc->ctrl = 0;
 		local_irq_restore(flags);
 		return copy_to_user(argp, &wtime, sizeof wtime) ?
@@ -104,12 +104,12 @@ static int rtc_ioctl(struct inode *inode
 		local_irq_save(flags);
 		rtc->ctrl     = RTC_WRITE;
 
-		rtc->bcd_sec  = BIN2BCD(sec);
-		rtc->bcd_min  = BIN2BCD(min);
-		rtc->bcd_hr   = BIN2BCD(hrs);
-		rtc->bcd_dom  = BIN2BCD(day);
-		rtc->bcd_mth  = BIN2BCD(mon);
-		rtc->bcd_year = BIN2BCD(yrs%100);
+		rtc->bcd_sec  = bin2bcd(sec);
+		rtc->bcd_min  = bin2bcd(min);
+		rtc->bcd_hr   = bin2bcd(hrs);
+		rtc->bcd_dom  = bin2bcd(day);
+		rtc->bcd_mth  = bin2bcd(mon);
+		rtc->bcd_year = bin2bcd(yrs%100);
 
 		rtc->ctrl     = 0;
 		local_irq_restore(flags);
diff -puN arch/m68k/q40/config.c~m68k-use-bcd2bin-bin2bcd arch/m68k/q40/config.c
--- a/arch/m68k/q40/config.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/q40/config.c
@@ -23,6 +23,7 @@
 #include <linux/serial_reg.h>
 #include <linux/rtc.h>
 #include <linux/vt_kern.h>
+#include <linux/bcd.h>
 
 #include <asm/io.h>
 #include <asm/rtc.h>
@@ -216,17 +217,6 @@ int q40_parse_bootinfo(const struct bi_r
 }
 
 
-static inline unsigned char bcd2bin(unsigned char b)
-{
-	return (b >> 4) * 10 + (b & 15);
-}
-
-static inline unsigned char bin2bcd(unsigned char b)
-{
-	return (b / 10) * 16 + (b % 10);
-}
-
-
 static unsigned long q40_gettimeoffset(void)
 {
 	return 5000 * (ql_ticks != 0);
diff -puN arch/m68k/sun3x/time.c~m68k-use-bcd2bin-bin2bcd arch/m68k/sun3x/time.c
--- a/arch/m68k/sun3x/time.c~m68k-use-bcd2bin-bin2bcd
+++ a/arch/m68k/sun3x/time.c
@@ -47,23 +47,23 @@ int sun3x_hwclk(int set, struct rtc_time
 
 	if(set) {
 		h->csr |= C_WRITE;
-		h->sec = BIN2BCD(t->tm_sec);
-		h->min = BIN2BCD(t->tm_min);
-		h->hour = BIN2BCD(t->tm_hour);
-		h->wday = BIN2BCD(t->tm_wday);
-		h->mday = BIN2BCD(t->tm_mday);
-		h->month = BIN2BCD(t->tm_mon);
-		h->year = BIN2BCD(t->tm_year);
+		h->sec = bin2bcd(t->tm_sec);
+		h->min = bin2bcd(t->tm_min);
+		h->hour = bin2bcd(t->tm_hour);
+		h->wday = bin2bcd(t->tm_wday);
+		h->mday = bin2bcd(t->tm_mday);
+		h->month = bin2bcd(t->tm_mon);
+		h->year = bin2bcd(t->tm_year);
 		h->csr &= ~C_WRITE;
 	} else {
 		h->csr |= C_READ;
-		t->tm_sec = BCD2BIN(h->sec);
-		t->tm_min = BCD2BIN(h->min);
-		t->tm_hour = BCD2BIN(h->hour);
-		t->tm_wday = BCD2BIN(h->wday);
-		t->tm_mday = BCD2BIN(h->mday);
-		t->tm_mon = BCD2BIN(h->month);
-		t->tm_year = BCD2BIN(h->year);
+		t->tm_sec = bcd2bin(h->sec);
+		t->tm_min = bcd2bin(h->min);
+		t->tm_hour = bcd2bin(h->hour);
+		t->tm_wday = bcd2bin(h->wday);
+		t->tm_mday = bcd2bin(h->mday);
+		t->tm_mon = bcd2bin(h->month);
+		t->tm_year = bcd2bin(h->year);
 		h->csr &= ~C_READ;
 	}
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
ipc-semc-make-free_un-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

