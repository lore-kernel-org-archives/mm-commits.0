From: akpm@linux-foundation.org
Subject: + checkpatch-add-typedefsfile.patch added to -mm tree
Date: Thu, 27 Apr 2017 14:48:42 -0700
Message-ID: <5902673a.Q8N1e+IqEex93iZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423158AbdD0Vso (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2017 17:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jerome.forissier@linaro.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --typedefsfile
has been added to the -mm tree.  Its filename is
     checkpatch-add-typedefsfile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-typedefsfile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-typedefsfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Forissier <jerome.forissier@linaro.org>
Subject: checkpatch: add --typedefsfile

When using checkpatch on out-of-tree code, it may occur that some
project-specific types are used, which will cause spurious warnings.
Add the --typedefsfile option as a way to extend the known types and
deal with this issue.

This was developed for OP-TEE [1].  We run a Travis job on all pull
requests [2], and checkpatch is part of that.  The typical false warning
we get on a regular basis is with some pointers to functions returning
TEE_Result [3], which is a typedef from the GlobalPlatform APIs.  We
consider it is acceptable to use GP types in the OP-TEE core
implementation, that's why this patch would be helpful for us.

[1] https://github.com/OP-TEE/optee_os
[2] https://travis-ci.org/OP-TEE/optee_os/builds
[3] https://travis-ci.org/OP-TEE/optee_os/builds/193355335#L1733

Link: http://lkml.kernel.org/r/ba1124d6dfa599bb0dd1d8919dd45dd09ce541a4.1492702192.git.jerome.forissier@linaro.org
Signed-off-by: Jerome Forissier <jerome.forissier@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   52 ++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-typedefsfile scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-typedefsfile
+++ a/scripts/checkpatch.pl
@@ -55,6 +55,7 @@ my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $conststructsfile = "$D/const_structs.checkpatch";
+my $typedefsfile = "";
 my $color = 1;
 my $allow_c99_comments = 1;
 
@@ -113,6 +114,7 @@ Options:
   --codespell                Use the codespell dictionary for spelling/typos
                              (default:/usr/share/codespell/dictionary.txt)
   --codespellfile            Use this codespell dictionary
+  --typedefsfile             Read additional types from this file
   --color                    Use colors when output is STDOUT (default: on)
   -h, --help, --version      display this help and exit
 
@@ -208,6 +210,7 @@ GetOptions(
 	'test-only=s'	=> \$tst_only,
 	'codespell!'	=> \$codespell,
 	'codespellfile=s'	=> \$codespellfile,
+	'typedefsfile=s'	=> \$typedefsfile,
 	'color!'	=> \$color,
 	'h|help'	=> \$help,
 	'version'	=> \$help
@@ -629,28 +632,43 @@ if ($codespell) {
 
 $misspellings = join("|", sort keys %spelling_fix) if keys %spelling_fix;
 
-my $const_structs = "";
-if (open(my $conststructs, '<', $conststructsfile)) {
-	while (<$conststructs>) {
-		my $line = $_;
+sub read_words {
+	my ($wordsRef, $file) = @_;
 
-		$line =~ s/\s*\n?$//g;
-		$line =~ s/^\s*//g;
+	if (open(my $words, '<', $file)) {
+		while (<$words>) {
+			my $line = $_;
 
-		next if ($line =~ m/^\s*#/);
-		next if ($line =~ m/^\s*$/);
-		if ($line =~ /\s/) {
-			print("$conststructsfile: '$line' invalid - ignored\n");
-			next;
-		}
+			$line =~ s/\s*\n?$//g;
+			$line =~ s/^\s*//g;
 
-		$const_structs .= '|' if ($const_structs ne "");
-		$const_structs .= $line;
+			next if ($line =~ m/^\s*#/);
+			next if ($line =~ m/^\s*$/);
+			if ($line =~ /\s/) {
+				print("$file: '$line' invalid - ignored\n");
+				next;
+			}
+
+			$$wordsRef .= '|' if ($$wordsRef ne "");
+			$$wordsRef .= $line;
+		}
+		close($file);
+		return 1;
 	}
-	close($conststructsfile);
-} else {
-	warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
+
+	return 0;
+}
+
+my $const_structs = "";
+read_words(\$const_structs, $conststructsfile)
+    or warn "No structs that should be const will be found - file '$conststructsfile': $!\n";
+
+my $typeOtherTypedefs = "";
+if (length($typedefsfile)) {
+	read_words(\$typeOtherTypedefs, $typedefsfile)
+	    or warn "No additional types will be considered - file '$typedefsfile': $!\n";
 }
+$typeTypedefs .= '|' . $typeOtherTypedefs if ($typeOtherTypedefs ne "");
 
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", (@modifierList, @modifierListFile)) . "\n)";
_

Patches currently in -mm which might be from jerome.forissier@linaro.org are

checkpatch-add-typedefsfile.patch

