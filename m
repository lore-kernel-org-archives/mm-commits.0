Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967A25782A
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917796; cv=none; b=LTxrsbPfw6YARhET4ayf26fBKVNTn55wEGI/6rKx0lComZe5CAYMejM0/mvNCPg4Rrhe1gssTmYzp7pfzHSmulTPFz22IZ2zHQkr+XceC19oDKDn6UJwCUiS+RjZ5tMot2ok2oFxt2c49kz9p5Mp/XB1qaRtW2G/UwpW0oVxEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917796; c=relaxed/simple;
	bh=7v7l6ilWK6HA+D8YXTyO7pA2dFp4TchjcDg3XmwS3/A=;
	h=Date:To:From:Subject:Message-Id; b=dv62UZwCtb0cXAbOOThCjGMT09ev+168FsQ+ti+yex2gUpGokGB4MOr1bqZ/cGltgSGVnUZvtYUv3NM/tapkFhjqpn/pXMYNUGHdx/MOLkeCnABSjbpNu+q2x7mjf+YoADFRf9AVemrvwU9fMtwRNXnxws4wOCg65cSlLkO+HgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c1ER4WHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c1ER4WHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC4AC4CEF7;
	Tue, 31 Mar 2026 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917796;
	bh=7v7l6ilWK6HA+D8YXTyO7pA2dFp4TchjcDg3XmwS3/A=;
	h=Date:To:From:Subject:From;
	b=c1ER4WHrdVGFNi/ChId57OesnsXagPxqd4g0ReW15kldMFvmQlhSs5gkbb+qBx/hj
	 gvPYBiaLIjWeU50MgOMT1GuHVfqfqfn2ebr+2UvjWHtB4ScWAp+gtxdiH/hQgx290s
	 C3GEEe+1/sXxuhiZFgC55QRNvOYR4+EDFAq5CW8s=
Date: Mon, 30 Mar 2026 17:43:15 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-afs-restore-mmap_prepare-implementation.patch removed from -mm tree
Message-Id: <20260331004316.5AC4AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: afs: restore mmap_prepare implementation
has been removed from the -mm tree.  Its filename was
     fs-afs-restore-mmap_prepare-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: fs: afs: restore mmap_prepare implementation
Date: Fri, 20 Mar 2026 22:39:36 +0000

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
of the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare is called
pre-merge, and may then be merged, nor that mmap_prepare can fail to map
due to an out of memory error.

This change was therefore since reverted.

Both of those are cases in which we should not be incrementing a reference
count.

With the newly added vm_ops->mapped callback available, we can simply
defer this operation to that callback which is only invoked once the
mapping is successfully in place (but not yet visible to userspace as the
mmap and VMA write locks are held).

This allows us to once again reimplement the .mmap_prepare implementation
for this file system.

Therefore add afs_mapped() to implement this callback for AFS, and remove
the code doing so in afs_mmap_prepare().

Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
consistent in how the vnode is accessed.

Link: https://lkml.kernel.org/r/ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/fs/afs/file.c~fs-afs-restore-mmap_prepare-implementation
+++ a/fs/afs/file.c
@@ -19,7 +19,7 @@
 #include <trace/events/netfs.h>
 #include "internal.h"
 
-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
+static int afs_file_mmap_prepare(struct vm_area_desc *desc);
 
 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
@@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(stru
 static void afs_vm_open(struct vm_area_struct *area);
 static void afs_vm_close(struct vm_area_struct *area);
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);
 
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -35,7 +37,7 @@ const struct file_operations afs_file_op
 	.llseek		= generic_file_llseek,
 	.read_iter	= afs_file_read_iter,
 	.write_iter	= netfs_file_write_iter,
-	.mmap		= afs_file_mmap,
+	.mmap_prepare	= afs_file_mmap_prepare,
 	.splice_read	= afs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= afs_fsync,
@@ -61,6 +63,7 @@ const struct address_space_operations af
 };
 
 static const struct vm_operations_struct afs_vm_ops = {
+	.mapped		= afs_mapped,
 	.open		= afs_vm_open,
 	.close		= afs_vm_close,
 	.fault		= filemap_fault,
@@ -492,34 +495,47 @@ static void afs_drop_open_mmap(struct af
 /*
  * Handle setting up a memory mapping on an AFS file.
  */
-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int afs_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	int ret;
 
-	afs_add_open_mmap(vnode);
+	ret = generic_file_mmap_prepare(desc);
+	if (ret)
+		return ret;
 
-	ret = generic_file_mmap(file, vma);
-	if (ret == 0)
-		vma->vm_ops = &afs_vm_ops;
-	else
-		afs_drop_open_mmap(vnode);
+	desc->vm_ops = &afs_vm_ops;
 	return ret;
 }
 
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
+	return 0;
+}
+
 static void afs_vm_open(struct vm_area_struct *vma)
 {
-	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
 }
 
 static void afs_vm_close(struct vm_area_struct *vma)
 {
-	afs_drop_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_drop_open_mmap(vnode);
 }
 
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
+	struct file *file = vmf->vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 
 	if (afs_check_validity(vnode))
 		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

