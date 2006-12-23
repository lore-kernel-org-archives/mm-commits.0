From: akpm@osdl.org
Subject: - fdtable-provide-free_fdtable-wrapper.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:39 -0800
Message-ID: <200612230754.kBN7sdo4010230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbWLWHyu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     fdtable: Provide free_fdtable() wrapper
has been removed from the -mm tree.  Its filename was
     fdtable-provide-free_fdtable-wrapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdtable: Provide free_fdtable() wrapper
From: Vadim Lobanov <vlobanov@speakeasy.net>

Christoph Hellwig has expressed concerns that the recent fdtable changes
expose the details of the RCU methodology used to release no-longer-used
fdtable structures to the rest of the kernel.  The trivial patch below
addresses these concerns by introducing the appropriate free_fdtable()
calls, which simply wrap the release RCU usage.  Since free_fdtable() is a
one-liner, it makes sense to promote it to an inline helper.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c            |    2 +-
 include/linux/file.h |    5 +++++
 kernel/exit.c        |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/file.c~fdtable-provide-free_fdtable-wrapper fs/file.c
--- a/fs/file.c~fdtable-provide-free_fdtable-wrapper
+++ a/fs/file.c
@@ -206,7 +206,7 @@ static int expand_fdtable(struct files_s
 		copy_fdtable(new_fdt, cur_fdt);
 		rcu_assign_pointer(files->fdt, new_fdt);
 		if (cur_fdt->max_fds > NR_OPEN_DEFAULT)
-			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
+			free_fdtable(cur_fdt);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
 		free_fdarr(new_fdt);
diff -puN include/linux/file.h~fdtable-provide-free_fdtable-wrapper include/linux/file.h
--- a/include/linux/file.h~fdtable-provide-free_fdtable-wrapper
+++ a/include/linux/file.h
@@ -80,6 +80,11 @@ extern int expand_files(struct files_str
 extern void free_fdtable_rcu(struct rcu_head *rcu);
 extern void __init files_defer_init(void);
 
+static inline void free_fdtable(struct fdtable *fdt)
+{
+	call_rcu(&fdt->rcu, free_fdtable_rcu);
+}
+
 static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
 {
 	struct file * file = NULL;
diff -puN kernel/exit.c~fdtable-provide-free_fdtable-wrapper kernel/exit.c
--- a/kernel/exit.c~fdtable-provide-free_fdtable-wrapper
+++ a/kernel/exit.c
@@ -468,7 +468,7 @@ void fastcall put_files_struct(struct fi
 		fdt = files_fdtable(files);
 		if (fdt != &files->fdtab)
 			kmem_cache_free(files_cachep, files);
-		call_rcu(&fdt->rcu, free_fdtable_rcu);
+		free_fdtable(fdt);
 	}
 }
 
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

origin.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

