From: akpm@linux-foundation.org
Subject: + nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch added to -mm tree
Date: Fri, 30 Oct 2009 14:22:31 -0700
Message-ID: <200910302122.n9ULMVeC021066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932898AbZJ3VXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 17:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, rgetz@blackfin.uclinux.org, stable@kernel.org


The patch titled
     nommu: don't pass NULL pointers to fput() in do_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: don't pass NULL pointers to fput() in do_mmap_pgoff()
From: David Howells <dhowells@redhat.com>

Don't pass NULL pointers to fput() in the error handling paths of the
NOMMU do_mmap_pgoff() as it can't handle it.

The following can be used as a test program:

	int main() { static long long a[1024 * 1024 * 20] = { 0 }; return a;}

Without the patch, the code oopses in atomic_long_dec_and_test() as called
by fput() after the kernel complains that it can't allocate that big a
chunk of memory.  With the patch, the kernel just complains about the
allocation size and then the program segfaults during execve() as execve()
can't complete the allocation of all the new ELF program segments.

Reported-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/nommu.c~nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff mm/nommu.c
--- a/mm/nommu.c~nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1362,9 +1362,11 @@ share:
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
-	fput(region->vm_file);
+	if (region->vm_file)
+		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
-	fput(vma->vm_file);
+	if (vma->vm_file)
+		fput(vma->vm_file);
 	if (vma->vm_flags & VM_EXECUTABLE)
 		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
frv-duplicate-output_buffer-of-e03.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

