From: akpm@linux-foundation.org
Subject: + checkpatch-add-spell-checking-of-email-subject-line.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:16:10 -0700
Message-ID: <5500beaa.ueSKQ2aG3Sfn0Rek%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbbCKWQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jani.nikula@intel.com, jani.nikula@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add spell checking of email subject line
has been added to the -mm tree.  Its filename is
     checkpatch-add-spell-checking-of-email-subject-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-spell-checking-of-email-subject-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-spell-checking-of-email-subject-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add spell checking of email subject line

Only commit log and patch additions are checked for typos and spelling
errors currently.  Add a check of the email subject line too.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
Tested-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-spell-checking-of-email-subject-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-spell-checking-of-email-subject-line
+++ a/scripts/checkpatch.pl
@@ -2303,7 +2303,8 @@ sub process {
 		}
 
 # Check for various typo / spelling mistakes
-		if (defined($misspellings) && ($in_commit_log || $line =~ /^\+/)) {
+		if (defined($misspellings) &&
+		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
 			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
 				my $typo = $1;
 				my $typo_fix = $spelling_fix{lc($typo)};
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
linux-next.patch

