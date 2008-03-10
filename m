From: akpm@linux-foundation.org
Subject: + gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:27:14 -0700
Message-ID: <200803102027.m2AKREZq003972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYCJUbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svens@stackframe.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com


The patch titled
     gdth: allocate sense_buffer to prevent NULL pointer dereference
has been added to the -mm tree.  Its filename is
     gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch

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

gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch

