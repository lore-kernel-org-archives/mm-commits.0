From: akpm@linux-foundation.org
Subject: + scsi-include-linux-scatterlisth-to-pick-up-arch_has_sg_chain.patch added to -mm tree
Date: Tue, 18 Jan 2011 18:48:20 -0800
Message-ID: <201101190248.p0J2mKRp021649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab1ASCs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 21:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dillowda@ornl.gov, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com


The patch titled
     scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
has been added to the -mm tree.  Its filename is
     scsi-include-linux-scatterlisth-to-pick-up-arch_has_sg_chain.patch

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
Subject: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
From: David Dillow <dillowda@ornl.gov>

If the compiled object doesn't include linux/scatterlist.h before
scsi/scsi.h, it will get an incorrect definition of
SCSI_MAX_SG_CHAIN_SEGMENTS.

This fixes an issue I found while working on the SRP initiator, where
linux/scatterlist.h was being pulled in by scsi/scsi_device.h.  It's not
clear if I'm supposed to include linux/scatterlist.h myself, or if I'm
including the scsi headers in the wrong order.  It makes sense for me that
scsi.h would pickup the needed headers itself to prevent confusion.

Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
as all archs have it save m68knommu.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/scsi.h~scsi-include-linux-scatterlisth-to-pick-up-arch_has_sg_chain include/scsi/scsi.h
--- a/include/scsi/scsi.h~scsi-include-linux-scatterlisth-to-pick-up-arch_has_sg_chain
+++ a/include/scsi/scsi.h
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 struct scsi_cmnd;
 
_

Patches currently in -mm which might be from dillowda@ornl.gov are

origin.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
scsi-include-linux-scatterlisth-to-pick-up-arch_has_sg_chain.patch

