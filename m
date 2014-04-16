From: akpm@linux-foundation.org
Subject: [withdrawn] pps-add-non-blocking-option-to-pps_fetch-ioctl.patch
 removed from -mm tree
Date: Wed, 16 Apr 2014 13:27:39 -0700
Message-ID: <534ee7bb.bo+jhUZWYy6yq9N4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaDPU1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 16:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.chavent@onera.fr, giometti@enneenne.com, agordeev@redhat.com, Paul.Chavent@onera.fr

Subject: [withdrawn] pps-add-non-blocking-option-to-pps_fetch-ioctl.patch removed from -mm tree
To: Paul.Chavent@onera.fr,agordeev@redhat.com,giometti@enneenne.com,paul.chavent@onera.fr,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 13:27:39 -0700


The patch titled
     Subject: pps : add non blocking option to PPS_FETCH ioctl.
has been removed from the -mm tree.  Its filename was
     pps-add-non-blocking-option-to-pps_fetch-ioctl.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Paul Chavent <Paul.Chavent@onera.fr>
Subject: pps : add non blocking option to PPS_FETCH ioctl.

The PPS_FETCH ioctl is blocking still the reception of a PPS event.  But,
in some case, one may immediately need the last event date.  This patch
allow to get the result of PPS_FETCH if the device has the O_NONBLOCK flag
set.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |   55 +++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff -puN drivers/pps/pps.c~pps-add-non-blocking-option-to-pps_fetch-ioctl drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-add-non-blocking-option-to-pps_fetch-ioctl
+++ a/drivers/pps/pps.c
@@ -152,35 +152,38 @@ static long pps_cdev_ioctl(struct file *
 		if (err)
 			return -EFAULT;
 
-		ev = pps->last_ev;
+		if (!(file->f_flags & O_NONBLOCK)) {
+			ev = pps->last_ev;
 
-		/* Manage the timeout */
-		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue,
-					ev != pps->last_ev);
-		else {
-			unsigned long ticks;
-
-			dev_dbg(pps->dev, "timeout %lld.%09d\n",
-					(long long) fdata.timeout.sec,
-					fdata.timeout.nsec);
-			ticks = fdata.timeout.sec * HZ;
-			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
-
-			if (ticks != 0) {
-				err = wait_event_interruptible_timeout(
-						pps->queue,
-						ev != pps->last_ev,
-						ticks);
-				if (err == 0)
-					return -ETIMEDOUT;
+			/* Manage the timeout */
+			if (fdata.timeout.flags & PPS_TIME_INVALID)
+				err = wait_event_interruptible(pps->queue,
+						ev != pps->last_ev);
+			else {
+				unsigned long ticks;
+
+				dev_dbg(pps->dev, "timeout %lld.%09d\n",
+						(long long) fdata.timeout.sec,
+						fdata.timeout.nsec);
+				ticks = fdata.timeout.sec * HZ;
+				ticks += fdata.timeout.nsec /
+					(NSEC_PER_SEC / HZ);
+
+				if (ticks != 0) {
+					err = wait_event_interruptible_timeout(
+							pps->queue,
+							ev != pps->last_ev,
+							ticks);
+					if (err == 0)
+						return -ETIMEDOUT;
+				}
 			}
-		}
 
-		/* Check for pending signals */
-		if (err == -ERESTARTSYS) {
-			dev_dbg(pps->dev, "pending signal caught\n");
-			return -EINTR;
+			/* Check for pending signals */
+			if (err == -ERESTARTSYS) {
+				dev_dbg(pps->dev, "pending signal caught\n");
+				return -EINTR;
+			}
 		}
 
 		/* Return the fetched timestamp */
_

Patches currently in -mm which might be from Paul.Chavent@onera.fr are


