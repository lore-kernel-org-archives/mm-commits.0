From: akpm@linux-foundation.org
Subject: + checkpatch-ignore-existing-camelcase-uses-from-include.patch
 added to -mm tree
Date: Tue, 25 Jun 2013 15:31:43 -0700
Message-ID: <51ca1a4f.wFsXSiHcjz21uxAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FYWbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, apw@canonical.com, joe@perches.com

Subject: + checkpatch-ignore-existing-camelcase-uses-from-include.patch added to -mm tree
To: joe@perches.com,apw@canonical.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:31:43 -0700


The patch titled
     Subject: checkpatch: ignore existing CamelCase uses from include/...
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-existing-camelcase-uses-from-include.patch

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
Subject: checkpatch: ignore existing CamelCase uses from include/...

When using --strict, CamelCase uses are described with CHECK: messages. 
These CamelCase uses may be acceptable and should not generate these
messages when the variable is already defined in a file from the
include/...  path.

So, change checkpatch to read all the .h files in include/...  and look
for preexisting CamelCase #defines, typedefs and function prototypes.

Add these to the existing camelcase hash so that any uses in the patch or
file can be ignored.

There are currently ~3500 files in include/.  It takes about 10 cpu
seconds on my little netbook to grep for and preseed these existing uses.

That's about 4x the time for a similar git grep.

This preseeding is only done once when using --strict and only when there
is a CamelCase use found.

If a .git directory is found, it uses 'git ls-files include' If not, it
uses 'find $root/include -name "*.h"

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   57 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-existing-camelcase-uses-from-include scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-existing-camelcase-uses-from-include
+++ a/scripts/checkpatch.pl
@@ -31,6 +31,7 @@ my $fix = 0;
 my $root;
 my %debug;
 my %ignore_type = ();
+my %camelcase = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
@@ -349,7 +350,6 @@ sub build_types {
 }
 build_types();
 
-
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 
 # Using $balanced_parens, $LvalOrFunc, or $FuncArg
@@ -369,6 +369,48 @@ sub deparenthesize {
 	return $string;
 }
 
+sub seed_camelcase_file {
+	my ($file) = @_;
+
+	return if (!(-f $file));
+
+	local $/;
+
+	open(my $include_file, '<', "$file")
+	    or warn "$P: Can't read '$file' $!\n";
+	my $text = <$include_file>;
+	close($include_file);
+
+	my @lines = split('\n', $text);
+
+	foreach my $line (@lines) {
+		next if ($line !~ /(?:[A-Z][a-z]|[a-z][A-Z])/);
+		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)/) {
+			$camelcase{$1} = 1;
+		}
+	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*\(/) {
+			$camelcase{$1} = 1;
+		}
+	}
+}
+
+my $camelcase_seeded = 0;
+sub seed_camelcase_includes {
+	return if ($camelcase_seeded);
+
+	my $files;
+	if (-d ".git") {
+		$files = `git ls-files include`;
+	} else {
+		$files = `find $root/include -name "*.h"`;
+	}
+	my @include_files = split('\n', $files);
+	foreach my $file (@include_files) {
+		seed_camelcase_file($file);
+	}
+	$camelcase_seeded = 1;
+}
+
 $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
@@ -1448,7 +1490,6 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
-	my %camelcase = ();
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -3198,11 +3239,13 @@ sub process {
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
-			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
-			    !defined $camelcase{$var}) {
-				$camelcase{$var} = 1;
-				CHK("CAMELCASE",
-				    "Avoid CamelCase: <$var>\n" . $herecurr);
+			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
+				seed_camelcase_includes() if ($check);
+				if (!defined $camelcase{$var}) {
+					$camelcase{$var} = 1;
+					CHK("CAMELCASE",
+					    "Avoid CamelCase: <$var>\n" . $herecurr);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch
checkpatch-ignore-si-unit-camelcase-variants-like-_uv.patch
checkpatch-ignore-existing-camelcase-uses-from-include.patch

