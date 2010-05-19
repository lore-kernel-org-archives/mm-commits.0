From: akpm@linux-foundation.org
Subject: [merged] fs-sysv-dereferencing-err_ptr.patch removed from -mm tree
Date: Wed, 19 May 2010 10:32:01 -0400
Message-ID: <201005191733.o4JHXRct025821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab0ESRdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/sysv: dereferencing ERR_PTR()
has been removed from the -mm tree.  Its filename was
     fs-sysv-dereferencing-err_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/sysv: dereferencing ERR_PTR()
From: Dan Carpenter <error27@gmail.com>

Move the dir_put_page() inside the if condition so we don't dereference
"page", if it's an ERR_PTR().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysv/dir.c~fs-sysv-dereferencing-err_ptr fs/sysv/dir.c
--- a/fs/sysv/dir.c~fs-sysv-dereferencing-err_ptr
+++ a/fs/sysv/dir.c
@@ -164,8 +164,8 @@ struct sysv_dir_entry *sysv_find_entry(s
 							name, de->name))
 					goto found;
 			}
+			dir_put_page(page);
 		}
-		dir_put_page(page);
 
 		if (++n >= npages)
 			n = 0;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
include-linux-gfph-spelling-fixes.patch
include-linux-gfph-fix-coding-style.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

