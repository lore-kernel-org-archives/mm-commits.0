From: akpm@linux-foundation.org
Subject: +
 ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:29:03 -0700
Message-ID: <57bf631f.5vog3i3tK4LGG5Ae%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58811 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcHYVhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch

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
Subject: ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes

ERROR: do not initialise globals to NULL
#168: FILE: security/integrity/ima/ima_template.c:188:
+void *kexec_buffer = NULL;

ERROR: do not initialise globals to 0
#169: FILE: security/integrity/ima/ima_template.c:189:
+size_t kexec_buffer_size = 0;

ERROR: do not initialise globals to 0
#172: FILE: security/integrity/ima/ima_template.c:192:
+unsigned long kexec_buffer_load_addr = 0;

total: 3 errors, 0 warnings, 196 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ima-demonstration-code-for-kexec-buffer-passing.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_template.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN security/integrity/ima/ima_template.c~ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes
+++ a/security/integrity/ima/ima_template.c
@@ -185,11 +185,11 @@ static int template_desc_init_fields(con
 }
 
 #ifdef CONFIG_KEXEC_FILE
-void *kexec_buffer = NULL;
-size_t kexec_buffer_size = 0;
+void *kexec_buffer;
+size_t kexec_buffer_size;
 
 /* Physical address of the measurement buffer in the next kernel. */
-unsigned long kexec_buffer_load_addr = 0;
+unsigned long kexec_buffer_load_addr;
 
 /*
  * Called during reboot. IMA can add here new events that were generated after
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

