From: akpm@linux-foundation.org
Subject: [patch 110/115] arm64: move ELF_ET_DYN_BASE to 4GB / 4MB
Date: Mon, 10 Jul 2017 15:52:44 -0700
Message-ID: <20170710225244.kk8Gw7kIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754958AbdGJWwp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, keescook@chromium.org, mark.rutland@arm.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: arm64: move ELF_ET_DYN_BASE to 4GB / 4MB

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers.  On 32-bit use 4MB, to match ARM.  This
could be 0x8000, the standard ET_EXEC load address, but that is needlessly
close to the NULL address, and anyone running arm compat PIE will have an
MMU, so the tight mapping is not needed.

Link: http://lkml.kernel.org/r/1498251600-132458-4-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/arm64/include/asm/elf.h~arm64-move-elf_et_dyn_base-to-4gb-4mb arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~arm64-move-elf_et_dyn_base-to-4gb-4mb
+++ a/arch/arm64/include/asm/elf.h
@@ -113,12 +113,11 @@
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
- * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
- * use of this is to invoke "./ld.so someprog" to test out a new version of
- * the loader.  We need to make sure that it is out of the way of the program
- * that it will "exec", and that there is sufficient room for the brk.
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
  */
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
+#define ELF_ET_DYN_BASE		0x100000000UL
 
 #ifndef __ASSEMBLY__
 
@@ -174,7 +173,8 @@ extern int arch_setup_additional_pages(s
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+/* PIE load location for compat arm. Must match ARM ELF_ET_DYN_BASE. */
+#define COMPAT_ELF_ET_DYN_BASE		0x000400000UL
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
_
