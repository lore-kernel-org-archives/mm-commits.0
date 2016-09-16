From: akpm@linux-foundation.org
Subject: +
 powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
 added to -mm tree
Date: Fri, 16 Sep 2016 16:33:59 -0700
Message-ID: <57dc8167.JBbUmEd7ORcGhbYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933782AbcIPXeA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix
has been added to the -mm tree.  Its filename is
     powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix

This patch causes a warning in GCC 4.6.3:

arch/powerpc/kernel/kexec_elf_64.c:211:6: error: 'initrd_load_addr' may be used uninitialized in this function [-Werror=uninitialized]
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/kernel/kexec_elf_64.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [sub-make] Error 2

Link: http://lkml.kernel.org/r/1931074.eWqeHQFLY5@hactar
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/kexec_elf_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/kexec_elf_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix arch/powerpc/kernel/kexec_elf_64.c
--- a/arch/powerpc/kernel/kexec_elf_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -153,7 +153,7 @@ void *elf64_load(struct kimage *image, c
 	int i, ret;
 	unsigned int fdt_size;
 	unsigned long kernel_load_addr, purgatory_load_addr;
-	unsigned long initrd_load_addr, fdt_load_addr, stack_top;
+	unsigned long initrd_load_addr = 0, fdt_load_addr, stack_top;
 	void *fdt;
 	const void *slave_code;
 	struct elfhdr ehdr;
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

