From: akpm@osdl.org
Subject: + some-rtc-documentation-updates.patch added to -mm tree
Date: Fri, 26 Jan 2007 11:50:11 -0800
Message-ID: <200701261950.l0QJoBk2024896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161234AbXAZTuW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 14:50:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it


The patch titled
     some rtc documentation updates
has been added to the -mm tree.  Its filename is
     some-rtc-documentation-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: some rtc documentation updates
From: Mike Frysinger <vapier@gentoo.org>

Fix typo when describing RTC_WKALM.  Add some helpful pointers to people
developing their own RTC driver.  Change a bunch of the error messages in the
test program to be a bit more helpful.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/rtc.txt |   46 +++++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff -puN Documentation/rtc.txt~some-rtc-documentation-updates Documentation/rtc.txt
--- a/Documentation/rtc.txt~some-rtc-documentation-updates
+++ a/Documentation/rtc.txt
@@ -149,7 +149,7 @@ RTC class framework, but can't be suppor
 	is connected to an IRQ line, it can often issue an alarm IRQ up to
 	24 hours in the future.
 
-    *	RTC_WKALM_SET, RTC_WKALM_READ ... RTCs that can issue alarms beyond
+    *	RTC_WKALM_SET, RTC_WKALM_RD ... RTCs that can issue alarms beyond
 	the next 24 hours use a slightly more powerful API, which supports
 	setting the longer alarm time and enabling its IRQ using a single
 	request (using the same model as EFI firmware).
@@ -167,6 +167,28 @@ Linux out of a low power sleep state (or
 operational state.  For example, a system could enter a deep power saving
 state until it's time to execute some scheduled tasks.
 
+Note that many of these ioctls need not actually be implemented by your
+driver.  The common rtc-dev interface handles many of these nicely if your
+driver returns ENOIOCTLCMD.  Some common examples:
+
+    *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time functions will be
+	called with appropriate values.
+
+    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: the
+	set_alarm/read_alarm functions will be called.  To differentiate
+	between the ALM and WKALM, check the larger fields of the rtc_wkalrm
+	struct (like tm_year).  These will be set to -1 when using ALM and
+	will be set to proper values when using WKALM.
+
+    *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
+	to set the frequency while the framework will handle the read for you
+	since the frequency is stored in the irq_freq member of the rtc_device
+	structure.  Also make sure you set the max_user_freq member in your
+	initialization routines so the framework can sanity check the user
+	input for you.
+
+If all else fails, check out the rtc-test.c driver!
+
 
 -------------------- 8< ---------------- 8< -----------------------------
 
@@ -237,7 +259,7 @@ int main(int argc, char **argv)
 				"\n...Update IRQs not supported.\n");
 			goto test_READ;
 		}
-		perror("ioctl");
+		perror("RTC_UIE_ON ioctl");
 		exit(errno);
 	}
 
@@ -284,7 +306,7 @@ int main(int argc, char **argv)
 	/* Turn off update interrupts */
 	retval = ioctl(fd, RTC_UIE_OFF, 0);
 	if (retval == -1) {
-		perror("ioctl");
+		perror("RTC_UIE_OFF ioctl");
 		exit(errno);
 	}
 
@@ -292,7 +314,7 @@ test_READ:
 	/* Read the RTC time/date */
 	retval = ioctl(fd, RTC_RD_TIME, &rtc_tm);
 	if (retval == -1) {
-		perror("ioctl");
+		perror("RTC_RD_TIME ioctl");
 		exit(errno);
 	}
 
@@ -320,14 +342,14 @@ test_READ:
 				"\n...Alarm IRQs not supported.\n");
 			goto test_PIE;
 		}
-		perror("ioctl");
+		perror("RTC_ALM_SET ioctl");
 		exit(errno);
 	}
 
 	/* Read the current alarm settings */
 	retval = ioctl(fd, RTC_ALM_READ, &rtc_tm);
 	if (retval == -1) {
-		perror("ioctl");
+		perror("RTC_ALM_READ ioctl");
 		exit(errno);
 	}
 
@@ -337,7 +359,7 @@ test_READ:
 	/* Enable alarm interrupts */
 	retval = ioctl(fd, RTC_AIE_ON, 0);
 	if (retval == -1) {
-		perror("ioctl");
+		perror("RTC_AIE_ON ioctl");
 		exit(errno);
 	}
 
@@ -355,7 +377,7 @@ test_READ:
 	/* Disable alarm interrupts */
 	retval = ioctl(fd, RTC_AIE_OFF, 0);
 	if (retval == -1) {
-		perror("ioctl");
+		perror("RTC_AIE_OFF ioctl");
 		exit(errno);
 	}
 
@@ -368,7 +390,7 @@ test_PIE:
 			fprintf(stderr, "\nNo periodic IRQ support\n");
 			return 0;
 		}
-		perror("ioctl");
+		perror("RTC_IRQP_READ ioctl");
 		exit(errno);
 	}
 	fprintf(stderr, "\nPeriodic IRQ rate is %ldHz.\n", tmp);
@@ -387,7 +409,7 @@ test_PIE:
 					"\n...Periodic IRQ rate is fixed\n");
 				goto done;
 			}
-		        perror("ioctl");
+		        perror("RTC_IRQP_SET ioctl");
 		        exit(errno);
 		}
 
@@ -397,7 +419,7 @@ test_PIE:
 		/* Enable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_ON, 0);
 		if (retval == -1) {
-		        perror("ioctl");
+		        perror("RTC_PIE_ON ioctl");
 		        exit(errno);
 		}
 
@@ -416,7 +438,7 @@ test_PIE:
 		/* Disable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_OFF, 0);
 		if (retval == -1) {
-		        perror("ioctl");
+		        perror("RTC_PIE_OFF ioctl");
 		        exit(errno);
 		}
 	}
_

Patches currently in -mm which might be from vapier@gentoo.org are

remove-__devinit-markings-from-rtc_sysfs_add_device.patch
search-a-little-harder-for-mkimage.patch
some-rtc-documentation-updates.patch
