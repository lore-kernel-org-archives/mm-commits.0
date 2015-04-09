From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
 added to -mm tree
Date: Thu, 09 Apr 2015 13:51:49 -0700
Message-ID: <5526e665.zoU5qIPJFBWqmkJI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbDIUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 16:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andi@firstfloor.org, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a test for const with __read_mostly uses
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch

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
Subject: checkpatch: add a test for const with __read_mostly uses

const objects shouldn't be __read_mostly.  They are read-only.

Marking these objects as __read_mostly causes section conflicts with LTO
linking.

So add a test to try to avoid this issue.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-test-for-const-with-__read_mostly-uses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-test-for-const-with-__read_mostly-uses
+++ a/scripts/checkpatch.pl
@@ -4791,6 +4791,16 @@ sub process {
 			}
 		}
 
+# check for __read_mostly with const non-pointer (should just be const)
+		if ($line =~ /\b__read_mostly\b/ &&
+		    $line =~ /($Type)\s*$Ident/ && $1 !~ /\*\s*$/ && $1 =~ /\bconst\b/) {
+			if (ERROR("CONST_READ_MOSTLY",
+				  "Invalid use of __read_mostly with const type\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\s+__read_mostly\b//;
+			}
+		}
+
 # don't use __constant_<foo> functions outside of include/uapi/
 		if ($realfile !~ m@^include/uapi/@ &&
 		    $line =~ /(__constant_(?:htons|ntohs|[bl]e(?:16|32|64)_to_cpu|cpu_to_[bl]e(?:16|32|64)))\s*\(/) {
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
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
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
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
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

