From: akpm@osdl.org
Subject: - fdtable-delete-pointless-code-in-dup_fd.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:23 -0800
Message-ID: <200612130655.kBD6tN3d030635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbWLMGz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, dipankar@in.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fdtable: Delete pointless code in dup_fd()
has been removed from the -mm tree.  Its filename was
     fdtable-delete-pointless-code-in-dup_fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdtable: Delete pointless code in dup_fd()
From: Vadim Lobanov <vlobanov@speakeasy.net>

The dup_fd() function creates a new files_struct and fdtable embedded inside
that files_struct, and then possibly expands the fdtable using expand_files().

The out_release error path is invoked when expand_files() returns an error
code.  However, when this attempt to expand fails, the fdtable is left in its
original embedded form, so it is pointless to try to free the associated
fdarray and fdsets.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~fdtable-delete-pointless-code-in-dup_fd kernel/fork.c
--- a/kernel/fork.c~fdtable-delete-pointless-code-in-dup_fd
+++ a/kernel/fork.c
@@ -711,8 +711,10 @@ static struct files_struct *dup_fd(struc
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
 
-	memcpy(new_fdt->open_fds->fds_bits, old_fdt->open_fds->fds_bits, open_files/8);
-	memcpy(new_fdt->close_on_exec->fds_bits, old_fdt->close_on_exec->fds_bits, open_files/8);
+	memcpy(new_fdt->open_fds->fds_bits,
+		old_fdt->open_fds->fds_bits, open_files/8);
+	memcpy(new_fdt->close_on_exec->fds_bits,
+		old_fdt->close_on_exec->fds_bits, open_files/8);
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
@@ -745,14 +747,11 @@ static struct files_struct *dup_fd(struc
 		memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
 	}
 
-out:
 	return newf;
 
 out_release:
-	free_fdset (new_fdt->close_on_exec, new_fdt->max_fdset);
-	free_fdset (new_fdt->open_fds, new_fdt->max_fdset);
-	free_fd_array(new_fdt->fd, new_fdt->max_fds);
 	kmem_cache_free(files_cachep, newf);
+out:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

origin.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

