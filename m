From: akpm@linux-foundation.org
Subject: - mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:43 -0800
Message-ID: <200712080128.lB81ShwB013350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbXLHB3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init
has been removed from the -mm tree.  Its filename was
     mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init
From: Denis Cheng <crquan@gmail.com>

this call should use the array index j, not i.  But with this approach, just
one int i is enough, int j is not needed.

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
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
