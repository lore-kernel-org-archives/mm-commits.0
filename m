Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333E25782A;
	Tue, 31 Mar 2026 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917795; cv=none; b=UKfXn7uNn7oH9M6KIr74tGOtAuQR3hWrT3YIdhAfk8PrDXlbqaoYrPMlR8nEn0t7Pw9uiAWT8SbAvEBhPSFRewM69t2fXVTF3RQXGgW+Sw7Tn/s5RLtSnqO5JP4NeUVS9euqH/zV02lV2sPsyPc80DWmhuESt2gsqAqpXdbqM6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917795; c=relaxed/simple;
	bh=2OQu86adnHs7+CTlKHyWbq1cGGMulu4wjfOYgcgONyg=;
	h=Date:To:From:Subject:Message-Id; b=SK6XELo7xhlMsTm+CgjiOiiR8Fno4WHbRKDUBjUXBSpNkNmq8wKOE04LsMvozVWYf5rKGYi4lKvoNT9+HTNP7PsOoXbU2SNlYiTzi25pb/PoP1HaW0+VKAgwCQnlFzI45YPvBW55D6h5xsLkSN4AnnCNUGkFAph+NF/4bpYi29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLKKsBjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLKKsBjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B8AC4CEF7;
	Tue, 31 Mar 2026 00:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917794;
	bh=2OQu86adnHs7+CTlKHyWbq1cGGMulu4wjfOYgcgONyg=;
	h=Date:To:From:Subject:From;
	b=QLKKsBjwH/ewdaRhgOlkMZL0XoyYW8WhMWaD3r/Z73RVnK8Z57kbGleZt4CcoWfDA
	 BEX9uvapG33TUUbVcZ2YYWMYcRW7d0dTT6rruqLSUYr4tBnpu6T/Pz+lCTa4TN0C6/
	 Z7zrGvUrLSF7zoLLfX56bF/xLIxb1USZFOSKxhBM=
Date: Mon, 30 Mar 2026 17:43:14 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-afs-revert-mmap_prepare-change.patch removed from -mm tree
Message-Id: <20260331004314.B2B8AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: afs: revert mmap_prepare() change
has been removed from the -mm tree.  Its filename was
     fs-afs-revert-mmap_prepare-change.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: fs: afs: revert mmap_prepare() change
Date: Fri, 20 Mar 2026 22:39:35 +0000

Partially reverts commit 9d5403b1036c ("fs: convert most other
generic_file_*mmap() users to .mmap_prepare()").

This is because the .mmap invocation establishes a refcount, but
.mmap_prepare is called at a point where a merge or an allocation failure
might happen after the call, which would leak the refcount increment.

Functionality is being added to permit the use of .mmap_prepare in this
case, but in the interim, we need to fix this.

Link: https://lkml.kernel.org/r/08804c94e39d9102a3a8fbd12385e8aa079ba1d3.1774045440.git.ljs@kernel.org
Fixes: 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to .mmap_prepare()")
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
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/afs/file.c~fs-afs-revert-mmap_prepare-change
+++ a/fs/afs/file.c
@@ -19,7 +19,7 @@
 #include <trace/events/netfs.h>
 #include "internal.h"
 
-static int afs_file_mmap_prepare(struct vm_area_desc *desc);
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
 
 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
@@ -35,7 +35,7 @@ const struct file_operations afs_file_op
 	.llseek		= generic_file_llseek,
 	.read_iter	= afs_file_read_iter,
 	.write_iter	= netfs_file_write_iter,
-	.mmap_prepare	= afs_file_mmap_prepare,
+	.mmap		= afs_file_mmap,
 	.splice_read	= afs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= afs_fsync,
@@ -492,16 +492,16 @@ static void afs_drop_open_mmap(struct af
 /*
  * Handle setting up a memory mapping on an AFS file.
  */
-static int afs_file_mmap_prepare(struct vm_area_desc *desc)
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(desc->file));
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	int ret;
 
 	afs_add_open_mmap(vnode);
 
-	ret = generic_file_mmap_prepare(desc);
+	ret = generic_file_mmap(file, vma);
 	if (ret == 0)
-		desc->vm_ops = &afs_vm_ops;
+		vma->vm_ops = &afs_vm_ops;
 	else
 		afs_drop_open_mmap(vnode);
 	return ret;
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

