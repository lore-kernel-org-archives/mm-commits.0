From: akpm@linux-foundation.org
Subject: + only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:56:14 -0700
Message-ID: <200704070056.l370uE9L024219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796AbXDGA43 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mingo@elte.hu, nickpiggin@yahoo.com.au, wli@holomorphy.com


The patch titled
     only allow nonlinear vmas for ram backed filesystems
has been added to the -mm tree.  Its filename is
     only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/fremap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/fremap.c~only-allow-nonlinear-vmas-for-ram-backed-filesystems mm/fremap.c
--- a/mm/fremap.c~only-allow-nonlinear-vmas-for-ram-backed-filesystems
+++ a/mm/fremap.c
@@ -181,6 +181,24 @@ asmlinkage long sys_remap_file_pages(uns
 			goto retry;
 		}
 		mapping = vma->vm_file->f_mapping;
+		/*
+		 * page_mkclean doesn't work on nonlinear vmas, so if dirty
+		 * pages need to be accounted, emulate with linear vmas.
+		 */
+		if (mapping_cap_account_dirty(mapping)) {
+			unsigned long addr;
+
+			flags &= MAP_NONBLOCK;
+			addr = mmap_region(vma->vm_file, start, size, flags,
+					   vma->vm_flags, pgoff, 1);
+			if (IS_ERR_VALUE(addr))
+				err = addr;
+			else {
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

fuse-validate-rootmode-mount-option.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
add-file-position-info-to-proc-fix.patch
consolidate-generic_writepages-and-mpage_writepages.patch
