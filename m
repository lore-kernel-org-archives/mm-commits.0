From: akpm@linux-foundation.org
Subject: + checkpatch-improve-return-is-not-a-function-test.patch added to -mm tree
Date: Thu, 31 Oct 2013 14:30:41 -0700
Message-ID: <5272cc01.QePsPcVOwstBPj2G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3JaVal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:30:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-improve-return-is-not-a-function-test.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:30:41 -0700


The patch titled
     Subject: checkpatch: improve "return is not a function" test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-return-is-not-a-function-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-return-is-not-a-function-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-return-is-not-a-function-test.patch

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
Subject: checkpatch: improve "return is not a function" test

Find a few more cases where parentheses are used around the value of a
return statement.

This also makes the test depend on perl v5.10 and higher.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-return-is-not-a-function-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-return-is-not-a-function-test
+++ a/scripts/checkpatch.pl
@@ -3233,21 +3233,10 @@ sub process {
 		}
 
 # Return is not a function.
-		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
 			my $spacing = $1;
-			my $value = $2;
-
-			# Flatten any parentheses
-			$value =~ s/\(/ \(/g;
-			$value =~ s/\)/\) /g;
-			while ($value =~ s/\[[^\[\]]*\]/1/ ||
-			       $value !~ /(?:$Ident|-?$Constant)\s*
-					     $Compare\s*
-					     (?:$Ident|-?$Constant)/x &&
-			       $value =~ s/\([^\(\)]*\)/1/) {
-			}
-#print "value<$value>\n";
-			if ($value =~ /^\s*(?:$Ident|-?$Constant)\s*$/) {
+			if ($^V && $^V ge 5.10.0 &&
+			    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/) {
 				ERROR("RETURN_PARENTHESES",
 				      "return is not a function, parentheses are not required\n" . $herecurr);
 
@@ -3256,6 +3245,7 @@ sub process {
 				      "space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
+
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

