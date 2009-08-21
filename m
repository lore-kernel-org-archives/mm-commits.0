From: akpm@linux-foundation.org
Subject: + checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch added to -mm tree
Date: Fri, 21 Aug 2009 15:24:57 -0700
Message-ID: <200908212224.n7LMOvip015947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932859AbZHUWZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 18:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, apw@canonical.com, pavel@suse.cz


The patch titled
     checkpatch: make -f alias --file, add --help, more verbose help message
has been added to the -mm tree.  Its filename is
     checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: make -f alias --file, add --help, more verbose help message
From: Hannes Eder <hannes@hanneseder.net>

Impact:
  - More verbose help/usage message.
  - Make the option -f an alias for --file.
  - On -h, --help, and --version display help message and exit(0).
  - With no FILE(s) given, exit(1) with "no input files".
  - On invalid options display help/usage and exit(1).

Based on a patch by Pavel Machek.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   55 ++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-f-alias-file-add-help-more-verbose-help-message scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-f-alias-file-add-help-more-verbose-help-message
+++ a/scripts/checkpatch.pl
@@ -28,6 +28,41 @@ my $mailback = 0;
 my $summary_file = 0;
 my $root;
 my %debug;
+my $help = 0;
+
+sub help {
+	my ($exitcode) = @_;
+
+	print << "EOM";
+Usage: $P [OPTION]... [FILE]...
+Version: $V
+
+Options:
+  -q, --quiet                quiet
+  --no-tree                  run without a kernel tree
+  --no-signoff               do not check for 'Signed-off-by' line
+  --patch                    treat FILE as patchfile (default)
+  --emacs                    emacs compile window format
+  --terse                    one line per report
+  -f, --file                 treat FILE as regular source file
+  --subjective, --strict     enable more subjective tests
+  --root=PATH                PATH to the kernel tree root
+  --no-summary               suppress the per-file summary
+  --mailback                 only produce a report in case of warnings/errors
+  --summary-file             include the filename in summary
+  --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is one of
+                             'values', 'possible', 'type', and 'attr' (default
+                             is all off)
+  --test-only=WORD           report only warnings/errors containing WORD
+                             literally
+  -h, --help, --version      display this help and exit
+
+When FILE is - read standard input.
+EOM
+
+	exit($exitcode);
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -35,7 +70,7 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
-	'file!'		=> \$file,
+	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
@@ -45,22 +80,16 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
-) or exit;
+	'h|help'	=> \$help,
+	'version'	=> \$help
+) or help(1);
+
+help(0) if ($help);
 
 my $exit = 0;
 
 if ($#ARGV < 0) {
-	print "usage: $P [options] patchfile\n";
-	print "version: $V\n";
-	print "options: -q               => quiet\n";
-	print "         --no-tree        => run without a kernel tree\n";
-	print "         --terse          => one line per report\n";
-	print "         --emacs          => emacs compile window format\n";
-	print "         --file           => check a source file\n";
-	print "         --strict         => enable more subjective tests\n";
-	print "         --root           => path to the kernel tree root\n";
-	print "         --no-summary     => suppress the per-file summary\n";
-	print "         --summary-file   => include the filename in summary\n";
+	print "$P: no input files\n";
 	exit(1);
 }
 
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch

