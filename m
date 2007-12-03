From: akpm@linux-foundation.org
Subject: + mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:04:16 -0800
Message-ID: <200712032304.lB3N4GT5022153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbXLCXE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, a.p.zijlstra@chello.nl


The patch titled
     mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init
has been added to the -mm tree.  Its filename is
     mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init
From: Denis Cheng <crquan@gmail.com>

this call should use the array index j, not i:

	--- mm/backing-dev.c.orig	2007-12-02 19:42:57.000000000 +0800
	+++ mm/backing-dev.c	2007-12-02 19:43:14.000000000 +0800
	@@ -22,7 +22,7 @@ int bdi_init(struct backing_dev_info *bd
		if (err) {
	 err:
			for (j = 0; j < i; j++)
	-			percpu_counter_destroy(&bdi->bdi_stat[i]);
	+			percpu_counter_destroy(&bdi->bdi_stat[j]);
		}

		return err;

but with this approach, just one int i is enough, int j is not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/backing-dev.c~mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init mm/backing-dev.c
--- a/mm/backing-dev.c~mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init
+++ a/mm/backing-dev.c
@@ -7,7 +7,7 @@
 
 int bdi_init(struct backing_dev_info *bdi)
 {
-	int i, j;
+	int i;
 	int err;
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
@@ -21,7 +21,7 @@ int bdi_init(struct backing_dev_info *bd
 
 	if (err) {
 err:
-		for (j = 0; j < i; j++)
+		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
 	}
 
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch
git-cryptodev.patch
