From: akpm@linux-foundation.org
Subject: +
 mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch added to -mm
 tree
Date: Mon, 02 Mar 2020 14:44:16 -0800
Message-ID: <20200302224416.VOSby5DFg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgCBWoR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/shmem.c: Clean code by removing unnecessary assignment
has been added to the -mm tree.  Its filename is
     mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: mateusznosek0@gmail.com
Subject: mm/shmem.c: Clean code by removing unnecessary assignment


Previously 0 was assigned to variable 'error'
but the variable was never read before reassignemnt later.
So the assignment can be removed.

Link: http://lkml.kernel.org/r/20200301152832.24595-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmemc-clean-code-by-removing-unnecessary-assignment
+++ a/mm/shmem.c
@@ -3116,12 +3116,9 @@ static int shmem_symlink(struct inode *d
 
 	error = security_inode_init_security(inode, dir, &dentry->d_name,
 					     shmem_initxattrs, NULL);
-	if (error) {
-		if (error != -EOPNOTSUPP) {
-			iput(inode);
-			return error;
-		}
-		error = 0;
+	if (error && error != -EOPNOTSUPP) {
+		iput(inode);
+		return error;
 	}
 
 	inode->i_size = len-1;
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
