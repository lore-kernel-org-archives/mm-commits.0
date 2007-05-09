From: akpm@linux-foundation.org
Subject: - fs-use-path_walk-in-do_path_lookup.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:24 -0700
Message-ID: <200705092150.l49LoO5K002803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758485AbXEIVuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs: use path_walk in do_path_lookup
has been removed from the -mm tree.  Its filename was
     fs-use-path_walk-in-do_path_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: use path_walk in do_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Since path_walk sets the total_link_count to 0 and calls link_path_walk, we
can just call path_walk directly.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~fs-use-path_walk-in-do_path_lookup fs/namei.c
--- a/fs/namei.c~fs-use-path_walk-in-do_path_lookup
+++ a/fs/namei.c
@@ -1152,8 +1152,8 @@ static int fastcall do_path_lookup(int d
 
 		fput_light(file, fput_needed);
 	}
-	current->total_link_count = 0;
-	retval = link_path_walk(name, nd);
+
+	retval = path_walk(name, nd);
 out:
 	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
 				nd->dentry->d_inode))
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
