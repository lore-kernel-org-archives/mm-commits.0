From: akpm@linux-foundation.org
Subject: [merged] gru-support-contexts-with-zero-dsrs-or-cbrs.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:40 -0700
Message-ID: <200906182248.n5IMme06007809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbZFRWtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: support contexts with zero dsrs or cbrs
has been removed from the -mm tree.  Its filename was
     gru-support-contexts-with-zero-dsrs-or-cbrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: support contexts with zero dsrs or cbrs
From: Jack Steiner <steiner@sgi.com>

Support alocation of GRU contexts that contain zero DSR or CBR resources. 
Some instructions do not require DSR resources.  Contexts without CBR
resources are useful for diagnostics.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    6 ++----
 drivers/misc/sgi-gru/grumain.c |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-support-contexts-with-zero-dsrs-or-cbrs drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-support-contexts-with-zero-dsrs-or-cbrs
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -135,11 +135,9 @@ static int gru_create_new_context(unsign
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
-	if (req.data_segment_bytes == 0 ||
-				req.data_segment_bytes > max_user_dsr_bytes)
+	if (req.data_segment_bytes > max_user_dsr_bytes)
 		return -EINVAL;
-	if (!req.control_blocks || !req.maximum_thread_count ||
-				req.control_blocks > max_user_cbrs)
+	if (req.control_blocks > max_user_cbrs || !req.maximum_thread_count)
 		return -EINVAL;
 
 	if (!(req.options & GRU_OPT_MISS_MASK))
diff -puN drivers/misc/sgi-gru/grumain.c~gru-support-contexts-with-zero-dsrs-or-cbrs drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-support-contexts-with-zero-dsrs-or-cbrs
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -150,7 +150,7 @@ static unsigned long reserve_resources(u
 	unsigned long bits = 0;
 	int i;
 
-	do {
+	while (n--) {
 		i = find_first_bit(p, mmax);
 		if (i == mmax)
 			BUG();
@@ -158,7 +158,7 @@ static unsigned long reserve_resources(u
 		__set_bit(i, &bits);
 		if (idx)
 			*idx++ = i;
-	} while (--n);
+	}
 	return bits;
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

