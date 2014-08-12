From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-replace-strict_strto-calls.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:42:14 -0700
Message-ID: <53ea6e16.YsCAMgTmB+JtyJXs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:58892 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:14 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2671398pab.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, JBottomley@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi: replace strict_strto calls
has been removed from the -mm tree.  Its filename was
     drivers-scsi-replace-strict_strto-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: drivers/scsi: replace strict_strto calls

Replace obsolete strict_strto with more appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c    |    4 ++--
 drivers/scsi/scsi_sysfs.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/pmcraid.c~drivers-scsi-replace-strict_strto-calls drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~drivers-scsi-replace-strict_strto-calls
+++ a/drivers/scsi/pmcraid.c
@@ -4213,9 +4213,9 @@ static ssize_t pmcraid_store_log_level(
 {
 	struct Scsi_Host *shost;
 	struct pmcraid_instance *pinstance;
-	unsigned long val;
+	u8 val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtou8(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-replace-strict_strto-calls drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~drivers-scsi-replace-strict_strto-calls
+++ a/drivers/scsi/scsi_sysfs.c
@@ -910,9 +910,9 @@ sdev_store_queue_ramp_up_period(struct d
 				const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	unsigned long period;
+	unsigned int period;
 
-	if (strict_strtoul(buf, 10, &period))
+	if (kstrtouint(buf, 10, &period))
 		return -EINVAL;
 
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
_

Patches currently in -mm which might be from dwalter@google.com are

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch

