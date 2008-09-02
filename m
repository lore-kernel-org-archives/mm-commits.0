From: akpm@linux-foundation.org
Subject: + drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test.patch added to -mm tree
Date: Tue, 02 Sep 2008 14:57:36 -0700
Message-ID: <200809022157.m82LvasO014790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbYIBV5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 17:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brunel@diku.dk, julia@diku.dk, rolandd@cisco.com


The patch titled
     drivers/infiniband/core: use a NULL test rather than an IS_ERR test
has been added to the -mm tree.  Its filename is
     drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drivers-infiniband-core-use-a-null-test-rather-than-an-is_err-test.patch

