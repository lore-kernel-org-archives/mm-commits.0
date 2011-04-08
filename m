From: akpm@linux-foundation.org
Subject: + drivers-scsi-pmcraid-reject-negative-request-size.patch added to -mm tree
Date: Fri, 08 Apr 2011 12:02:00 -0700
Message-ID: <201104081902.p38J20w4023817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846Ab1DHTCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2011 15:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, James.Bottomley@HansenPartnership.com, anil_ravindranath@pmc-sierra.com


The patch titled
     drivers/scsi/pmcraid: reject negative request size
has been added to the -mm tree.  Its filename is
     drivers-scsi-pmcraid-reject-negative-request-size.patch

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
Subject: drivers/scsi/pmcraid: reject negative request size
From: Dan Rosenberg <drosenberg@vsecurity.com>

There's a code path in pmcraid that can be reached via device ioctl that
causes all sorts of ugliness, including heap corruption or triggering the
OOM killer due to consecutive allocation of large numbers of pages.

First, the user can call pmcraid_chr_ioctl(), with a type
PMCRAID_PASSTHROUGH_IOCTL.  This calls through to
pmcraid_ioctl_passthrough().  Next, a pmcraid_passthrough_ioctl_buffer is
copied in, and the request_size variable is set to
buffer->ioarcb.data_transfer_length, which is an arbitrary 32-bit signed
value provided by the user.  If a negative value is provided here, bad
things can happen.  For example, pmcraid_build_passthrough_ioadls() is
called with this request_size, which immediately calls
pmcraid_alloc_sglist() with a negative size.  The resulting math on
allocating a scatter list can result in an overflow in the kzalloc() call
(if num_elem is 0, the sglist will be smaller than expected), or if
num_elem is unexpectedly large the subsequent loop will call alloc_pages()
repeatedly, a high number of pages will be allocated and the OOM killer
might be invoked.

It looks like preventing this value from being negative in
pmcraid_ioctl_passthrough() would be sufficient.  Something like this
might do:

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/pmcraid.c~drivers-scsi-pmcraid-reject-negative-request-size drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~drivers-scsi-pmcraid-reject-negative-request-size
+++ a/drivers/scsi/pmcraid.c
@@ -3814,6 +3814,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

drivers-scsi-pmcraid-reject-negative-request-size.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
net-convert-%p-usage-to-%pk.patch

