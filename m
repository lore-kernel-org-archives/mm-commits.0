From: akpm@linux-foundation.org
Subject: - inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:12:18 -0700
Message-ID: <200807250012.m6P0CIVT013489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbYGYAOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, dhowells@redhat.com, hpa@zytor.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, jesper.nilsson@axis.com, lethal@linux-sh.org, mika


The patch titled
     inflate-refactor-inflate-malloc-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch

This patch was dropped because it was folded into inflate-refactor-inflate-malloc-code.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inflate-refactor-inflate-malloc-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not initialise statics to 0 or NULL
#257: FILE: arch/cris/arch-v10/boot/compressed/misc.c:102:
+static long free_mem_end_ptr = 0;

ERROR: do not initialise statics to 0 or NULL
#320: FILE: arch/cris/arch-v32/boot/compressed/misc.c:107:
+static long free_mem_end_ptr = 0;

ERROR: spaces required around that '<' (ctx:WxV)
#825: FILE: lib/inflate.c:245:
+       if (size <0)
                 ^

ERROR: code indent should use tabs where possible
#826: FILE: lib/inflate.c:246:
+               error("Malloc error");$

ERROR: code indent should use tabs where possible
#828: FILE: lib/inflate.c:248:
+               malloc_ptr = free_mem_ptr;$

ERROR: code indent should use tabs where possible
#836: FILE: lib/inflate.c:256:
+               error("Out of memory");$

ERROR: code indent should use tabs where possible
#846: FILE: lib/inflate.c:266:
+               malloc_ptr = free_mem_ptr;$

total: 7 errors, 0 warnings, 745 lines checked

./patches/inflate-refactor-inflate-malloc-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/boot/compressed/misc.c |    2 +-
 arch/cris/arch-v32/boot/compressed/misc.c |    6 +++---
 lib/inflate.c                             |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/cris/arch-v10/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes arch/cris/arch-v10/boot/compressed/misc.c
--- a/arch/cris/arch-v10/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes
+++ a/arch/cris/arch-v10/boot/compressed/misc.c
@@ -108,7 +108,7 @@ static void puts(const char *);
 
 extern int _end;
 static long free_mem_ptr = (long)&_end;
-static long free_mem_end_ptr = 0;
+static long free_mem_end_ptr;
 
 #include "../../../../../lib/inflate.c"
 
diff -puN arch/cris/arch-v32/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes arch/cris/arch-v32/boot/compressed/misc.c
--- a/arch/cris/arch-v32/boot/compressed/misc.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes
+++ a/arch/cris/arch-v32/boot/compressed/misc.c
@@ -92,9 +92,9 @@ static void error(char *m);
 
 extern char *input_data;  /* lives in head.S */
 
-static long bytes_out = 0;
+static long bytes_out;
 static uch *output_data;
-static unsigned long output_ptr = 0;
+static unsigned long output_ptr;
 
 static void error(char *m);
 
@@ -104,7 +104,7 @@ static void puts(const char *);
 
 extern int _end;
 static long free_mem_ptr = (long)&_end;
-static long free_mem_end_ptr = 0;
+static long free_mem_end_ptr;
 
 #include "../../../../../lib/inflate.c"
 
diff -puN lib/inflate.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes lib/inflate.c
--- a/lib/inflate.c~inflate-refactor-inflate-malloc-code-checkpatch-fixes
+++ a/lib/inflate.c
@@ -242,10 +242,10 @@ static void *malloc(int size)
 {
        void *p;
 
-       if (size <0)
-               error("Malloc error");
+       if (size < 0)
+		error("Malloc error");
        if (!malloc_ptr)
-               malloc_ptr = free_mem_ptr;
+		malloc_ptr = free_mem_ptr;
 
        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
 
@@ -253,7 +253,7 @@ static void *malloc(int size)
        malloc_ptr += size;
 
        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
-               error("Out of memory");
+		error("Out of memory");
 
        malloc_count++;
        return p;
@@ -263,7 +263,7 @@ static void free(void *where)
 {
        malloc_count--;
        if (!malloc_count)
-               malloc_ptr = free_mem_ptr;
+		malloc_ptr = free_mem_ptr;
 }
 #else
 #define malloc(a) kmalloc(a, GFP_KERNEL)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

