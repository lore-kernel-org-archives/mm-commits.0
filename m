From: akpm@linux-foundation.org
Subject: - revoke-add-documentation.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:19 -0800
Message-ID: <200711261936.lAQJaJEk019297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224AbXKZTh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, ak@suse.de, alan@redhat.com, hch@lst.de, mtk-manpages@gmx.net, mm-commits@vger.kernel.org


The patch titled
     revoke: add documentation
has been removed from the -mm tree.  Its filename was
     revoke-add-documentation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke: add documentation
From: Pekka Enberg <penberg@cs.helsinki.fi>

This documents revoke file operation in Documentation/filesystems/vfs.txt.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN Documentation/filesystems/vfs.txt~revoke-add-documentation Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~revoke-add-documentation
+++ a/Documentation/filesystems/vfs.txt
@@ -780,6 +780,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
+	int (*revoke)(struct file *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -853,6 +854,10 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  revoke: called by revokeat(2) and frevoke(2) system calls to revoke access
+	  to an open file. This method must ensure that all currently blocked
+	  writes are flushed and reads will fail.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
