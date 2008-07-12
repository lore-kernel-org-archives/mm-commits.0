From: akpm@linux-foundation.org
Subject: + libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:41:21 -0700
Message-ID: <200807120041.m6C0fLcw012827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbYGLAmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chunbo.luo@windriver.com, jeff@garzik.org, tj@kernel.org


The patch titled
     libata-scsi: don't start hotplug work queue if hotplug is disabled
has been added to the -mm tree.  Its filename is
     libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch

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
Subject: libata-scsi: don't start hotplug work queue if hotplug is disabled
From: Chunbo Luo <chunbo.luo@windriver.com>

Previously, queue_delayed_work() was started unconditionally, but if
ATA_PFLAG_SCSI_HOTPLUG is not set and we do this, the work queue may cause
multiple messages like this:

ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.

So now,it is only started when the hotplug flag is actually set.

Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled
+++ a/drivers/ata/libata-scsi.c
@@ -3206,8 +3206,9 @@ void ata_scsi_scan_host(struct ata_port 
 				"                  switching to async\n");
 	}
 
-	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
-			   round_jiffies_relative(HZ));
+	if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
+		queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+				round_jiffies_relative(HZ));
 }
 
 /**
_

Patches currently in -mm which might be from chunbo.luo@windriver.com are

libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch

