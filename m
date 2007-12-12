From: akpm@linux-foundation.org
Subject: + md-raid6-clean-up-the-style-of-raid6test-testc.patch added to -mm tree
Date: Tue, 11 Dec 2007 22:07:27 -0800
Message-ID: <200712120607.lBC67Rv3028887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbXLLGIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 01:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, neilb@suse.de


The patch titled
     md: raid6: clean up the style of raid6test/test.c
has been added to the -mm tree.  Its filename is
     md-raid6-clean-up-the-style-of-raid6test-testc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: raid6: clean up the style of raid6test/test.c
From: "H. Peter Anvin" <hpa@zytor.com>

Clean up the coding style in raid6test/test.c.  Break it apart into
subfunctions to make the code more readable.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid6test/test.c |  115 ++++++++++++++++++++--------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff -puN drivers/md/raid6test/test.c~md-raid6-clean-up-the-style-of-raid6test-testc drivers/md/raid6test/test.c
--- a/drivers/md/raid6test/test.c~md-raid6-clean-up-the-style-of-raid6test-testc
+++ a/drivers/md/raid6test/test.c
@@ -1,12 +1,10 @@
 /* -*- linux-c -*- ------------------------------------------------------- *
  *
- *   Copyright 2002 H. Peter Anvin - All Rights Reserved
+ *   Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
  *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
- *   (at your option) any later version; incorporated herein by reference.
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
 
@@ -30,67 +28,87 @@ char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE];
 char recovi[PAGE_SIZE], recovj[PAGE_SIZE];
 
-void makedata(void)
+static void makedata(void)
 {
 	int i, j;
 
-	for (  i = 0 ; i < NDISKS ; i++ ) {
-		for ( j = 0 ; j < PAGE_SIZE ; j++ ) {
+	for (i = 0; i < NDISKS; i++) {
+		for (j = 0; j < PAGE_SIZE; j++)
 			data[i][j] = rand();
-		}
+
 		dataptrs[i] = data[i];
 	}
 }
 
+static char disk_type(int d)
+{
+	switch (d) {
+	case NDISKS-2:
+		return 'P';
+	case NDISKS-1:
+		return 'Q';
+	default:
+		return 'D';
+	}
+}
+
+static int test_disks(int i, int j)
+{
+	int erra, errb;
+
+	memset(recovi, 0xf0, PAGE_SIZE);
+	memset(recovj, 0xba, PAGE_SIZE);
+
+	dataptrs[i] = recovi;
+	dataptrs[j] = recovj;
+
+	raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, (void **)&dataptrs);
+
+	erra = memcmp(data[i], recovi, PAGE_SIZE);
+	errb = memcmp(data[j], recovj, PAGE_SIZE);
+
+	if (i < NDISKS-2 && j == NDISKS-1) {
+		/* We don't implement the DQ failure scenario, since it's
+		   equivalent to a RAID-5 failure (XOR, then recompute Q) */
+		erra = errb = 0;
+	} else {
+		printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
+		       raid6_call.name,
+		       i, disk_type(i),
+		       j, disk_type(j),
+		       (!erra && !errb) ? "OK" :
+		       !erra ? "ERRB" :
+		       !errb ? "ERRA" : "ERRAB");
+	}
+
+	dataptrs[i] = data[i];
+	dataptrs[j] = data[j];
+
+	return erra || errb;
+}
+
 int main(int argc, char *argv[])
 {
-	const struct raid6_calls * const * algo;
+	const struct raid6_calls *const *algo;
 	int i, j;
-	int erra, errb;
+	int err = 0;
 
 	makedata();
 
-	for ( algo = raid6_algos ; *algo ; algo++ ) {
-		if ( !(*algo)->valid || (*algo)->valid() ) {
+	for (algo = raid6_algos; *algo; algo++) {
+		if (!(*algo)->valid || (*algo)->valid()) {
 			raid6_call = **algo;
 
 			/* Nuke syndromes */
 			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
 
 			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
+			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+						(void **)&dataptrs);
 
-			for ( i = 0 ; i < NDISKS-1 ; i++ ) {
-				for ( j = i+1 ; j < NDISKS ; j++ ) {
-					memset(recovi, 0xf0, PAGE_SIZE);
-					memset(recovj, 0xba, PAGE_SIZE);
-
-					dataptrs[i] = recovi;
-					dataptrs[j] = recovj;
-
-					raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, (void **)&dataptrs);
-
-					erra = memcmp(data[i], recovi, PAGE_SIZE);
-					errb = memcmp(data[j], recovj, PAGE_SIZE);
-
-					if ( i < NDISKS-2 && j == NDISKS-1 ) {
-						/* We don't implement the DQ failure scenario, since it's
-						   equivalent to a RAID-5 failure (XOR, then recompute Q) */
-					} else {
-						printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
-						       raid6_call.name,
-						       i, (i==NDISKS-2)?'P':'D',
-						       j, (j==NDISKS-1)?'Q':(j==NDISKS-2)?'P':'D',
-						       (!erra && !errb) ? "OK" :
-						       !erra ? "ERRB" :
-						       !errb ? "ERRA" :
-						       "ERRAB");
-					}
-
-					dataptrs[i] = data[i];
-					dataptrs[j] = data[j];
-				}
-			}
+			for (i = 0; i < NDISKS-1; i++)
+				for (j = i+1; j < NDISKS; j++)
+					err += test_disks(i, j);
 		}
 		printf("\n");
 	}
@@ -99,5 +117,8 @@ int main(int argc, char *argv[])
 	/* Pick the best algorithm test */
 	raid6_select_algo();
 
-	return 0;
+	if (err)
+		printf("\n*** ERRORS FOUND ***\n");
+
+	return err;
 }
_

Patches currently in -mm which might be from hpa@zytor.com are

git-kvm.patch
git-x86.patch
x86-boot-use-e820-memory-map-on-efi-32-platform.patch
drivers-char-tty_ioc-remove-pty_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
