From: akpm@linux-foundation.org
Subject: [merged] gru-add-test-for-gru_copy_gpa.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:35 -0800
Message-ID: <200912162040.nBGKeZ3E013655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965015AbZLPUki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add test for gru_copy_gpa
has been removed from the -mm tree.  Its filename was
     gru-add-test-for-gru_copy_gpa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add test for gru_copy_gpa
From: Jack Steiner <steiner@sgi.com>

Improve existing driver self-tests.  Add a new debugging test to the SGI
GRU driver for verifying the global GRU copy function.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   48 +++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-add-test-for-gru_copy_gpa drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-add-test-for-gru_copy_gpa
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -1004,6 +1004,7 @@ static int quicktest2(unsigned long arg)
 	int ret = 0;
 	unsigned long *buf;
 	void *cb0, *cb;
+	struct gru_control_block_status *gen;
 	int i, k, istatus, bytes;
 
 	bytes = numcb * 4 * 8;
@@ -1023,20 +1024,30 @@ static int quicktest2(unsigned long arg)
 				XTYPE_DW, 4, 1, IMA_INTERRUPT);
 
 	ret = 0;
-	for (k = 0; k < numcb; k++) {
+	k = numcb;
+	do {
 		gru_wait_async_cbr(han);
 		for (i = 0; i < numcb; i++) {
 			cb = cb0 + i * GRU_HANDLE_STRIDE;
 			istatus = gru_check_status(cb);
-			if (istatus == CBS_ACTIVE)
-				continue;
-			if (istatus == CBS_EXCEPTION)
-				ret = -EFAULT;
-			else if (buf[i] || buf[i + 1] || buf[i + 2] ||
-					buf[i + 3])
-				ret = -EIO;
+			if (istatus != CBS_ACTIVE && istatus != CBS_CALL_OS)
+				break;
 		}
-	}
+		if (i == numcb)
+			continue;
+		if (istatus != CBS_IDLE) {
+			printk(KERN_DEBUG "GRU:%d quicktest2: cb %d, exception\n", smp_processor_id(), i);
+			ret = -EFAULT;
+		} else if (buf[4 * i] || buf[4 * i + 1] || buf[4 * i + 2] ||
+				buf[4 * i + 3]) {
+			printk(KERN_DEBUG "GRU:%d quicktest2:cb %d,  buf 0x%lx, 0x%lx, 0x%lx, 0x%lx\n",
+			       smp_processor_id(), i, buf[4 * i], buf[4 * i + 1], buf[4 * i + 2], buf[4 * i + 3]);
+			ret = -EIO;
+		}
+		k--;
+		gen = cb;
+		gen->istatus = CBS_CALL_OS; /* don't handle this CBR again */
+	} while (k);
 	BUG_ON(cmp.done);
 
 	gru_unlock_async_resource(han);
@@ -1046,6 +1057,22 @@ done:
 	return ret;
 }
 
+#define BUFSIZE 200
+static int quicktest3(unsigned long arg)
+{
+	char buf1[BUFSIZE], buf2[BUFSIZE];
+	int ret = 0;
+
+	memset(buf2, 0, sizeof(buf2));
+	memset(buf1, get_cycles() & 255, sizeof(buf1));
+	gru_copy_gpa(uv_gpa(buf2), uv_gpa(buf1), BUFSIZE);
+	if (memcmp(buf1, buf2, BUFSIZE)) {
+		printk(KERN_DEBUG "GRU quicktest3 error\n");
+		ret = -EIO;
+	}
+	return ret;
+}
+
 /*
  * Debugging only. User hook for various kernel tests
  * of driver & gru.
@@ -1064,6 +1091,9 @@ int gru_ktest(unsigned long arg)
 	case 2:
 		ret = quicktest2(arg);
 		break;
+	case 3:
+		ret = quicktest3(arg);
+		break;
 	case 99:
 		ret = gru_free_kernel_contexts();
 		break;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

