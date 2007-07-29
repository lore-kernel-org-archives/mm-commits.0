From: akpm@linux-foundation.org
Subject: - allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch removed from -mm tree
Date: Sun, 29 Jul 2007 00:19:10 -0700
Message-ID: <200707290719.l6T7JA6B013443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758089AbXG2HUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, hidehiro.kawai.ez@hitachi.com, mm-commits@vger.kernel.org


The patch titled
     allow individual core dump methods to be unlimited when sending to a pipe (fix 2)
has been removed from the -mm tree.  Its filename was
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: allow individual core dump methods to be unlimited when sending to a pipe (fix 2)
From: Neil Horman <nhorman@tuxdriver.com>

Heres the subsequent patch that I promised you.  It changes all the limit
passing to be unsigned longs.  I've built it on x86, x86_64 and ia64 and it
seems to be good to go.  It leaves off the bit that you have above, since
you've already included that.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_aout.c |    2 +-
 fs/binfmt_aout.c             |    2 +-
 fs/binfmt_elf.c              |    4 ++--
 fs/binfmt_elf_fdpic.c        |    2 +-
 fs/binfmt_flat.c             |    2 +-
 fs/binfmt_som.c              |    2 +-
 include/linux/binfmts.h      |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/ia32/ia32_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
diff -puN fs/binfmt_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/fs/binfmt_aout.c
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
diff -puN fs/binfmt_elf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/fs/binfmt_elf.c
@@ -52,7 +52,7 @@ static unsigned long elf_map (struct fil
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1488,7 +1488,7 @@ static struct vm_area_struct *next_vma(s
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
diff -puN fs/binfmt_elf_fdpic.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/fs/binfmt_elf_fdpic.c
@@ -1552,7 +1552,7 @@ static int elf_fdpic_dump_segments(struc
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file, u32 limit)
+			       struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
diff -puN fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/fs/binfmt_flat.c
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format =
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff -puN fs/binfmt_som.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 fs/binfmt_som.c
--- a/fs/binfmt_som.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file 
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs, u32 limit);
+static int som_core_dump(long signr, struct pt_regs * regs, unsigned long limit);
 #else
 #define som_core_dump	NULL
 #endif
diff -puN include/linux/binfmts.h~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2 include/linux/binfmts.h
--- a/include/linux/binfmts.h~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2
+++ a/include/linux/binfmts.h
@@ -68,7 +68,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, u32 limit);
+	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, unsigned long limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
