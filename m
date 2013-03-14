From: akpm@linux-foundation.org
Subject: + mm-fremapc-fix-possible-oops-on-error-path.patch added to -mm tree
Date: Thu, 14 Mar 2013 16:47:48 -0700
Message-ID: <20130314234748.758085A4158@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46208 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3CNXrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 19:47:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so280187vbi.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 16:47:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, tt.rantala@gmail.com


The patch titled
     Subject: mm/fremap.c: fix possible oops on error path
has been added to the -mm tree.  Its filename is
     mm-fremapc-fix-possible-oops-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm/fremap.c: fix possible oops on error path

The vm_flags introduced in 6d7825b10dbe ("mm/fremap.c: fix oops on error
path") is supposed to avoid a compiler warning about unitialized vm_flags
without changing the generated code.

However I am concerned that this is going to be very brittle, and fail
with some compiler versions. The failure could be either of:

- compiler could actually load vma->vm_flags before checking for the
  !vma condition, thus reintroducing the oops

- compiler could optimize out the !vma check, since the pointer just got
  dereferenced shortly before (so the compiler knows it can't be NULL!)

I propose reversing this part of the change and initializing vm_flags to 0
just to avoid the bogus uninitialized use warning.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/fremap.c~mm-fremapc-fix-possible-oops-on-error-path mm/fremap.c
--- a/mm/fremap.c~mm-fremapc-fix-possible-oops-on-error-path
+++ a/mm/fremap.c
@@ -129,7 +129,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	struct vm_area_struct *vma;
 	int err = -EINVAL;
 	int has_write_lock = 0;
-	vm_flags_t vm_flags;
+	vm_flags_t vm_flags = 0;
 
 	if (prot)
 		return err;
@@ -163,8 +163,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	 * and that the remapped range is valid and fully within
 	 * the single existing vma.
 	 */
-	vm_flags = vma->vm_flags;
-	if (!vma || !(vm_flags & VM_SHARED))
+	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
 	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-fremapc-fix-possible-oops-on-error-path.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-remove-free_area_cache.patch
mutex-subsystem-synchro-test-module.patch

