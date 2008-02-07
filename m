From: akpm@linux-foundation.org
Subject: - rtc-cleanup-example-code.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:47 -0800
Message-ID: <200802070027.m170RSv7007047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935116AbYBGAps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     rtc: cleanup example code
has been removed from the -mm tree.  Its filename was
     rtc-cleanup-example-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-watchdog.patch
