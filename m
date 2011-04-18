From: akpm@linux-foundation.org
Subject: + drivers-scsi-mpt2sas-prevent-heap-overflows-and-unchecked-reads.patch added to -mm tree
Date: Mon, 18 Apr 2011 11:30:03 -0700
Message-ID: <201104181830.p3IIU3JV017717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab1DRSai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, James.Bottomley@HansenPartnership.com, eric.moore@lsi.com, eugeneteo@kernel.sg, kashyap.desai@lsi.com, stable@kernel.org


The patch titled
     drivers/scsi/mpt2sas: prevent heap overflows and unchecked reads
has been added to the -mm tree.  Its filename is
     drivers-scsi-mpt2sas-prevent-heap-overflows-and-unchecked-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/mpt2sas: prevent heap overflows and unchecked reads
From: Dan Rosenberg <drosenberg@vsecurity.com>

At two points in handling device ioctls via /dev/mpt2ctl, user-supplied
length values are used to copy data from userspace into heap buffers
without bounds checking, allowing controllable heap corruption and
subsequently privilege escalation.

Additionally, user-supplied values are used to determine the size of a
copy_to_user() as well as the offset into the buffer to be read, with no
bounds checking, allowing users to read arbitrary kernel memory.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Tested-by: Eric Moore <eric.moore@lsi.com>
Acked-by: Eric Moore <eric.moore@lsi.com>
Cc: Desai Kashyap <kashyap.desai@lsi.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_ctl.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-prevent-heap-overflows-and-unchecked-reads drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-prevent-heap-overflows-and-unchecked-reads
+++ a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -688,6 +688,13 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPT
 		goto out;
 	}
 
+	/* Check for overflow and wraparound */
+	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	    karg.data_sge_offset > (UINT_MAX / 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* copy in request message frame from user */
 	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__, __LINE__,
@@ -1963,7 +1970,7 @@ _ctl_diag_read_buffer(void __user *arg, 
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	int rc, i;
 	u8 buffer_type;
-	unsigned long timeleft;
+	unsigned long timeleft, request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
 	u8 issue_reset = 0;
@@ -1999,6 +2006,8 @@ _ctl_diag_read_buffer(void __user *arg, 
 		return -ENOMEM;
 	}
 
+	request_size = ioc->diag_buffer_sz[buffer_type];
+
 	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
 		printk(MPT2SAS_ERR_FMT "%s: either the starting_offset "
 		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
@@ -2006,13 +2015,23 @@ _ctl_diag_read_buffer(void __user *arg, 
 		return -EINVAL;
 	}
 
+	if (karg.starting_offset > request_size)
+		return -EINVAL;
+
 	diag_data = (void *)(request_data + karg.starting_offset);
 	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: diag_buffer(%p), "
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
+	/* Truncate data on requests that are too large */
+	if ((diag_data + karg.bytes_to_read < diag_data) ||
+	    (diag_data + karg.bytes_to_read > request_data + request_size))
+		copy_size = request_size - karg.starting_offset;
+	else
+		copy_size = karg.bytes_to_read;
+
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
-	    diag_data, karg.bytes_to_read)) {
+	    diag_data, copy_size)) {
 		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
 		    "mpt_diag_read_buffer_t data @ %p\n", ioc->name,
 		    __func__, diag_data);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

drivers-scsi-pmcraid-reject-negative-request-size.patch
drivers-scsi-mpt2sas-prevent-heap-overflows-and-unchecked-reads.patch
net-convert-%p-usage-to-%pk.patch

