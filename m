From: akpm@linux-foundation.org
Subject: - idr-error-checking-factorization.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:41 -0700
Message-ID: <200807252300.m6PN0fMU003609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYGYXCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     idr: error checking factorization
has been removed from the -mm tree.  Its filename was
     idr-error-checking-factorization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: error checking factorization
From: Nadia Derbey <Nadia.Derbey@bull.net>

Do some code factorization in the return code analysis.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    6 ++++++
 lib/idr.c           |   30 +++++++++---------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff -puN include/linux/idr.h~idr-error-checking-factorization include/linux/idr.h
--- a/include/linux/idr.h~idr-error-checking-factorization
+++ a/include/linux/idr.h
@@ -73,6 +73,12 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
+/* Actions to be taken after a call to _idr_sub_alloc */
+#define IDR_NEED_TO_GROW -2
+#define IDR_NOMORE_SPACE -3
+
+#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
+
 /*
  * This is what we export.
  */
diff -puN lib/idr.c~idr-error-checking-factorization lib/idr.c
--- a/lib/idr.c~idr-error-checking-factorization
+++ a/lib/idr.c
@@ -143,7 +143,7 @@ static int sub_alloc(struct idr *idp, in
 			/* if already at the top layer, we need to grow */
 			if (!(p = pa[l])) {
 				*starting_id = id;
-				return -2;
+				return IDR_NEED_TO_GROW;
 			}
 
 			/* If we need to go up one layer, continue the
@@ -160,7 +160,7 @@ static int sub_alloc(struct idr *idp, in
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
 		if ((id >= MAX_ID_BIT) || (id < 0))
-			return -3;
+			return IDR_NOMORE_SPACE;
 		if (l == 0)
 			break;
 		/*
@@ -229,7 +229,7 @@ build_up:
 	idp->top = p;
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == -2)
+	if (v == IDR_NEED_TO_GROW)
 		goto build_up;
 	return(v);
 }
@@ -278,12 +278,8 @@ int idr_get_new_above(struct idr *idp, v
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -313,12 +309,8 @@ int idr_get_new(struct idr *idp, void *p
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -696,12 +688,8 @@ int ida_get_new_above(struct ida *ida, i
  restart:
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
-	if (t < 0) {
-		if (t == -1)
-			return -EAGAIN;
-		else /* will be -3 */
-			return -ENOSPC;
-	}
+	if (t < 0)
+		return _idr_rc_to_errno(t);
 
 	if (t * IDA_BITMAP_BITS >= MAX_ID_BIT)
 		return -ENOSPC;
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch

