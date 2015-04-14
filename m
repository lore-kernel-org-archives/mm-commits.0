From: akpm@linux-foundation.org
Subject: +
 checkpatch-avoid-spaces-required-around-that-false-positive.patch added to
 -mm tree
Date: Tue, 14 Apr 2015 13:01:03 -0700
Message-ID: <552d71ff.G0sMzEJgRyve9GWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbDNUBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 16:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, yehuday@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid "spaces required around that ':'" false positive
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-spaces-required-around-that-false-positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-spaces-required-around-that-false-positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-spaces-required-around-that-false-positive.patch

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
Subject: checkpatch: avoid "spaces required around that ':'" false positive

Since commit 1f65f947a6a8 ("checkpatch: add checks for question mark and
colon spacing") back in 2008, checkpatch has reported false positive for
asm volatile uses of "::" checkpatch thinks colons should always have
spaces around it.

Add an exception for colons with colons on either side for this valid asm
volatile (and c++) use.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Yehuda Yitschak <yehuday@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-spaces-required-around-that-false-positive scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-spaces-required-around-that-false-positive
+++ a/scripts/checkpatch.pl
@@ -3845,6 +3845,14 @@ sub process {
 					    	$ok = 1;
 					}
 
+					# for asm volatile statements
+					# ignore a colon with another
+					# colon immediately before or after
+					if (($op eq ':') &&
+					    ($ca =~ /:$/ || $cc =~ /^:/)) {
+						$ok = 1;
+					}
+
 					# messages are ERROR, but ?: are CHK
 					if ($ok == 0) {
 						my $msg_type = \&ERROR;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

