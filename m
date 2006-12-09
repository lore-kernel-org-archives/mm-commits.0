From: akpm@osdl.org
Subject: + kcalloc-re-order-out-of-order-args-in-kcalloc-calls.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:41:11 -0800
Message-ID: <200612092241.kB9MfBcr006284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbWLIWlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com, benh@kernel.crashing.org, greg@kroah.com, jeff@garzik.org, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     kcalloc: Re-order out-of-order args in kcalloc() calls.
has been added to the -mm tree.  Its filename is
     kcalloc-re-order-out-of-order-args-in-kcalloc-calls.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kcalloc: Re-order out-of-order args in kcalloc() calls.
From: "Robert P. J. Day" <rpjday@mindspring.com>

A small number of kcalloc() calls in the source have the first two
arguments in the wrong order.  An aesthetic thing.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/macintosh/smu.c             |    2 +-
 drivers/net/skge.c                  |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    2 +-
 drivers/usb/misc/uss720.c           |    2 +-
 net/sunrpc/svc.c                    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/macintosh/smu.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls
+++ a/drivers/macintosh/smu.c
@@ -945,7 +945,7 @@ static struct smu_sdbp_header *smu_creat
 	 */
 	tlen = sizeof(struct property) + len + 18;
 
-	prop = kcalloc(tlen, 1, GFP_KERNEL);
+	prop = kcalloc(1, tlen, GFP_KERNEL);
 	if (prop == NULL)
 		return NULL;
 	hdr = (struct smu_sdbp_header *)(prop + 1);
diff -puN drivers/net/skge.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls drivers/net/skge.c
--- a/drivers/net/skge.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls
+++ a/drivers/net/skge.c
@@ -749,7 +749,7 @@ static int skge_ring_alloc(struct skge_r
 	struct skge_element *e;
 	int i;
 
-	ring->start = kcalloc(sizeof(*e), ring->count, GFP_KERNEL);
+	ring->start = kcalloc(ring->count, sizeof(*e), GFP_KERNEL);
 	if (!ring->start)
 		return -ENOMEM;
 
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5545,7 +5545,7 @@ int sym_hcb_attach(struct Scsi_Host *sho
 	/*
 	 *  Allocate the array of lists of CCBs hashed by DSA.
 	 */
-	np->ccbh = kcalloc(sizeof(struct sym_ccb **), CCB_HASH_SIZE, GFP_KERNEL);
+	np->ccbh = kcalloc(CCB_HASH_SIZE, sizeof(struct sym_ccb **), GFP_KERNEL);
 	if (!np->ccbh)
 		goto attach_failed;
 
diff -puN drivers/usb/misc/uss720.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls
+++ a/drivers/usb/misc/uss720.c
@@ -705,7 +705,7 @@ static int uss720_probe(struct usb_inter
 	/*
 	 * Allocate parport interface 
 	 */
-	if (!(priv = kcalloc(sizeof(struct parport_uss720_private), 1, GFP_KERNEL))) {
+	if (!(priv = kcalloc(1, sizeof(struct parport_uss720_private), GFP_KERNEL))) {
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
diff -puN net/sunrpc/svc.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~kcalloc-re-order-out-of-order-args-in-kcalloc-calls
+++ a/net/sunrpc/svc.c
@@ -308,7 +308,7 @@ __svc_create(struct svc_program *prog, u
 
 	serv->sv_nrpools = npools;
 	serv->sv_pools =
-		kcalloc(sizeof(struct svc_pool), serv->sv_nrpools,
+		kcalloc(serv->sv_nrpools, sizeof(struct svc_pool),
 			GFP_KERNEL);
 	if (!serv->sv_pools) {
 		kfree(serv);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
kcalloc-re-order-out-of-order-args-in-kcalloc-calls.patch
schedc-correct-comment-for-this_rq_lock-routine.patch

