From: akpm@linux-foundation.org
Subject: + checkpatch-improve-return-negative-errno-check.patch added to
 -mm tree
Date: Mon, 23 Mar 2015 15:20:01 -0700
Message-ID: <55109191.YLSF5Q9FHnbWmCXH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbCWWUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 18:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve return negative errno check
has been added to the -mm tree.  Its filename is
     checkpatch-improve-return-negative-errno-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-return-negative-errno-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-return-negative-errno-check.patch

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
Subject: checkpatch: improve return negative errno check

Add a few conditions to the test to find
	return (ERRNO);

Make the output message a bit less cryptic too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-return-negative-errno-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-return-negative-errno-check
+++ a/scripts/checkpatch.pl
@@ -4009,12 +4009,12 @@ sub process {
 			}
 		}
 
-# Return of what appears to be an errno should normally be -'ve
-		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
+# Return of what appears to be an errno should normally be negative
+		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
 			my $name = $1;
 			if ($name ne 'EOF' && $name ne 'ERROR') {
 				WARN("USE_NEGATIVE_ERRNO",
-				     "return of an errno should typically be -ve (return -$1)\n" . $herecurr);
+				     "return of an errno should typically be negative (ie: return -$1)\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-correct-rtc-armada38x-pattern-entry.patch
maintainers-remove-drm-drivers-for-renesas-pattern.patch
hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
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
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
linux-next.patch

