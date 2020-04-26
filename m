From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-support-debug_wx-fix.patch added to -mm tree
Date: Sat, 25 Apr 2020 18:06:06 -0700
Message-ID: <20200426010606.nSeK4wmZz%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZBGI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 21:06:08 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: riscv-support-debug_wx-fix
has been added to the -mm tree.  Its filename is
     riscv-support-debug_wx-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/riscv-support-debug_wx-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/riscv-support-debug_wx-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: riscv-support-debug_wx-fix

replace macros with C

Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/ptdump.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/ptdump.h~riscv-support-debug_wx-fix
+++ a/arch/riscv/include/asm/ptdump.h
@@ -9,9 +9,14 @@
 void ptdump_check_wx(void);
 
 #ifdef CONFIG_DEBUG_WX
-#define debug_checkwx() ptdump_check_wx()
+static inline void debug_checkwx(void)
+{
+	ptdump_check_wx();
+}
 #else
-#define debug_checkwx() do { } while (0)
+static inline void debug_checkwx(void)
+{
+}
 #endif
 
 #endif /* _ASM_RISCV_PTDUMP_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
