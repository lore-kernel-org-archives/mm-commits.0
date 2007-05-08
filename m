From: akpm@linux-foundation.org
Subject: + fs-use-path_walk-in-do_path_lookup.patch added to -mm tree
Date: Tue, 08 May 2007 13:55:30 -0700
Message-ID: <200705082056.l48KtU96001378@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032122AbXEHU6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, hch@infradead.org


The patch titled
     fs: use path_walk in do_path_lookup
has been added to the -mm tree.  Its filename is
     fs-use-path_walk-in-do_path_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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
fs-fix-indentation-in-do_path_lookup.patch
fs-use-path_walk-in-do_path_lookup.patch
