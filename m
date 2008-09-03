From: akpm@linux-foundation.org
Subject: - drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:12:12 -0700
Message-ID: <200809031612.m83GCCt3023827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbYICQMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brunel@diku.dk, julia@diku.dk, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     drivers/infiniband/core: use a NULL test rather than an IS_ERR test
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/infiniband/core: use a NULL test rather than an IS_ERR test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function ucma_alloc_multicast returns a NULL
pointer, but never returns an ERR pointer.  So after a call to this
function, an IS_ERR test should be replaced by a NULL test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match bad_is_err_test@
expression x, E;
@@

x = ucma_alloc_multicast(...)
... when != x = E
IS_ERR(x)
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/ucma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/core/ucma.c~drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c~drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test
+++ a/drivers/infiniband/core/ucma.c
@@ -904,8 +904,8 @@ static ssize_t ucma_join_multicast(struc
 
 	mutex_lock(&file->mut);
 	mc = ucma_alloc_multicast(ctx);
-	if (IS_ERR(mc)) {
-		ret = PTR_ERR(mc);
+	if (mc == NULL) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
_

Patches currently in -mm which might be from brunel@diku.dk are

origin.patch
linux-next.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch

