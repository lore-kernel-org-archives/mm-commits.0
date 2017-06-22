From: akpm@linux-foundation.org
Subject: [to-be-updated]
 x86-elf-move-32-bit-elf_et_dyn_base-to-256mb.patch removed from -mm tree
Date: Thu, 22 Jun 2017 14:05:08 -0700
Message-ID: <594c3104.KSqmQ+noZI/I7PMZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbdFVVFJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hpa@zytor.com, lwoodman@redhat.com, mhocko@kernel.org, mingo@kernel.org, oleg@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB
has been removed from the -mm tree.  Its filename was
     x86-elf-move-32-bit-elf_et_dyn_base-to-256mb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB

When setting up mmap_base, we take care to start the mmap base below the
maximum extent to which the stack will grow.  However, we take no such
precautions with PIE binaries, which are placed at 5/6 of TASK_SIZE plus a
random offset.  As a result, 32 bit PIE binaries can end up smack in the
middle of where the stack (which is randomized down) is supposed to go.

That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE at
256MB, which is a value linux-hardened and grsecurity have used for a long
time now without any known (to me) bug reports.

Link: http://lkml.kernel.org/r/20170602152010.2064-3-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/elf.h |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN arch/x86/include/asm/elf.h~x86-elf-move-32-bit-elf_et_dyn_base-to-256mb arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h~x86-elf-move-32-bit-elf_et_dyn_base-to-256mb
+++ a/arch/x86/include/asm/elf.h
@@ -245,12 +245,23 @@ extern int force_personality32;
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
+/*
+ * True on X86_32 or when emulating IA32 on X86_64
+ */
+static inline int mmap_is_ia32(void)
+{
+	return IS_ENABLED(CONFIG_X86_32) ||
+	       (IS_ENABLED(CONFIG_COMPAT) &&
+		test_thread_flag(TIF_ADDR32));
+}
+
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+#define ELF_ET_DYN_BASE		(mmap_is_ia32() ? 0x10000000UL : \
+				(TASK_SIZE / 3 * 2))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
@@ -293,16 +304,6 @@ do {									\
 	}								\
 } while (0)
 
-/*
- * True on X86_32 or when emulating IA32 on X86_64
- */
-static inline int mmap_is_ia32(void)
-{
-	return IS_ENABLED(CONFIG_X86_32) ||
-	       (IS_ENABLED(CONFIG_COMPAT) &&
-		test_thread_flag(TIF_ADDR32));
-}
