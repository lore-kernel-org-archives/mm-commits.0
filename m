From: akpm@linux-foundation.org
Subject: - check-for-null-vfsmount-in-dentry_open.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:05 -0700
Message-ID: <200803261840.m2QIe5x1028631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760603AbYCZSkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     check for null vfsmount in dentry_open()
has been removed from the -mm tree.  Its filename was
     check-for-null-vfsmount-in-dentry_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: check for null vfsmount in dentry_open()
From: Dave Hansen <haveblue@us.ibm.com>

Make sure no-one calls dentry_open with a NULL vfsmount argument and crap out
with a stacktrace otherwise.  A NULL file->f_vfsmnt has always been
problematic, but with the per-mount r/o tracking we can't accept anymore at
all.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/open.c~check-for-null-vfsmount-in-dentry_open fs/open.c
--- a/fs/open.c~check-for-null-vfsmount-in-dentry_open
+++ a/fs/open.c
@@ -903,6 +903,18 @@ struct file *dentry_open(struct dentry *
 	int error;
 	struct file *f;
 
+	/*
+	 * We must always pass in a valid mount pointer.   Historically
+	 * callers got away with not passing it, but we must enforce this at
+	 * the earliest possible point now to avoid strange problems deep in the
+	 * filesystem stack.
+	 */
+	if (!mnt) {
+		printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
+		dump_stack();
+		return ERR_PTR(-EINVAL);
+	}
+
 	error = -ENFILE;
 	f = get_empty_filp();
 	if (f == NULL) {
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

