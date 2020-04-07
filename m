From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 073/166] mm/shmem.c: clean code by removing
 unnecessary assignment
Date: Mon, 06 Apr 2020 20:07:54 -0700
Message-ID: <20200407030754.1PbjME_4J%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:57 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

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
