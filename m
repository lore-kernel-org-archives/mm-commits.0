From: akpm@linux-foundation.org
Subject: + nommu-fix-sysv-shm-for-nommu.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:34:35 -0800
Message-ID: <201001142334.o0ENYZGt006394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab0ANXe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk


The patch titled
     nommu: fix SYSV SHM for NOMMU
has been added to the -mm tree.  Its filename is
     nommu-fix-sysv-shm-for-nommu.patch

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
Subject: nommu: fix SYSV SHM for NOMMU
From: David Howells <dhowells@redhat.com>

Commit c4caa778157dbbf04116f0ac2111e389b5cd7a29 ("file
->get_unmapped_area() shouldn't duplicate work of get_unmapped_area()")
broke SYSV SHM for NOMMU by taking away the pointer to
shm_get_unmapped_area() from shm_file_operations.

Put it back conditionally on CONFIG_MMU=n.

file->f_ops->get_unmapped_area() is used to find out the base address for a
mapping of a mappable chardev device or mappable memory-based file (such as a
ramfs file).  It needs to be called prior to file->f_ops->mmap() being called.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/shm.c~nommu-fix-sysv-shm-for-nommu ipc/shm.c
--- a/ipc/shm.c~nommu-fix-sysv-shm-for-nommu
+++ a/ipc/shm.c
@@ -298,6 +298,9 @@ static const struct file_operations shm_
 	.mmap		= shm_mmap,
 	.fsync		= shm_fsync,
 	.release	= shm_release,
+#ifndef CONFIG_MMU
+	.get_unmapped_area	= shm_get_unmapped_area,
+#endif
 };
 
 static const struct file_operations shm_file_operations_huge = {
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-fix-sysv-shm-for-nommu.patch
nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch
nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch
nommu-dont-need-get_unmapped_area-for-nommu.patch
nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch
nommu-fix-shared-mmap-after-truncate-shrinkage-problems.patch
kernel-credc-use-kmem_cache_free.patch
nfs-avoid-warnings-when-config_nfs_v4=n.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

