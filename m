From: akpm@linux-foundation.org
Subject: + mm-convert-i_mmap_mutex-to-rwsem-fix.patch added to -mm tree
Date: Mon, 10 Nov 2014 14:24:31 -0800
Message-ID: <54613b1f.A2fYX32JT3rJ7F5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaKJWYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert i_mmap_mutex to rwsem fix
has been added to the -mm tree.  Its filename is
     mm-convert-i_mmap_mutex-to-rwsem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-i_mmap_mutex-to-rwsem-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-i_mmap_mutex-to-rwsem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-lockless-page-counters-fix-2.patch
mm-convert-i_mmap_mutex-to-rwsem-fix.patch
gcov-enable-gcov_profile_all-from-arch-kconfigs.patch
linux-next.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
kernel-forkc-export-kernel_thread-to-modules.patch

