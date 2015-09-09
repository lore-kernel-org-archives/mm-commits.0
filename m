From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 15:09:52 -0700
Message-ID: <55f0ae30.lH9YQ+Mdkf/Vd0EH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbIIWJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, jwboyer@fedoraproject.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix
has been removed from the -mm tree.  Its filename was
     kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch

This patch was dropped because it was folded into kexec-split-kexec_file-syscall-code-to-kexec_filec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix

arch/x86/kernel/machine_kexec_64.c:381: error: conflicting types for 'arch_kimage_file_post_load_cleanup'                                                       include/linux/kexec.h:326: note: previous declaration of 'arch_kimage_file_post_load_cleanup' was here

Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kexec.h~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix
+++ a/include/linux/kexec.h
@@ -321,7 +321,7 @@ void crash_free_reserved_phys_range(unsi
 int __weak arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 					 unsigned long buf_len);
 void * __weak arch_kexec_kernel_image_load(struct kimage *image);
-void __weak arch_kimage_file_post_load_cleanup(struct kimage *image);
+int __weak arch_kimage_file_post_load_cleanup(struct kimage *image);
 int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 					unsigned long buf_len);
 int __weak arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

