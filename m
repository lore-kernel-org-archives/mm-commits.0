From: akpm@linux-foundation.org
Subject: + ipr-use-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:30:15 -0700
Message-ID: <200806050030.m550UFHK016987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871AbYFEAaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, James.Bottomley@HansenPartnership.com, brking@us.ibm.com


The patch titled
     ipr: use memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     ipr-use-memory_read_from_buffer.patch

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
Subject: ipr: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer
+++ a/drivers/scsi/ipr.c
@@ -2455,20 +2455,14 @@ static ssize_t ipr_read_trace(struct kob
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 	unsigned long lock_flags = 0;
-	int size = IPR_TRACE_SIZE;
-	char *src = (char *)ioa_cfg->trace;
-
-	if (off > size)
-		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
+	ssize_t ret;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	memcpy(buf, &src[off], count);
+	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
+				IPR_TRACE_SIZE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return count;
+
+	return ret;
 }
 
 static struct bin_attribute ipr_trace_attr = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-export-bitrev16.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
binfmt_misc-use-simple_read_from_buffer.patch
ocfs2-use-simple_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
isdn-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
introduce-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
acpi-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
zorro-use-memory_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch

