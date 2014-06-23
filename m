From: akpm@linux-foundation.org
Subject: + drivers-scsi-replace-strict_strto-calls.patch added to -mm tree
Date: Mon, 23 Jun 2014 16:29:50 -0700
Message-ID: <53a8b86e.1Q984lwdSyPztcpt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaFWX3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, JBottomley@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi: replace strict_strto calls
has been added to the -mm tree.  Its filename is
     drivers-scsi-replace-strict_strto-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-scsi-replace-strict_strto-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-scsi-replace-strict_strto-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -885,9 +885,9 @@ sdev_store_queue_ramp_up_period(struct d
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

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

