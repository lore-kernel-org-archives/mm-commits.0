From: akpm@linux-foundation.org
Subject: - reorder-struct-prop_local_single-to-remove-padding-on-64-bit-builds.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:48 -0700
Message-ID: <200808261845.m7QIjm4O021433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757562AbYHZSq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     reorder struct prop_local_single to remove padding on 64 bit builds
has been removed from the -mm tree.  Its filename was
     reorder-struct-prop_local_single-to-remove-padding-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reorder struct prop_local_single to remove padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

reorder structure to remove 8 bytes of padding on 64 bit builds

(also removes 8 bytes from task_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proportions.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/proportions.h~reorder-struct-prop_local_single-to-remove-padding-on-64-bit-builds include/linux/proportions.h
--- a/include/linux/proportions.h~reorder-struct-prop_local_single-to-remove-padding-on-64-bit-builds
+++ a/include/linux/proportions.h
@@ -104,8 +104,8 @@ struct prop_local_single {
 	 * snapshot of the last seen global state
 	 * and a lock protecting this state
 	 */
-	int shift;
 	unsigned long period;
+	int shift;
 	spinlock_t lock;		/* protect the snapshot state */
 };
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch

