From: akpm@linux-foundation.org
Subject: + drivers-scsi-mpt2sas-prevent-heap-overflows.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:53:42 -0700
Message-ID: <201104072353.p37NrgEH007806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab1DGXxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, James.Bottomley@HansenPartnership.com, eric.moore@lsi.com, eugeneteo@kernel.sg, kashyap.desai@lsi.com, stable@kernel.org


The patch titled
     drivers/scsi/mpt2sas: prevent heap overflows
has been added to the -mm tree.  Its filename is
     drivers-scsi-mpt2sas-prevent-heap-overflows.patch

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
Subject: drivers/scsi/mpt2sas: prevent heap overflows
From: Dan Rosenberg <drosenberg@vsecurity.com>

At two points in handling device ioctls via /dev/mpt2ctl, user-supplied
length values are used to copy data from userspace into heap buffers
without any bounds checking at all, allowing controllable heap corruption
and subsequently privilege escalation.  This patch should fix these
instances (please review).

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Eric Moore <eric.moore@lsi.com>
Cc: Desai Kashyap <kashyap.desai@lsi.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_ctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-prevent-heap-overflows drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c~drivers-scsi-mpt2sas-prevent-heap-overflows
+++ a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -688,6 +688,12 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPT
 		goto out;
 	}
 
+	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	    karg.data_sge_offset > (UINT_MAX / 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* copy in request message frame from user */
 	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__, __LINE__,
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

drivers-scsi-mpt2sas-prevent-heap-overflows.patch
net-convert-%p-usage-to-%pk.patch

