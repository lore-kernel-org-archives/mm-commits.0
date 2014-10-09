From: akpm@linux-foundation.org
Subject: [folded-merged]
 prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch removed
 from -mm tree
Date: Thu, 09 Oct 2014 13:37:49 -0700
Message-ID: <5436f21d.uSS6yEXYBaWeVi3s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: return -EFAULT on auxv fetching failure
has been removed from the -mm tree.  Its filename was
     prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch

This patch was dropped because it was folded into prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: prctl: return -EFAULT on auxv fetching failure

Dan reported that returning bytes left if copy_from_user failed
is a bad option, return traditional -EFAULT instead.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/sys.c~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2 kernel/sys.c
--- a/kernel/sys.c~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2
+++ a/kernel/sys.c
@@ -1809,11 +1809,10 @@ static int prctl_set_mm_map(int opt, con
 
 	if (prctl_map.auxv_size) {
 		memset(user_auxv, 0, sizeof(user_auxv));
-		error = copy_from_user(user_auxv,
-				       (const void __user *)prctl_map.auxv,
-				       prctl_map.auxv_size);
-		if (error)
-			return error;
+		if (copy_from_user(user_auxv,
+				   (const void __user *)prctl_map.auxv,
+				   prctl_map.auxv_size))
+			return -EFAULT;
 
 		/* Last entry must be AT_NULL as specification requires */
 		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch

