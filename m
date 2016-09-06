From: akpm@linux-foundation.org
Subject: +
 powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch added to -mm tree
Date: Tue, 06 Sep 2016 12:17:09 -0700
Message-ID: <57cf1635.x7x1nHHs5jsf4Su7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57919 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933347AbcIFTRK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 15:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-purgatory-for-kexec_file_load-implementation-fix
has been added to the -mm tree.  Its filename is
     powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch

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
Subject: powerpc-add-purgatory-for-kexec_file_load-implementation-fix

The change below to arch/powerpc/purgatory/Makefile fixes the cross build
from ppc64 BE to ppc64 LE.

I also noticed that building the purgatory during archprepare is not necessary,
so I also made the change below to arch/powerpc/Makefile.

I'm preparing a v8 of the kexec_file_load implementation for powerpc series
with those changes and will send it shortly.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile           |    3 ---
 arch/powerpc/purgatory/Makefile |    8 +++++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation-fix arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation-fix
+++ a/arch/powerpc/Makefile
@@ -378,9 +378,6 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 archprepare: checkbin
-ifeq ($(CONFIG_KEXEC_FILE),y)
-	$(Q)$(MAKE) $(build)=arch/powerpc/purgatory arch/powerpc/purgatory/kexec-purgatory.c
-endif
 
 # Use the file '.tmp_gas_check' for binutils tests, as gas won't output
 # to stdout and these checks are run even on install targets.
diff -puN arch/powerpc/purgatory/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation-fix arch/powerpc/purgatory/Makefile
--- a/arch/powerpc/purgatory/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation-fix
+++ a/arch/powerpc/purgatory/Makefile
@@ -23,10 +23,12 @@ KBUILD_AFLAGS := -fno-exceptions -msoft-
 		-D__ASSEMBLY__
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
-KBUILD_CFLAGS += $(call cc-option,-mabi=elfv2,$(call cc-option,-mcall-aixdesc))
-KBUILD_AFLAGS += $(call cc-option,-mabi=elfv2)
+KBUILD_CFLAGS += $(call cc-option,-mabi=elfv2,$(call cc-option,-mcall-aixdesc)) \
+		-mlittle-endian
+KBUILD_AFLAGS += $(call cc-option,-mabi=elfv2) -mlittle-endian
 else
-KBUILD_CFLAGS += $(call cc-option,-mcall-aixdesc)
+KBUILD_CFLAGS += $(call cc-option,-mcall-aixdesc) -mbig-endian
+KBUILD_AFLAGS += -mbig-endian
 endif
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
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
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

