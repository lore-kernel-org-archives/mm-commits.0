From: akpm@linux-foundation.org
Subject: + arch-x86-tools-insn_sanityc-identify-source-of-messages.patch added to -mm tree
Date: Thu, 20 Sep 2012 16:46:43 -0700
Message-ID: <20120920234643.AF51510004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60114 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2ITXqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 19:46:44 -0400
Received: by ghbz15 with SMTP id z15so385452ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 16:46:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: arch/x86/tools/insn_sanity.c: identify source of messages
has been added to the -mm tree.  Its filename is
     arch-x86-tools-insn_sanityc-identify-source-of-messages.patch

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
Subject: arch/x86/tools/insn_sanity.c: identify source of messages

The kernel build prints:

  Building modules, stage 2.
  TEST    posttest
  MODPOST 3821 modules
  TEST    posttest
Success: decoded and checked 1000000 random instructions with 0 errors (seed:0xaac4bc47)
  CC      arch/x86/boot/a20.o
  CC      arch/x86/boot/cmdline.o
  AS      arch/x86/boot/copy.o
  HOSTCC  arch/x86/boot/mkcpustr
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/early_serial_console.o

which is irritating because you don't know what program is proudly
pronouncing its success.

So, as described in "console mode programming user interface guidelines
version 101" which doesn't exist, change this program to identify the
source of its messages.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/tools/insn_sanity.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/x86/tools/insn_sanity.c~arch-x86-tools-insn_sanityc-identify-source-of-messages arch/x86/tools/insn_sanity.c
--- a/arch/x86/tools/insn_sanity.c~arch-x86-tools-insn_sanityc-identify-source-of-messages
+++ a/arch/x86/tools/insn_sanity.c
@@ -55,7 +55,7 @@ static FILE		*input_file;	/* Input file 
 static void usage(const char *err)
 {
 	if (err)
-		fprintf(stderr, "Error: %s\n\n", err);
+		fprintf(stderr, "%s: Error: %s\n\n", prog, err);
 	fprintf(stderr, "Usage: %s [-y|-n|-v] [-s seed[,no]] [-m max] [-i input]\n", prog);
 	fprintf(stderr, "\t-y	64bit mode\n");
 	fprintf(stderr, "\t-n	32bit mode\n");
@@ -269,7 +269,13 @@ int main(int argc, char **argv)
 		insns++;
 	}
 
-	fprintf(stdout, "%s: decoded and checked %d %s instructions with %d errors (seed:0x%x)\n", (errors) ? "Failure" : "Success", insns, (input_file) ? "given" : "random", errors, seed);
+	fprintf(stdout, "%s: %s: decoded and checked %d %s instructions with %d errors (seed:0x%x)\n",
+		prog,
+		(errors) ? "Failure" : "Success",
+		insns,
+		(input_file) ? "given" : "random",
+		errors,
+		seed);
 
 	return errors ? 1 : 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
compat-fs-generic-compat_sys_sendfile-implementation.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

