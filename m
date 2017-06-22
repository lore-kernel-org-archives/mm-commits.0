From: akpm@linux-foundation.org
Subject: [to-be-updated] binfmt_elf-document-load_bias-a-little-bit.patch
 removed from -mm tree
Date: Thu, 22 Jun 2017 14:05:05 -0700
Message-ID: <594c3101.b8Qt+LUuNQJ5wuN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdFVVFG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hpa@zytor.com, lwoodman@redhat.com, mhocko@kernel.org, mingo@kernel.org, oleg@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: document load_bias a little bit
has been removed from the -mm tree.  Its filename was
     binfmt_elf-document-load_bias-a-little-bit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: binfmt_elf: document load_bias a little bit

Patch series "move mmap_area and PIE binaries away from the stack".

There are a few bugs causing the kernel to sometimes map PIE binaries and
the mmap_area where the stack is supposed to go.

This series fixes them for x86, ARM64, and PPC.  S390 seems to be ok.


This patch (of 6):

After I and another unnamed developer got confused by the subtraction of
vaddr in this branch of the code, followed by adding vaddr back in a
little bit later, for the third time, maybe it is time to document this
quirky bit of code.

Link: http://lkml.kernel.org/r/20170602152010.2064-2-riel@redhat.com
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

 fs/binfmt_elf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-document-load_bias-a-little-bit fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-document-load_bias-a-little-bit
+++ a/fs/binfmt_elf.c
@@ -930,10 +930,16 @@ static int load_elf_binary(struct linux_
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
 			elf_flags |= MAP_FIXED;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
-			/* Try and get dynamic programs out of the way of the
+			/*
+			 * Try and get dynamic programs out of the way of the
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
-			 * follow the loader, and is not movable.  */
+			 * follow the loader, and is not movable.
+			 *
+			 * The load_bias is the difference between the address
+			 * in the elf header and the address where the binary
+			 * is mmapped.
+			 */
 			load_bias = ELF_ET_DYN_BASE - vaddr;
 			if (current->flags & PF_RANDOMIZE)
 				load_bias += arch_mmap_rnd();
_

Patches currently in -mm which might be from riel@redhat.com are

x86-elf-move-32-bit-elf_et_dyn_base-to-256mb.patch
x86-mmap-properly-account-for-stack-randomization-in-mmap_base.patch
arm64-mmap-properly-account-for-stack-randomization-in-mmap_base.patch
arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space.patch
powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
randomstackprotect-introduce-get_random_canary-function.patch
forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
x86-ascii-armor-the-x86_64-boot-init-stack-canary.patch
arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch
sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch

