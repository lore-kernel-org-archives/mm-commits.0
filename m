From: akpm@linux-foundation.org
Subject: - coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:15 -0700
Message-ID: <200707192003.l6JK3F7E019844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391AbXGSUQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: replace upc_alloc/upc_free with kmalloc/kfree
has been removed from the -mm tree.  Its filename was
     coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: replace upc_alloc/upc_free with kmalloc/kfree
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/psdev.c  |    6 ++----
 fs/coda/upcall.c |   11 ++++-------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN fs/coda/psdev.c~coda-replace-upc_alloc-upc_free-with-kmalloc-kfree fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-replace-upc_alloc-upc_free-with-kmalloc-kfree
+++ a/fs/coda/psdev.c
@@ -49,8 +49,6 @@
 
 #include "coda_int.h"
 
-#define upc_free(r) kfree(r)
-
 /* statistics */
 int           coda_hard;         /* allows signals during upcalls */
 unsigned long coda_timeout = 30; /* .. secs, then signals will dequeue */
@@ -264,7 +262,7 @@ static ssize_t coda_psdev_read(struct fi
 	}
 
 	CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
-	upc_free(req);
+	kfree(req);
 out:
 	unlock_kernel();
 	return (count ? count : retval);
@@ -320,7 +318,7 @@ static int coda_psdev_release(struct ino
 		/* Async requests need to be freed here */
 		if (req->uc_flags & REQ_ASYNC) {
 			CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
-			upc_free(req);
+			kfree(req);
 			continue;
 		}
 		req->uc_flags |= REQ_ABORT;
diff -puN fs/coda/upcall.c~coda-replace-upc_alloc-upc_free-with-kmalloc-kfree fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-replace-upc_alloc-upc_free-with-kmalloc-kfree
+++ a/fs/coda/upcall.c
@@ -37,9 +37,6 @@
 #include <linux/coda_cache.h>
 #include <linux/coda_proc.h> 
 
-#define upc_alloc() kmalloc(sizeof(struct upc_req), GFP_KERNEL)
-#define upc_free(r) kfree(r)
-
 static int coda_upcall(struct coda_sb_info *mntinfo, int inSize, int *outSize, 
 		       union inputArgs *buffer);
 
@@ -745,7 +742,7 @@ static int coda_upcall(struct coda_sb_in
 	}
 
 	/* Format the request message. */
-	req = upc_alloc();
+	req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
@@ -802,12 +799,12 @@ static int coda_upcall(struct coda_sb_in
 	}
 
 	error = -ENOMEM;
-	sig_req = upc_alloc();
+	sig_req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!sig_req) goto exit;
 
 	CODA_ALLOC((sig_req->uc_data), char *, sizeof(struct coda_in_hdr));
 	if (!sig_req->uc_data) {
-		upc_free(sig_req);
+		kfree(sig_req);
 		goto exit;
 	}
 
@@ -827,7 +824,7 @@ static int coda_upcall(struct coda_sb_in
 	wake_up_interruptible(&vcommp->vc_waitq);
 
 exit:
-	upc_free(req);
+	kfree(req);
 	return error;
 }
 
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
