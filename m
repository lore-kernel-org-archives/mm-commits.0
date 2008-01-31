From: akpm@linux-foundation.org
Subject: + rtc-cleanup-example-code.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:31:58 -0800
Message-ID: <200801312331.m0VNVweg016963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbYAaXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org


The patch titled
     rtc: cleanup example code
has been added to the -mm tree.  Its filename is
     rtc-cleanup-example-code.patch

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
Subject: rtc: cleanup example code
From: Mike Frysinger <vapier.adi@gmail.com>

No functional changes here, just tighten up style/whitespace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN Documentation/rtc.txt~rtc-cleanup-example-code Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-cleanup-example-code
+++ a/Documentation/rtc.txt
@@ -268,8 +268,8 @@ int main(int argc, char **argv)
 		/* This read will block */
 		retval = read(fd, &data, sizeof(unsigned long));
 		if (retval == -1) {
-		        perror("read");
-		        exit(errno);
+			perror("read");
+			exit(errno);
 		}
 		fprintf(stderr, " %d",i);
 		fflush(stderr);
@@ -326,11 +326,11 @@ test_READ:
 		rtc_tm.tm_sec %= 60;
 		rtc_tm.tm_min++;
 	}
-	if  (rtc_tm.tm_min == 60) {
+	if (rtc_tm.tm_min == 60) {
 		rtc_tm.tm_min = 0;
 		rtc_tm.tm_hour++;
 	}
-	if  (rtc_tm.tm_hour == 24)
+	if (rtc_tm.tm_hour == 24)
 		rtc_tm.tm_hour = 0;
 
 	retval = ioctl(fd, RTC_ALM_SET, &rtc_tm);
@@ -407,8 +407,8 @@ test_PIE:
 					"\n...Periodic IRQ rate is fixed\n");
 				goto done;
 			}
-		        perror("RTC_IRQP_SET ioctl");
-		        exit(errno);
+			perror("RTC_IRQP_SET ioctl");
+			exit(errno);
 		}
 
 		fprintf(stderr, "\n%ldHz:\t", tmp);
@@ -417,27 +417,27 @@ test_PIE:
 		/* Enable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_ON, 0);
 		if (retval == -1) {
-		        perror("RTC_PIE_ON ioctl");
-		        exit(errno);
+			perror("RTC_PIE_ON ioctl");
+			exit(errno);
 		}
 
 		for (i=1; i<21; i++) {
-		        /* This blocks */
-		        retval = read(fd, &data, sizeof(unsigned long));
-		        if (retval == -1) {
-				       perror("read");
-				       exit(errno);
-		        }
-		        fprintf(stderr, " %d",i);
-		        fflush(stderr);
-		        irqcount++;
+			/* This blocks */
+			retval = read(fd, &data, sizeof(unsigned long));
+			if (retval == -1) {
+				perror("read");
+				exit(errno);
+			}
+			fprintf(stderr, " %d",i);
+			fflush(stderr);
+			irqcount++;
 		}
 
 		/* Disable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_OFF, 0);
 		if (retval == -1) {
-		        perror("RTC_PIE_OFF ioctl");
-		        exit(errno);
+			perror("RTC_PIE_OFF ioctl");
+			exit(errno);
 		}
 	}
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

git-kbuild.patch
git-watchdog.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-inclusions-of-linux-autoconfh.patch
rtc-update-documentation-wrt-irq_set_freq.patch
rtc-cleanup-example-code.patch
