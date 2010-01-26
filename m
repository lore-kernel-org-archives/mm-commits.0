From: akpm@linux-foundation.org
Subject: + delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:48:04 -0800
Message-ID: <201001260048.o0Q0m4lu021156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab0AZAsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, mel@csn.ul.ie


The patch titled
     delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#93: FILE: Documentation/accounting/getdelays.c:339:
+				if (execvp(argv[optind - 1], &argv[optind - 1]) < 0)

ERROR: trailing whitespace
#109: FILE: Documentation/accounting/getdelays.c:399:
+^I * as all the delicious data would be reaped as part of the wait $

total: 1 errors, 1 warnings, 64 lines checked

./patches/delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes
+++ a/Documentation/accounting/getdelays.c
@@ -336,7 +336,8 @@ int main(int argc, char *argv[])
 			if (tid < 0)
 				err(1, "Fork failed\n");
 			if (tid == 0)
-				if (execvp(argv[optind - 1], &argv[optind - 1]) < 0)
+				if (execvp(argv[optind - 1],
+				    &argv[optind - 1]) < 0)
 					exit(-1);
 
 			/* Set the command type and avoid further processing */
@@ -396,7 +397,7 @@ int main(int argc, char *argv[])
 
 	/*
 	 * If we forked a child, wait for it to exit. Cannot use waitpid()
-	 * as all the delicious data would be reaped as part of the wait 
+	 * as all the delicious data would be reaped as part of the wait
 	 */
 	if (tid && forking) {
 		int sig_received;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

