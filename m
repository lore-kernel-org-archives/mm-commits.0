From: akpm@linux-foundation.org
Subject: [merged] rtc-document-the-sysfs-interface.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:21 -0700
Message-ID: <200909231959.n8NJxL27010764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbZIWT7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: document the sysfs interface
has been removed from the -mm tree.  Its filename was
     rtc-document-the-sysfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: document the sysfs interface
From: Matthew Garrett <mjg@redhat.com>

The sysfs interface to the RTC class drivers is currently undocumented.
Add some basic documentation defining the semantics of the fields.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN Documentation/rtc.txt~rtc-document-the-sysfs-interface Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-document-the-sysfs-interface
+++ a/Documentation/rtc.txt
@@ -135,6 +135,28 @@ a high functionality RTC is integrated i
 the system clock from the discrete RTC, but use the integrated one for all
 other tasks, because of its greater functionality.
 
+SYSFS INTERFACE
+---------------
+
+The sysfs interface under /sys/class/rtc/rtcN provides access to various
+rtc attributes without requiring the use of ioctls. All dates and times
+are in the RTC's timezone, rather than in system time.
+
+date:  	   	 RTC-provided date
+max_user_freq:	 The maximum interrupt rate an unprivileged user may request
+		 from this RTC.
+name:		 The name of the RTC corresponding to this sysfs directory
+since_epoch:	 The number of seconds since the epoch according to the RTC
+time:		 RTC-provided time
+wakealarm:	 The time at which the clock will generate a system wakeup
+		 event. This is a one shot wakeup event, so must be reset
+		 after wake if a daily wakeup is required. Format is either
+		 seconds since the epoch or, if there's a leading +, seconds
+		 in the future.
+
+IOCTL INTERFACE
+---------------
+
 The ioctl() calls supported by /dev/rtc are also supported by the RTC class
 framework.  However, because the chips and systems are not standardized,
 some PC/AT functionality might not be provided.  And in the same way, some
_

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch

