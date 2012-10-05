From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-make-core-dump-functionality-optional-fix-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:01:59 -0700
Message-ID: <20121005000200.667385C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50311 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2JEACD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:02:03 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so75269bkw.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:02:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, rdunlap@xenotime.net, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-make-core-dump-functionality-optional-fix-fix
has been removed from the -mm tree.  Its filename was
     coredump-make-core-dump-functionality-optional-fix-fix.patch

This patch was dropped because it was folded into coredump-make-core-dump-functionality-optional.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: coredump-make-core-dump-functionality-optional-fix-fix

fix binfmt_aout.c build

Cc: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c |   52 +++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff -puN fs/binfmt_aout.c~coredump-make-core-dump-functionality-optional-fix-fix fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-make-core-dump-functionality-optional-fix-fix
+++ a/fs/binfmt_aout.c
@@ -32,31 +32,8 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(struct coredump_params *cprm);
-
-static struct linux_binfmt aout_format = {
-	.module		= THIS_MODULE,
-	.load_binary	= load_aout_binary,
-	.load_shlib	= load_aout_library,
-	.core_dump	= aout_core_dump,
-	.min_coredump	= PAGE_SIZE
-};
-
-#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
-
-static int set_brk(unsigned long start, unsigned long end)
-{
-	start = PAGE_ALIGN(start);
-	end = PAGE_ALIGN(end);
-	if (end > start) {
-		unsigned long addr;
-		addr = vm_brk(start, end - start);
-		if (BAD_ADDR(addr))
-			return addr;
-	}
-	return 0;
-}
 
+#ifdef CONFIG_COREDUMP
 /*
  * Routine writes a core dump image in the current directory.
  * Currently only a stub-function.
@@ -66,7 +43,6 @@ static int set_brk(unsigned long start, 
  * field, which also makes sure the core-dumps won't be recursive if the
  * dumping of the process results in another error..
  */
-
 static int aout_core_dump(struct coredump_params *cprm)
 {
 	struct file *file = cprm->file;
@@ -135,6 +111,32 @@ end_coredump:
 	set_fs(fs);
 	return has_dumped;
 }
+#else
+#define aout_core_dump NULL
+#endif
+
+static struct linux_binfmt aout_format = {
+	.module		= THIS_MODULE,
+	.load_binary	= load_aout_binary,
+	.load_shlib	= load_aout_library,
+	.core_dump	= aout_core_dump,
+	.min_coredump	= PAGE_SIZE
+};
+
+#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
+
+static int set_brk(unsigned long start, unsigned long end)
+{
+	start = PAGE_ALIGN(start);
+	end = PAGE_ALIGN(end);
+	if (end > start) {
+		unsigned long addr;
+		addr = vm_brk(start, end - start);
+		if (BAD_ADDR(addr))
+			return addr;
+	}
+	return 0;
+}
 
 /*
  * create_aout_tables() parses the env- and arg-strings in new user
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
rtc-add-dallas-ds2404-driver.patch
fat-simplify-writeback_inode.patch
coredump-make-core-dump-functionality-optional.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

