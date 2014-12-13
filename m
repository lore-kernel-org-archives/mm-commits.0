From: akpm@linux-foundation.org
Subject: [folded-merged] mm-convert-i_mmap_mutex-to-rwsem-fix.patch
 removed from -mm tree
Date: Fri, 12 Dec 2014 16:38:38 -0800
Message-ID: <548b8a8e.dDiGU/7zJD+6p7vR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert i_mmap_mutex to rwsem fix
has been removed from the -mm tree.  Its filename was
     mm-convert-i_mmap_mutex-to-rwsem-fix.patch

This patch was dropped because it was folded into mm-convert-i_mmap_mutex-to-rwsem.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: convert i_mmap_mutex to rwsem fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/fremap.c~mm-convert-i_mmap_mutex-to-rwsem-fix mm/fremap.c
--- a/mm/fremap.c~mm-convert-i_mmap_mutex-to-rwsem-fix
+++ a/mm/fremap.c
@@ -238,13 +238,13 @@ get_write_lock:
 			}
 			goto out_freed;
 		}
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
 		vma_interval_tree_remove(vma, &mapping->i_mmap);
 		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		flush_dcache_mmap_unlock(mapping);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 	}
 
 	if (vma->vm_flags & VM_LOCKED) {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
sparc-hook-up-execveat-system-call-v10.patch
gcov-enable-gcov_profile_all-from-arch-kconfigs.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

