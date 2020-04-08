From: akpm@linux-foundation.org
Subject: [merged]
 mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:59:27 -0700
Message-ID: <20200408015927.EDSy1UKat%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB72 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/shmem.c: clean code by removing unnecessary assignment
has been removed from the -mm tree.  Its filename was
     mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/shmem.c: clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'error' but the variable was never
read before reassignemnt later.  So the assignment can be removed.

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
@@ -3120,12 +3120,9 @@ static int shmem_symlink(struct inode *d
 
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
