From: akpm@linux-foundation.org
Subject: [patch 14/14] mm: revert x86_64 and arm64 ELF_ET_DYN_BASE base
 changes
Date: Fri, 18 Aug 2017 15:16:31 -0700
Message-ID: <5997673f.OvQGxtz7fG3OR+tf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbdHRWQc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 18:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, hpa@zytor.com, kcc@google.com, mingo@elte.hu, stable@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com

From: Kees Cook <keescook@chromium.org>
Subject: mm: revert x86_64 and arm64 ELF_ET_DYN_BASE base changes

Moving the x86_64 and arm64 PIE base from 0x555555554000 to 0x000100000000
broke AddressSanitizer.  This is a partial revert of:

  eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE")
  02445990a96e ("arm64: move ELF_ET_DYN_BASE to 4GB / 4MB")

The AddressSanitizer tool has hard-coded expectations about where
executable mappings are loaded.  The motivation for changing the PIE base
in the above commits was to avoid the Stack-Clash CVEs that allowed
executable mappings to get too close to heap and stack.  This was mainly a
problem on 32-bit, but the 64-bit bases were moved too, in an effort to
proactively protect those systems (proofs of concept do exist that show
64-bit collisions, but other recent changes to fix stack accounting and
setuid behaviors will minimize the impact).

The new 32-bit PIE base is fine for ASan (since it matches the ET_EXEC
base), so only the 64-bit PIE base needs to be reverted to let x86 and
arm64 ASan binaries run again.  Future changes to the 64-bit PIE base on
these architectures can be made optional once a more dynamic method for
dealing with AddressSanitizer is found.  (e.g.  always loading PIE into
the mmap region for marked binaries.)

Link: http://lkml.kernel.org/r/20170807201542.GA21271@beast
Fixes: eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE")
Fixes: 02445990a96e ("arm64: move ELF_ET_DYN_BASE to 4GB / 4MB")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Kostya Serebryany <kcc@google.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |    4 ++--
 arch/x86/include/asm/elf.h   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm64/include/asm/elf.h~mm-revert-x86_64-and-arm64-elf_et_dyn_base-base arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~mm-revert-x86_64-and-arm64-elf_et_dyn_base-base
+++ a/arch/arm64/include/asm/elf.h
@@ -114,10 +114,10 @@
 
 /*
  * This is the base location for PIE (ET_DYN with INTERP) loads. On
- * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * 64-bit, this is above 4GB to leave the entire 32-bit address
  * space open for things that want to use the area for 32-bit pointers.
  */
-#define ELF_ET_DYN_BASE		0x100000000UL
+#define ELF_ET_DYN_BASE		(2 * TASK_SIZE_64 / 3)
 
 #ifndef __ASSEMBLY__
 
diff -puN arch/x86/include/asm/elf.h~mm-revert-x86_64-and-arm64-elf_et_dyn_base-base arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h~mm-revert-x86_64-and-arm64-elf_et_dyn_base-base
+++ a/arch/x86/include/asm/elf.h
@@ -247,11 +247,11 @@ extern int force_personality32;
 
 /*
  * This is the base location for PIE (ET_DYN with INTERP) loads. On
- * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * 64-bit, this is above 4GB to leave the entire 32-bit address
  * space open for things that want to use the area for 32-bit pointers.
  */
 #define ELF_ET_DYN_BASE		(mmap_is_ia32() ? 0x000400000UL : \
-						  0x100000000UL)
+						  (TASK_SIZE / 3 * 2))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
_
