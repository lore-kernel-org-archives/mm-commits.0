From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-a-fix-inplace-option.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:01:49 -0800
Message-ID: <52e2b89d.nn3kDbFmFNZjBhpW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaAXTBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-add-a-fix-inplace-option.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:49 -0800


The patch titled
     Subject: checkpatch: add a --fix-inplace option
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-fix-inplace-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4388,7 +4395,8 @@ sub process {
 	hash_show_words(\%ignore_type, "Ignored");
 
 	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
-		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
+		my $newfile = $filename;
+		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
 		my $linecount = 0;
 		my $f;
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

