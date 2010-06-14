From: akpm@linux-foundation.org
Subject: + hpilo-fix-pointer-warning-in-ilo_ccb_setup.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:27:12 -0700
Message-ID: <201006141927.o5EJRC0U026421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNT10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, david.altobelli@hp.com


The patch titled
     hpilo: fix pointer warning in ilo_ccb_setup
has been added to the -mm tree.  Its filename is
     hpilo-fix-pointer-warning-in-ilo_ccb_setup.patch

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
Subject: hpilo: fix pointer warning in ilo_ccb_setup
From: Prarit Bhargava <prarit@redhat.com>

Fix i386 PAE compile warning:

drivers/misc/hpilo.c: In function `ilo_ccb_setup':
drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size

dma_addr_t is 64 on i386 PAE which causes a size mismatch.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |   17 +++++++++--------
 drivers/misc/hpilo.h |    8 ++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/misc/hpilo.c~hpilo-fix-pointer-warning-in-ilo_ccb_setup drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-fix-pointer-warning-in-ilo_ccb_setup
+++ a/drivers/misc/hpilo.c
@@ -256,7 +256,8 @@ static void ilo_ccb_close(struct pci_dev
 
 static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 {
-	char *dma_va, *dma_pa;
+	char *dma_va;
+	dma_addr_t dma_pa;
 	struct ccb *driver_ccb, *ilo_ccb;
 
 	driver_ccb = &data->driver_ccb;
@@ -272,12 +273,12 @@ static int ilo_ccb_setup(struct ilo_hwin
 		return -ENOMEM;
 
 	dma_va = (char *)data->dma_va;
-	dma_pa = (char *)data->dma_pa;
+	dma_pa = data->dma_pa;
 
 	memset(dma_va, 0, data->dma_size);
 
 	dma_va = (char *)roundup((unsigned long)dma_va, ILO_START_ALIGN);
-	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_START_ALIGN);
+	dma_pa = roundup(dma_pa, ILO_START_ALIGN);
 
 	/*
 	 * Create two ccb's, one with virt addrs, one with phys addrs.
@@ -288,26 +289,26 @@ static int ilo_ccb_setup(struct ilo_hwin
 
 	fifo_setup(dma_va, NR_QENTRY);
 	driver_ccb->ccb_u1.send_fifobar = dma_va + FIFOHANDLESIZE;
-	ilo_ccb->ccb_u1.send_fifobar = dma_pa + FIFOHANDLESIZE;
+	ilo_ccb->ccb_u1.send_fifobar_pa = dma_pa + FIFOHANDLESIZE;
 	dma_va += fifo_sz(NR_QENTRY);
 	dma_pa += fifo_sz(NR_QENTRY);
 
 	dma_va = (char *)roundup((unsigned long)dma_va, ILO_CACHE_SZ);
-	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_CACHE_SZ);
+	dma_pa = roundup(dma_pa, ILO_CACHE_SZ);
 
 	fifo_setup(dma_va, NR_QENTRY);
 	driver_ccb->ccb_u3.recv_fifobar = dma_va + FIFOHANDLESIZE;
-	ilo_ccb->ccb_u3.recv_fifobar = dma_pa + FIFOHANDLESIZE;
+	ilo_ccb->ccb_u3.recv_fifobar_pa = dma_pa + FIFOHANDLESIZE;
 	dma_va += fifo_sz(NR_QENTRY);
 	dma_pa += fifo_sz(NR_QENTRY);
 
 	driver_ccb->ccb_u2.send_desc = dma_va;
-	ilo_ccb->ccb_u2.send_desc = dma_pa;
+	ilo_ccb->ccb_u2.send_desc_pa = dma_pa;
 	dma_pa += desc_mem_sz(NR_QENTRY);
 	dma_va += desc_mem_sz(NR_QENTRY);
 
 	driver_ccb->ccb_u4.recv_desc = dma_va;
-	ilo_ccb->ccb_u4.recv_desc = dma_pa;
+	ilo_ccb->ccb_u4.recv_desc_pa = dma_pa;
 
 	driver_ccb->channel = slot;
 	ilo_ccb->channel = slot;
diff -puN drivers/misc/hpilo.h~hpilo-fix-pointer-warning-in-ilo_ccb_setup drivers/misc/hpilo.h
--- a/drivers/misc/hpilo.h~hpilo-fix-pointer-warning-in-ilo_ccb_setup
+++ a/drivers/misc/hpilo.h
@@ -79,21 +79,21 @@ struct ilo_hwinfo {
 struct ccb {
 	union {
 		char *send_fifobar;
-		u64 padding1;
+		u64 send_fifobar_pa;
 	} ccb_u1;
 	union {
 		char *send_desc;
-		u64 padding2;
+		u64 send_desc_pa;
 	} ccb_u2;
 	u64 send_ctrl;
 
 	union {
 		char *recv_fifobar;
-		u64 padding3;
+		u64 recv_fifobar_pa;
 	} ccb_u3;
 	union {
 		char *recv_desc;
-		u64 padding4;
+		u64 recv_desc_pa;
 	} ccb_u4;
 	u64 recv_ctrl;
 
_

Patches currently in -mm which might be from prarit@redhat.com are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
hpilo-fix-pointer-warning-in-ilo_ccb_setup.patch
lib-decompress_bunzip2c-fix-checkstack-warning.patch

