From: akpm@linux-foundation.org
Subject: + scsi-53c700-remove-dma_is_consistent-usage.patch added to -mm tree
Date: Tue, 10 Aug 2010 17:11:50 -0700
Message-ID: <201008110041.o7B0fn8s026156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab0HKAmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Aug 2010 20:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de


The patch titled
     scsi: 53c700: remove dma_is_consistent usage
has been added to the -mm tree.  Its filename is
     scsi-53c700-remove-dma_is_consistent-usage.patch

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
Subject: scsi: 53c700: remove dma_is_consistent usage
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This driver is the only user of dma_is_consistent().  We plan to remove this
API.

The driver uses the API in the following way:

BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());

The above code tries to see if L1_CACHE_BYTES is greater than
dma_get_cache_alignment() on sysmtes that can not allocate coherent memory
(some old systems can't).

James Bottomley exmplained that this is necesary because the driver packs the
set of mailboxes into a single coherent area and separates the different
usages by a L1 cache stride.  So it's fatal if the dma

He also pointed out that we can kill this checking because we don't hit this
BUG_ON on all architectures that actually use the driver.

(akpm: stolen from the scsi tree because
dma-mapping-remove-dma_is_consistent-api.patch needs it)

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/53c700.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/scsi/53c700.c~scsi-53c700-remove-dma_is_consistent-usage drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c~scsi-53c700-remove-dma_is_consistent-usage
+++ a/drivers/scsi/53c700.c
@@ -309,9 +309,6 @@ NCR_700_detect(struct scsi_host_template
 	hostdata->msgin = memory + MSGIN_OFFSET;
 	hostdata->msgout = memory + MSGOUT_OFFSET;
 	hostdata->status = memory + STATUS_OFFSET;
-	/* all of these offsets are L1_CACHE_BYTES separated.  It is fatal
-	 * if this isn't sufficient separation to avoid dma flushing issues */
-	BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
 	hostdata->slots = (struct NCR_700_command_slot *)(memory + SLOTS_OFFSET);
 	hostdata->dev = dev;
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-rename-arch_kmalloc_minalign-to-arch_dma_minalign.patch
dma-mapping-unify-dma_get_cache_alignment-implementations.patch
dma-mapping-parisc-set-arch_dma_minalign.patch
scsi-53c700-remove-dma_is_consistent-usage.patch
dma-mapping-remove-dma_is_consistent-api.patch
documentation-dma-api-howtotxt-add-multiple-types-of-iommus-support.patch
pci-add-pci-dma-unamp-state-api-to-feature-removal-scheduletxt.patch
dma-mapping-add-dma_xxbit_mask-to-feature-removal-scheduletxt.patch

