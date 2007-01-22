From: akpm@osdl.org
Subject: - cifs-remove-2-unneeded-kzalloc-casts.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:45:38 -0800
Message-ID: <200701222045.l0MKjcVU001487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbXAVUqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:46:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     CIFS: Remove 2 unneeded kzalloc casts
has been removed from the -mm tree.  Its filename was
     cifs-remove-2-unneeded-kzalloc-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CIFS: Remove 2 unneeded kzalloc casts
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to remove two unnecessary kzalloc casts.

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/cifs/misc.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/cifs/misc.c~cifs-remove-2-unneeded-kzalloc-casts fs/cifs/misc.c
--- a/fs/cifs/misc.c~cifs-remove-2-unneeded-kzalloc-casts
+++ a/fs/cifs/misc.c
@@ -71,9 +71,7 @@ sesInfoAlloc(void)
 {
 	struct cifsSesInfo *ret_buf;
 
-	ret_buf =
-	    (struct cifsSesInfo *) kzalloc(sizeof (struct cifsSesInfo),
-					   GFP_KERNEL);
+	ret_buf = kzalloc(sizeof (struct cifsSesInfo), GFP_KERNEL);
 	if (ret_buf) {
 		write_lock(&GlobalSMBSeslock);
 		atomic_inc(&sesInfoAllocCount);
@@ -109,9 +107,8 @@ struct cifsTconInfo *
 tconInfoAlloc(void)
 {
 	struct cifsTconInfo *ret_buf;
-	ret_buf =
-	    (struct cifsTconInfo *) kzalloc(sizeof (struct cifsTconInfo),
-					    GFP_KERNEL);
+	ret_buf = kzalloc(sizeof (struct cifsTconInfo),
+			  GFP_KERNEL);
 	if (ret_buf) {
 		write_lock(&GlobalSMBSeslock);
 		atomic_inc(&tconInfoAllocCount);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-cifs.patch
git-cpufreq.patch
git-dvb.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
