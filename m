From: akpm@linux-foundation.org
Subject: +
 kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix.patch added to -mm tree
Date: Tue, 18 Oct 2016 16:20:11 -0700
Message-ID: <5806ae2b.7qmqc0puOFJK59Tz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbcJRXUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 19:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: arch/powerpc/kernel/module_64.c:463: undefined reference to `.elf64_apply_relocate_add'
has been added to the -mm tree.  Its filename is
     kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix.patch

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
Subject: Re: arch/powerpc/kernel/module_64.c:463: undefined reference to `.elf64_apply_relocate_add'

Am Samstag, 15. Oktober 2016, 23:14:20 BRST schrieb kbuild test robot:
>    arch/powerpc/kernel/built-in.o: In function `apply_relocate_add':
> >> arch/powerpc/kernel/module_64.c:463: undefined reference to
> >> `.elf64_apply_relocate_add'

This is because my kexec_file_load patches lost a few hunks.
The patch below fixes the issue.

Many of the problems with this patch series stem from the fact that it
conflicted with the s/CONFIG_WORD_SIZE/BITS/ change that went into v4.9-rc1.
I will post a new version rebased on top of v4.9-rc1, this should get things
back on track. I'll have them ready by tomorrow.

Thank you for your patience.

index 3bf8dc6ccf7d..6ff8927a8a05 100644
Link: http://lkml.kernel.org/r/1526295.DW58yBHL0y@morokweng

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile           |    8 +++++++-
 arch/powerpc/kernel/machine_kexec_64.c |   10 ++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/Makefile~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix
+++ a/arch/powerpc/kernel/Makefile
@@ -107,8 +107,14 @@ pci64-$(CONFIG_PPC64)		+= pci_dn.o pci-h
 obj-$(CONFIG_PCI)		+= pci_$(BITS).o $(pci64-y) \
 				   pci-common.o pci_of_scan.o
 obj-$(CONFIG_PCI_MSI)		+= msi.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o \
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o crash.o \
 				   machine_kexec_$(BITS).o
+obj-$(CONFIG_KEXEC_FILE)	+= kexec_elf_$(BITS).o
+
+ifeq ($(CONFIG_HAVE_IMA_KEXEC)$(CONFIG_IMA),yy)
+obj-y				+= ima_kexec.o
+endif
+
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -31,6 +31,16 @@
 #include <asm/smp.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/asm-prototypes.h>
+#include <asm/kexec_elf_64.h>
+#include <asm/ima.h>
+
+#define SLAVE_CODE_SIZE		256
+
+#ifdef CONFIG_KEXEC_FILE
+static struct kexec_file_ops *kexec_file_loaders[] = {
+	&kexec_elf64_ops,
+};
+#endif
 
 int default_machine_kexec_prepare(struct kimage *image)
 {
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer-fix.patch
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
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

