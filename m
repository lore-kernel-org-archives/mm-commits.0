From: akpm@linux-foundation.org
Subject: + core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:31:18 -0700
Message-ID: <200707290731.l6T7VICH013801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXG2HcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com


The patch titled
     core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
has been added to the -mm tree.  Its filename is
     core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
From: Neil Horman <nhorman@tuxdriver.com>

coding-style repairs.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <martin.pitt@ubuntu.com>
Cc: <wwoods@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixelf.c          |    2 +-
 arch/sparc64/kernel/binfmt_aout32.c |    6 +++---
 arch/x86_64/ia32/ia32_aout.c        |    8 ++++----
 fs/binfmt_aout.c                    |   12 ++++++------
 fs/binfmt_flat.c                    |    4 ++--
 fs/binfmt_som.c                     |    2 +-
 include/linux/binfmts.h             |    2 +-
 7 files changed, 18 insertions(+), 18 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/arch/mips/kernel/irixelf.c
@@ -1091,7 +1091,7 @@ end_coredump:
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
+static int irix_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
diff -puN arch/sparc64/kernel/binfmt_aout32.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -35,7 +35,7 @@
 
 static int load_aout32_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout32_library(struct file*);
-static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
+static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt aout32_format = {
 	.module		= THIS_MODULE,
@@ -105,11 +105,11 @@ static int aout32_core_dump(long signr, 
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize) > limit)
+	if (dump.u_dsize + dump.u_ssize > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize) > limit)
+	if (dump.u_ssize > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff -puN arch/x86_64/ia32/ia32_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -40,7 +40,7 @@ static int load_aout_binary(struct linux
 static int load_aout_library(struct file*);
 
 #ifdef CORE_DUMP
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 
 /*
  * fill in the user structure for a core dump..
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -168,11 +168,11 @@ static int aout_core_dump(long signr, st
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
+	if ((dump.u_dsize + dump.u_ssize + 1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
+	if ((dump.u_ssize + 1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff -puN fs/binfmt_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/fs/binfmt_aout.c
@@ -31,7 +31,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -123,19 +123,19 @@ static int aout_core_dump(long signr, st
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
 #ifdef __sparc__
-	if ((dump.u_dsize+dump.u_ssize) > limit)
+	if ((dump.u_dsize + dump.u_ssize) > limit)
 		dump.u_dsize = 0;
 #else
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
+	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 #endif
 
 /* Make sure we have enough room to write the stack and data areas. */
 #ifdef __sparc__
-	if ((dump.u_ssize) > limit)
+	if (dump.u_ssize > limit)
 		dump.u_ssize = 0;
 #else
-	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
+	if ((dump.u_ssize + 1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 #endif
 
diff -puN fs/binfmt_flat.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int 
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
+static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format =
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
+static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff -puN fs/binfmt_som.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix fs/binfmt_som.c
--- a/fs/binfmt_som.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file 
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs, unsigned long limit);
+static int som_core_dump(long signr, struct pt_regs *regs, unsigned long limit);
 #else
 #define som_core_dump	NULL
 #endif
diff -puN include/linux/binfmts.h~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix
+++ a/include/linux/binfmts.h
@@ -68,7 +68,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, unsigned long limit);
+	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
