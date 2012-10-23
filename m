From: akpm@linux-foundation.org
Subject: + procfs-add-vmflags-field-in-smaps-output-v3-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 14:30:58 -0700
Message-ID: <20121023213059.8EEB320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:51613 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2JWVbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 17:31:03 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so256996bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 14:31:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, gorcunov@openvz.org, xemul@parallels.com


The patch titled
     Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix
has been added to the -mm tree.  Its filename is
     procfs-add-vmflags-field-in-smaps-output-v3-fix.patch

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
Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix

make mnemonics[] static, remove unneeded init code, tidy whitespace

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   58 ++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix
+++ a/fs/proc/task_mmu.c
@@ -531,39 +531,37 @@ static void show_smap_vma_flags(struct s
 	/*
 	 * Don't forget to update Documentation/ on changes.
 	 */
-
-	const struct {
+	static const struct {
 		const char l[2];
 	} mnemonics[BITS_PER_LONG] = {
-		[ilog2(VM_READ)]	= { .l = {'r', 'd'} },
-		[ilog2(VM_WRITE)]	= { .l = {'w', 'r'} },
-		[ilog2(VM_EXEC)]	= { .l = {'e', 'x'} },
-		[ilog2(VM_SHARED)]	= { .l = {'s', 'h'} },
-		[ilog2(VM_MAYREAD)]	= { .l = {'m', 'r'} },
-		[ilog2(VM_MAYWRITE)]	= { .l = {'m', 'w'} },
-		[ilog2(VM_MAYEXEC)]	= { .l = {'m', 'e'} },
-		[ilog2(VM_MAYSHARE)]	= { .l = {'m', 's'} },
-		[ilog2(VM_GROWSDOWN)]	= { .l = {'g', 'd'} },
-		[ilog2(VM_PFNMAP)]	= { .l = {'p', 'f'} },
-		[ilog2(VM_DENYWRITE)]	= { .l = {'d', 'w'} },
-		[ilog2(VM_LOCKED)]	= { .l = {'l', 'o'} },
-		[ilog2(VM_IO)]		= { .l = {'i', 'o'} },
-		[ilog2(VM_SEQ_READ)]	= { .l = {'s', 'r'} },
-		[ilog2(VM_RAND_READ)]	= { .l = {'r', 'r'} },
-		[ilog2(VM_DONTCOPY)]	= { .l = {'d', 'c'} },
-		[ilog2(VM_DONTEXPAND)]	= { .l = {'d', 'e'} },
-		[ilog2(VM_ACCOUNT)]	= { .l = {'a', 'c'} },
-		[ilog2(VM_NORESERVE)]	= { .l = {'n', 'r'} },
-		[ilog2(VM_HUGETLB)]	= { .l = {'h', 't'} },
-		[ilog2(VM_NONLINEAR)]	= { .l = {'n', 'l'} },
-		[ilog2(VM_ARCH_1)]	= { .l = {'a', 'r'} },
-		[ilog2(VM_DONTDUMP)]	= { .l = {'d', 'd'} },
-		[ilog2(VM_MIXEDMAP)]	= { .l = {'m', 'm'} },
-		[ilog2(VM_HUGEPAGE)]	= { .l = {'h', 'g'} },
-		[ilog2(VM_NOHUGEPAGE)]	= { .l = {'n', 'h'} },
-		[ilog2(VM_MERGEABLE)]	= { .l = {'m', 'g'} },
+		[ilog2(VM_READ)]	= { {'r', 'd'} },
+		[ilog2(VM_WRITE)]	= { {'w', 'r'} },
+		[ilog2(VM_EXEC)]	= { {'e', 'x'} },
+		[ilog2(VM_SHARED)]	= { {'s', 'h'} },
+		[ilog2(VM_MAYREAD)]	= { {'m', 'r'} },
+		[ilog2(VM_MAYWRITE)]	= { {'m', 'w'} },
+		[ilog2(VM_MAYEXEC)]	= { {'m', 'e'} },
+		[ilog2(VM_MAYSHARE)]	= { {'m', 's'} },
+		[ilog2(VM_GROWSDOWN)]	= { {'g', 'd'} },
+		[ilog2(VM_PFNMAP)]	= { {'p', 'f'} },
+		[ilog2(VM_DENYWRITE)]	= { {'d', 'w'} },
+		[ilog2(VM_LOCKED)]	= { {'l', 'o'} },
+		[ilog2(VM_IO)]		= { {'i', 'o'} },
+		[ilog2(VM_SEQ_READ)]	= { {'s', 'r'} },
+		[ilog2(VM_RAND_READ)]	= { {'r', 'r'} },
+		[ilog2(VM_DONTCOPY)]	= { {'d', 'c'} },
+		[ilog2(VM_DONTEXPAND)]	= { {'d', 'e'} },
+		[ilog2(VM_ACCOUNT)]	= { {'a', 'c'} },
+		[ilog2(VM_NORESERVE)]	= { {'n', 'r'} },
+		[ilog2(VM_HUGETLB)]	= { {'h', 't'} },
+		[ilog2(VM_NONLINEAR)]	= { {'n', 'l'} },
+		[ilog2(VM_ARCH_1)]	= { {'a', 'r'} },
+		[ilog2(VM_DONTDUMP)]	= { {'d', 'd'} },
+		[ilog2(VM_MIXEDMAP)]	= { {'m', 'm'} },
+		[ilog2(VM_HUGEPAGE)]	= { {'h', 'g'} },
+		[ilog2(VM_NOHUGEPAGE)]	= { {'n', 'h'} },
+		[ilog2(VM_MERGEABLE)]	= { {'m', 'g'} },
 	};
-
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

