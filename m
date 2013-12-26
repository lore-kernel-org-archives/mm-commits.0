From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-fix-inplace-option.patch added to -mm tree
Date: Thu, 26 Dec 2013 14:16:11 -0800
Message-ID: <52bcaaab.iF6cseGsBWSSpkPk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3LZWQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: + checkpatch-add-a-fix-inplace-option.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:16:11 -0800


The patch titled
     Subject: checkpatch: add a --fix-inplace option
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-fix-inplace-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-a-fix-inplace-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-a-fix-inplace-option.patch

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
Subject: checkpatch: add a --fix-inplace option

Add the ability to fix and overwrite existing files/patches instead of
creating a new file "<filename>.EXPERIMENTAL-checkpatch-fixes".

Suggested-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-fix-inplace-option scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-fix-inplace-option
+++ a/scripts/checkpatch.pl
@@ -29,6 +29,7 @@ my $mailback = 0;
 my $summary_file = 0;
 my $show_types = 0;
 my $fix = 0;
+my $fix_inplace = 0;
 my $root;
 my %debug;
 my %camelcase = ();
@@ -76,6 +77,9 @@ Options:
                              "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
                              with potential errors corrected to the preferred
                              checkpatch style
+  --fix-inplace              EXPERIMENTAL - may create horrible results
+                             Is the same as --fix, but overwrites the input
+                             file.  It's your fault if there's no backup or git
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
   -h, --help, --version      display this help and exit
@@ -131,6 +135,7 @@ GetOptions(
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
 	'fix!'		=> \$fix,
+	'fix-inplace!'	=> \$fix_inplace,
 	'ignore-perl-version!' => \$ignore_perl_version,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
@@ -140,6 +145,8 @@ GetOptions(
 
 help(0) if ($help);
 
+$fix = 1 if ($fix_inplace);
+
 my $exit = 0;
 
 if ($^V && $^V lt $minimum_perl_version) {
@@ -4444,7 +4451,8 @@ sub process {
 	hash_show_words(\%ignore_type, "Ignored");
 
 	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
-		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
+		my $newfile = $filename;
+		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
 		my $linecount = 0;
 		my $f;
 
_

Patches currently in -mm which might be from joe@perches.com are

lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

