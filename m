From: akpm@linux-foundation.org
Subject: +
 prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch added to
 -mm tree
Date: Wed, 27 Aug 2014 12:35:53 -0700
Message-ID: <53fe3319.BM/C8EEjqTe+fKtM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:39650 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964959AbaH0Tfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 15:35:54 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so120089oac.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 12:35:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: return -EFAULT on auxv fetching failure
has been added to the -mm tree.  Its filename is
     prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

x86mm-fix-pte_special-versus-pte_numa.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch

