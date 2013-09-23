From: akpm@linux-foundation.org
Subject: + checkpatch-update-seq_foo-tests.patch added to -mm tree
Date: Mon, 23 Sep 2013 15:44:20 -0700
Message-ID: <5240c444.YxvtE8exIjzme9tx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3IWWoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-update-seq_foo-tests.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:44:20 -0700


The patch titled
     Subject: checkpatch: update seq_<foo> tests
has been added to the -mm tree.  Its filename is
     checkpatch-update-seq_foo-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-seq_foo-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-seq_foo-tests.patch

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
Subject: checkpatch: update seq_<foo> tests

seq_vprintf, seq_printf and seq_puts are logging functions and should be
allowed to exceed the maximium line length.

Add maximum line length exceptions for these functions.

Also, suggesting seq_printf conversions to seq_puts should be tested for
arguments after the format.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-seq_foo-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-seq_foo-tests
+++ a/scripts/checkpatch.pl
@@ -323,7 +323,8 @@ our $logFunctions = qr{(?x:
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
-	MODULE_[A-Z_]+
+	MODULE_[A-Z_]+|
+	seq_vprintf|seq_printf|seq_puts
 )};
 
 our $signature_tags = qr{(?xi:
@@ -3909,9 +3910,9 @@ sub string_find_replace {
 		}
 
 # check for seq_printf uses that could be seq_puts
-		if ($line =~ /\bseq_printf\s*\(/) {
+		if ($sline =~ /\bseq_printf\s*\(.*"\s*\)\s*;\s*$/) {
 			my $fmt = get_quoted_string($line, $rawline);
-			if ($fmt !~ /[^\\]\%/) {
+			if ($fmt ne "" && $fmt !~ /[^\\]\%/) {
 				if (WARN("PREFER_SEQ_PUTS",
 					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
 				    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-make-extern-in-h-prototypes-quieter.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

