From: akpm@linux-foundation.org
Subject: [merged] drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:21 -0700
Message-ID: <20121029194922.1A9115C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51400 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2TtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:25 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so344907wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, borislav.petkov@amd.com, dougthompson@xmission.com, kirjanov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/edac/amd64_edac.c:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]
has been removed from the -mm tree.  Its filename was
     drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/edac/amd64_edac.c:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

If none of the elements in scrubrates[] matches, this loop will cause
__amd64_set_scrub_rate() to incorrectly use the n+1th element.

As the function is designed to use the final scrubrates[] element in the
case of no match, we can fix this bug by simply terminating the array
search at the n-1th element.

Reported-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd64_edac.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/edac/amd64_edac.c~drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c~drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates
+++ a/drivers/edac/amd64_edac.c
@@ -170,8 +170,11 @@ static int __amd64_set_scrub_rate(struct
 	 * memory controller and apply to register. Search for the first
 	 * bandwidth entry that is greater or equal than the setting requested
 	 * and program that. If at last entry, turn off DRAM scrubbing.
+	 *
+	 * If no suitable bandwidth is found, turn off DRAM scrubbing entirely
+	 * by falling back to the last element in scrubrates[].
 	 */
-	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
 		/*
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
@@ -181,12 +184,6 @@ static int __amd64_set_scrub_rate(struct
 
 		if (scrubrates[i].bandwidth <= new_bw)
 			break;
-
-		/*
-		 * if no suitable bandwidth found, turn off DRAM scrubbing
-		 * entirely by falling back to the last element in the
-		 * scrubrates array.
-		 */
 	}
 
 	scrubval = scrubrates[i].scrubval;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

