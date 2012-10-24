From: akpm@linux-foundation.org
Subject: + procfs-add-vmflags-field-in-smaps-output-v4-fix.patch added to -mm tree
Date: Wed, 24 Oct 2012 13:39:27 -0700
Message-ID: <20121024203928.219FC100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57985 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318Ab2JXUj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:39:29 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so109228ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:39:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, gorcunov@openvz.org, sfr@canb.auug.org.au, xemul@parallels.com


The patch titled
     Subject: procfs-add-vmflags-field-in-smaps-output-v4-fix
has been added to the -mm tree.  Its filename is
     procfs-add-vmflags-field-in-smaps-output-v4-fix.patch

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
Subject: procfs-add-vmflags-field-in-smaps-output-v4-fix

remove unneeded brakes per sfr, avoid using bloaty for_each_set_bit()

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v4-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v4-fix
+++ a/fs/proc/task_mmu.c
@@ -535,7 +535,7 @@ static void show_smap_vma_flags(struct s
 		/*
 		 * In case if we meet a flag we don't know about.
 		 */
-		[0 ... (BITS_PER_LONG-1)] = { "??" },
+		[0 ... (BITS_PER_LONG-1)] = "??",
 
 		[ilog2(VM_READ)]	= "rd",
 		[ilog2(VM_WRITE)]	= "wr",
@@ -568,10 +568,11 @@ static void show_smap_vma_flags(struct s
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
-	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
-		seq_printf(m, "%c%c ",
-			   mnemonics[i][0],
-			   mnemonics[i][1]);
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		if (vma->vm_flags & (1UL << i)) {
+			seq_printf(m, "%c%c ",
+				   mnemonics[i][0], mnemonics[i][1]);
+		}
 	}
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

