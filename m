From: akpm@linux-foundation.org
Subject: + coredump-make-core-dump-functionality-optional-fix-fix.patch added to -mm tree
Date: Tue, 11 Sep 2012 15:17:45 -0700
Message-ID: <20120911221745.AD642100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48390 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2IKWRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 18:17:48 -0400
Received: by vbis24 with SMTP id s24so117853vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 15:17:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, rdunlap@xenotime.net, serge.hallyn@canonical.com


The patch titled
     Subject: coredump-make-core-dump-functionality-optional-fix-fix
has been added to the -mm tree.  Its filename is
     coredump-make-core-dump-functionality-optional-fix-fix.patch

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

diff -puN kernel/sysctl.c~coredump-make-core-dump-functionality-optional-fix-fix kernel/sysctl.c
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
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

