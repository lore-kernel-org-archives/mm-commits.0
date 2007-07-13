From: akpm@linux-foundation.org
Subject: + coda-cleanup-for-upcall-handling-path.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:36 -0700
Message-ID: <200707130529.l6D5Tatu030805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXGMFaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: cleanup for upcall handling path
has been added to the -mm tree.  Its filename is
     coda-cleanup-for-upcall-handling-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: cleanup for upcall handling path
From: Jan Harkes <jaharkes@cs.cmu.edu>

Make the code that processes upcall responses more straightforward, uncovered
at least one bad assumption.  We trusted that vc_inuse would be 0 when upcalls
are aborted, however the device may have been reopened.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |  121 +++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 63 deletions(-)

diff -puN fs/coda/upcall.c~coda-cleanup-for-upcall-handling-path fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-cleanup-for-upcall-handling-path
+++ a/fs/coda/upcall.c
@@ -687,27 +687,27 @@ static inline void coda_waitfor_upcall(s
  * are all mapped to -EINTR, while showing a nice warning message. (jh)
  * 
  */
-static int coda_upcall(struct coda_sb_info *sbi, 
-		int inSize, int *outSize, 
-		union inputArgs *buffer) 
+static int coda_upcall(struct coda_sb_info *sbi,
+		       int inSize, int *outSize,
+		       union inputArgs *buffer)
 {
 	struct venus_comm *vcommp;
 	union outputArgs *out;
-	struct upc_req *req;
+	union inputArgs *sig_inputArgs;
+	struct upc_req *req, *sig_req;
 	int error = 0;
 
 	vcommp = sbi->sbi_vcomm;
-	if ( !vcommp->vc_inuse ) {
-		printk("No pseudo device in upcall comms at %p\n", vcommp);
-                return -ENXIO;
+	if (!vcommp->vc_inuse) {
+		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
+		return -ENXIO;
 	}
 
 	/* Format the request message. */
 	req = upc_alloc();
-	if (!req) {
-		printk("Failed to allocate upc_req structure\n");
+	if (!req)
 		return -ENOMEM;
-	}
+
 	req->uc_data = (void *)buffer;
 	req->uc_flags = 0;
 	req->uc_inSize = inSize;
@@ -715,13 +715,13 @@ static int coda_upcall(struct coda_sb_in
 	req->uc_opcode = ((union inputArgs *)buffer)->ih.opcode;
 	req->uc_unique = ++vcommp->vc_seq;
 	init_waitqueue_head(&req->uc_sleep);
-	
+
 	/* Fill in the common input args. */
 	((union inputArgs *)buffer)->ih.unique = req->uc_unique;
 
 	/* Append msg to pending queue and poke Venus. */
-	list_add_tail(&(req->uc_chain), &vcommp->vc_pending);
-        
+	list_add_tail(&req->uc_chain, &vcommp->vc_pending);
+
 	wake_up_interruptible(&vcommp->vc_waitq);
 	/* We can be interrupted while we wait for Venus to process
 	 * our request.  If the interrupt occurs before Venus has read
@@ -735,64 +735,59 @@ static int coda_upcall(struct coda_sb_in
 	/* Go to sleep.  Wake up on signals only after the timeout. */
 	coda_waitfor_upcall(req);
 
-	if (vcommp->vc_inuse) {      /* i.e. Venus is still alive */
-	    /* Op went through, interrupt or not... */
-	    if (req->uc_flags & REQ_WRITE) {
+	/* Op went through, interrupt or not... */
+	if (req->uc_flags & REQ_WRITE) {
 		out = (union outputArgs *)req->uc_data;
 		/* here we map positive Venus errors to kernel errors */
 		error = -out->oh.result;
 		*outSize = req->uc_outSize;
 		goto exit;
-	    }
-	    if ( !(req->uc_flags & REQ_READ) && signal_pending(current)) { 
-		/* Interrupted before venus read it. */
-		list_del(&(req->uc_chain));
-		/* perhaps the best way to convince the app to
-		   give up? */
-		error = -EINTR;
+	}
+
+	error = -EINTR;
+	if ((req->uc_flags & REQ_ABORT) || !signal_pending(current)) {
+		printk(KERN_WARNING "coda: Unexpected interruption.\n");
+		goto exit;
+	}
+
+	list_del(&(req->uc_chain));
+
+	/* Interrupted before venus read it. */
+	if (!(req->uc_flags & REQ_READ))
+		goto exit;
+
+	/* Venus saw the upcall, make sure we can send interrupt signal */
+	if (!vcommp->vc_inuse) {
+		printk(KERN_INFO "coda: Venus dead, not sending signal.\n");
 		goto exit;
-	    } 
-	    if ( (req->uc_flags & REQ_READ) && signal_pending(current) ) {
-		    /* interrupted after Venus did its read, send signal */
-		    union inputArgs *sig_inputArgs;
-		    struct upc_req *sig_req;
-		    
-		    list_del(&(req->uc_chain));
-		    error = -ENOMEM;
-		    sig_req = upc_alloc();
-		    if (!sig_req) goto exit;
-
-		    CODA_ALLOC((sig_req->uc_data), char *, sizeof(struct coda_in_hdr));
-		    if (!sig_req->uc_data) {
-			upc_free(sig_req);
-			goto exit;
-		    }
-		    
-		    error = -EINTR;
-		    sig_inputArgs = (union inputArgs *)sig_req->uc_data;
-		    sig_inputArgs->ih.opcode = CODA_SIGNAL;
-		    sig_inputArgs->ih.unique = req->uc_unique;
-		    
-		    sig_req->uc_flags = REQ_ASYNC;
-		    sig_req->uc_opcode = sig_inputArgs->ih.opcode;
-		    sig_req->uc_unique = sig_inputArgs->ih.unique;
-		    sig_req->uc_inSize = sizeof(struct coda_in_hdr);
-		    sig_req->uc_outSize = sizeof(struct coda_in_hdr);
-		    
-		    /* insert at head of queue! */
-		    list_add(&(sig_req->uc_chain), &vcommp->vc_pending);
-		    wake_up_interruptible(&vcommp->vc_waitq);
-	    } else {
-		    printk("Coda: Strange interruption..\n");
-		    error = -EINTR;
-	    }
-	} else {	/* If venus died i.e. !VC_OPEN(vcommp) */
-	        printk("coda_upcall: Venus dead on (op,un) (%d.%d) flags %d\n",
-		       req->uc_opcode, req->uc_unique, req->uc_flags);
-		error = -ENODEV;
 	}
 
- exit:
+	error = -ENOMEM;
+	sig_req = upc_alloc();
+	if (!sig_req) goto exit;
+
+	CODA_ALLOC((sig_req->uc_data), char *, sizeof(struct coda_in_hdr));
+	if (!sig_req->uc_data) {
+		upc_free(sig_req);
+		goto exit;
+	}
+
+	error = -EINTR;
+	sig_inputArgs = (union inputArgs *)sig_req->uc_data;
+	sig_inputArgs->ih.opcode = CODA_SIGNAL;
+	sig_inputArgs->ih.unique = req->uc_unique;
+
+	sig_req->uc_flags = REQ_ASYNC;
+	sig_req->uc_opcode = sig_inputArgs->ih.opcode;
+	sig_req->uc_unique = sig_inputArgs->ih.unique;
+	sig_req->uc_inSize = sizeof(struct coda_in_hdr);
+	sig_req->uc_outSize = sizeof(struct coda_in_hdr);
+
+	/* insert at head of queue! */
+	list_add(&(sig_req->uc_chain), &vcommp->vc_pending);
+	wake_up_interruptible(&vcommp->vc_waitq);
+
+exit:
 	upc_free(req);
 	return error;
 }
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
