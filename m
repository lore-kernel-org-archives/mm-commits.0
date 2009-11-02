From: akpm@linux-foundation.org
Subject: [merged] nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch removed from -mm tree
Date: Mon, 02 Nov 2009 12:45:23 -0800
Message-ID: <200911022045.nA2KjNYT001325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932387AbZKBUqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 15:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, rgetz@blackfin.uclinux.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nommu: don't pass NULL pointers to fput() in do_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     nommu-dont-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
frv-duplicate-output_buffer-of-e03.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

