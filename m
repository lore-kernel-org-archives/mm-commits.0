From: akpm@linux-foundation.org
Subject: - gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:43 -0700
Message-ID: <200803172100.m2HL0hsK030878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbYCQVB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svens@stackframe.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, mm-commits@vger.kernel.org


The patch titled
     gdth: allocate sense_buffer to prevent NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdth: allocate sense_buffer to prevent NULL pointer dereference
From: Sven Schnelle <svens@stackframe.org>

This fixes a NULL pointer dereference during execution of Internal commands,
where gdth only allocates scp, but not scp->sense_buffer.  The rest of the
code assumes that sense_buffer is allocated, which leads to a kernel oops e.g.
 on reboot (during cache flush).

So we have two choices here:

a) Allocate the sense_buffer
b) surrounding all accesses to sense_buffer with some if (!internal_command)

I'm using solution a, as this keeps code simpler.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/scsi/gdth.c~gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference
+++ a/drivers/scsi/gdth.c
@@ -452,6 +452,12 @@ int __gdth_execute(struct scsi_device *s
     if (!scp)
         return -ENOMEM;
 
+    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+    if (!scp->sense_buffer) {
+	kfree(scp);
+	return -ENOMEM;
+    }
+
     scp->device = sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
@@ -472,6 +478,7 @@ int __gdth_execute(struct scsi_device *s
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
+    kfree(scp->sense_buffer);
     kfree(scp);
     return rval;
 }
_

Patches currently in -mm which might be from svens@stackframe.org are

git-scsi-rc-fixes.patch

