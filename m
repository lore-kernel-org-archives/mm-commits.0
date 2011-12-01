From: akpm@linux-foundation.org
Subject: + merge_configsh-fix-bug-in-final-check.patch added to -mm tree
Date: Thu, 01 Dec 2011 15:06:45 -0800
Message-ID: <201112012306.pB1N6j91016716@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56861 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab1LAXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 18:06:49 -0500
Received: by eekd41 with SMTP id d41so21625eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 15:06:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.stultz@linaro.org, dvhart@linux.intel.com, lacombar@gmail.com, mmarek@suse.cz


The patch titled
     Subject: merge_config.sh: fix bug in final check
has been added to the -mm tree.  Its filename is
     merge_configsh-fix-bug-in-final-check.patch

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
From: John Stultz <john.stultz@linaro.org>
Subject: merge_config.sh: fix bug in final check

Arnaud Lacombe pointed out the final checking that the requested configs
were included in the final .config was broken.

The example was that if you had a fragment that disabled
CONFIG_DECOMPRESS_GZIP applied to a normal defconfig, there would be no
final warning that CONFIG_DECOMPRESS_GZIP was acutally set in the final
.config.

This bug was introduced by me in v3 of the original patch, and the
following patch reverts the invalid change.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/merge_config.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/merge_config.sh~merge_configsh-fix-bug-in-final-check scripts/kconfig/merge_config.sh
--- a/scripts/kconfig/merge_config.sh~merge_configsh-fix-bug-in-final-check
+++ a/scripts/kconfig/merge_config.sh
@@ -104,8 +104,8 @@ make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTAR
 # Check all specified config values took (might have missed-dependency issues)
 for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
 
-	REQUESTED_VAL=$(sed -n "$SED_CONFIG_EXP" $TMP_FILE | grep -w -e "$CFG")
-	ACTUAL_VAL=$(sed -n "$SED_CONFIG_EXP" .config | grep -w -e "$CFG")
+	REQUESTED_VAL=$(grep -w -e "$CFG" $TMP_FILE)
+	ACTUAL_VAL=$(grep -w -e "$CFG" .config)
 	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
 		echo "Value requested for $CFG not in final .config"
 		echo "Requested value:  $REQUESTED_VAL"
_
Subject: Subject: merge_config.sh: fix bug in final check

Patches currently in -mm which might be from john.stultz@linaro.org are

origin.patch
mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch
kconfig-add-merge_configsh-script.patch
merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch
merge_configsh-whitespace-cleanup.patch
merge_configsh-fix-bug-in-final-check.patch
debugobjects-be-smarter-about-static-objects.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch

