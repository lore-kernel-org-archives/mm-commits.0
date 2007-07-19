From: akpm@linux-foundation.org
Subject: - only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:50 -0700
Message-ID: <200707191959.l6JJxoxr019378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635AbXGSUAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mingo@elte.hu, nickpiggin@yahoo.com.au, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     only allow nonlinear vmas for ram backed filesystems
has been removed from the -mm tree.  Its filename was
     only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: only allow nonlinear vmas for ram backed filesystems
From: Miklos Szeredi <mszeredi@suse.cz>

page_mkclean() doesn't re-protect ptes for non-linear mappings, so a later
re-dirty through such a mapping will not generate a fault, PG_dirty will
not reflect the dirty state and the dirty count will be skewed.  This
implies that msync() is also currently broken for nonlinear mappings.

The easiest solution is to emulate remap_file_pages on non-linear mappings
with simple mmap() for non ram-backed filesystems.  Applications continue
to work (albeit slower), as long as the number of remappings remain below
the maximum vma count.

However all currently known real uses of non-linear mappings are for ram
backed filesystems, which this patch doesn't affect.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN mm/fremap.c~only-allow-nonlinear-vmas-for-ram-backed-filesystems mm/fremap.c
--- a/mm/fremap.c~only-allow-nonlinear-vmas-for-ram-backed-filesystems
+++ a/mm/fremap.c
@@ -181,6 +181,25 @@ asmlinkage long sys_remap_file_pages(uns
 			goto retry;
 		}
 		mapping = vma->vm_file->f_mapping;
+		/*
+		 * page_mkclean doesn't work on nonlinear vmas, so if
+		 * dirty pages need to be accounted, emulate with linear
+		 * vmas.
+		 */
+		if (mapping_cap_account_dirty(mapping)) {
+			unsigned long addr;
+
+			flags &= MAP_NONBLOCK;
+			addr = mmap_region(vma->vm_file, start, size,
+					flags, vma->vm_flags, pgoff, 1);
+			if (IS_ERR_VALUE(addr)) {
+				err = addr;
+			} else {
+				BUG_ON(addr != start);
+				err = 0;
+			}
+			goto out;
+		}
 		spin_lock(&mapping->i_mmap_lock);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
fuse-convert-to-new-aops.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
