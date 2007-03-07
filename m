From: akpm@linux-foundation.org
Subject: + check_partition-fix-error-check.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:46:29 -0800
Message-ID: <200703070146.l271kTda016018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXCGBqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:46:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suzuki@in.ibm.com


The patch titled
     check_partition(): fix error check
has been added to the -mm tree.  Its filename is
     check_partition-fix-error-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: check_partition(): fix error check
From: suzuki <suzuki@in.ibm.com>

Fix inverted check introduced in 57881dd9df40b76dc7fc6a0d13fd75f337accb32 "Fix
check_partition routines".

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/check.c~check_partition-fix-error-check fs/partitions/check.c
--- a/fs/partitions/check.c~check_partition-fix-error-check
+++ a/fs/partitions/check.c
@@ -180,7 +180,7 @@ check_partition(struct gendisk *hd, stru
 	}
 	if (res > 0)
 		return state;
-	if (!err)
+	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
 	if (!res)
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

check_partition-fix-error-check.patch
