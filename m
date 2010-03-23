From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Mar 2010 20:46:07 -0400
Message-ID: <201003230346.o2N3kw8I011869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab0CWDrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 23:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, apw@shadowen.org


The patch titled
     checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch

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
Subject: checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#25: FILE: scripts/checkpatch.pl:1386:
+^I^Iif ($realfile =~ /Kconfig/ && $

ERROR: trailing whitespace
#28: FILE: scripts/checkpatch.pl:1389:
+^I^I^Ifor (my $l = $linenr; defined($lines[$l]); $l++) { $

ERROR: trailing whitespace
#30: FILE: scripts/checkpatch.pl:1391:
+^I^I^I^I$f =~ s/#.*//; $

ERROR: trailing whitespace
#33: FILE: scripts/checkpatch.pl:1394:
+^I^I^I^Ilast if ($f =~ /^\s*config\s/); $

WARNING: line over 80 characters
#36: FILE: scripts/checkpatch.pl:1397:
+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);

total: 4 errors, 1 warnings, 21 lines checked

./patches/checkpatch-add-check-for-too-short-kconfig-descriptions.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes
+++ a/scripts/checkpatch.pl
@@ -1383,15 +1383,15 @@ sub process {
 		}
 
 # check for Kconfig help text having a real description
-		if ($realfile =~ /Kconfig/ && 
+		if ($realfile =~ /Kconfig/ &&
 		    $line =~ /\+?\s*(---)?help(---)?$/) {
 			my $length = 0;
-			for (my $l = $linenr; defined($lines[$l]); $l++) { 
+			for (my $l = $linenr; defined($lines[$l]); $l++) {
 				my $f = $lines[$l];
-				$f =~ s/#.*//; 
+				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
 				next if ($f =~ /^$/);
-				last if ($f =~ /^\s*config\s/); 
+				last if ($f =~ /^\s*config\s/);
 				$length++;
 			}
 			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

