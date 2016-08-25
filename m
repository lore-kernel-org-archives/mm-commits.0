From: akpm@linux-foundation.org
Subject: +
 powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch added to -mm tree
Date: Thu, 25 Aug 2016 14:28:55 -0700
Message-ID: <57bf6317.EFY5poRfNqUSKXJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58815 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbcHYVhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes

WARNING: line over 80 characters
#111: FILE: arch/powerpc/kernel/elf_util_64.c:141:
+				pr_err("Symbol '%s' in common section.\n", name);

WARNING: else is not generally useful after a break or return
#121: FILE: arch/powerpc/kernel/elf_util_64.c:151:
+				return -ENOEXEC;
+			} else {

WARNING: line over 80 characters
#143: FILE: arch/powerpc/kernel/elf_util_64.c:174:
+			*(uint32_t *)location = value - (uint32_t)(uint64_t)location;

WARNING: line over 80 characters
#172: FILE: arch/powerpc/kernel/elf_util_64.c:249:
+				pr_err("%s: REL14 %li out of range!\n", obj_name,

total: 0 errors, 4 warnings, 196 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/elf_util_64.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/elf_util_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes arch/powerpc/kernel/elf_util_64.c
--- a/arch/powerpc/kernel/elf_util_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes
+++ a/arch/powerpc/kernel/elf_util_64.c
@@ -138,7 +138,8 @@ int elf64_apply_relocate_add(const struc
 				pr_err("Undefined symbol: %s\n", name);
 				return -ENOEXEC;
 			} else if (sym->st_shndx == SHN_COMMON) {
-				pr_err("Symbol '%s' in common section.\n", name);
+				pr_err("Symbol '%s' in common section.\n",
+				       name);
 				return -ENOEXEC;
 			}
 		}
@@ -171,7 +172,8 @@ int elf64_apply_relocate_add(const struc
 			break;
 
 		case R_PPC64_REL32:
-			*(uint32_t *)location = value - (uint32_t)(uint64_t)location;
+			*(uint32_t *)location =
+				value - (uint32_t)(uint64_t)location;
 			break;
 
 		case R_PPC64_TOC:
@@ -246,8 +248,8 @@ int elf64_apply_relocate_add(const struc
 			/* Convert value to relative */
 			value -= address;
 			if (value + 0x8000 > 0xffff || (value & 3) != 0) {
-				pr_err("%s: REL14 %li out of range!\n", obj_name,
-				       (long int)value);
+				pr_err("%s: REL14 %li out of range!\n",
+				       obj_name, (long int)value);
 				return -ENOEXEC;
 			}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch

