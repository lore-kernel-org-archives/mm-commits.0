From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:55 -0700
Message-ID: <553550a7.zZrh8kk95c6NyJUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDTTKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, keescook@chromium.org, lucas.de.marchi@gmail.com, standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add optional --codespell dictionary to find more typos
has been removed from the -mm tree.  Its filename was
     checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add optional --codespell dictionary to find more typos

If a codespell dictionary exists, use it if desired.  default is off,
maybe it could be turned on later.

codespell's dictionary format allows multiple possible corrections, ignore
that for now and only use the first suggestion.

Also add \b to spelling test so that consecutive misspelled words
are found properly.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masanari Iida <standby24x7@gmail.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-optional-codespell-dictionary-to-find-more-typos scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-optional-codespell-dictionary-to-find-more-typos
+++ a/scripts/checkpatch.pl
@@ -47,6 +47,8 @@ my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
+my $codespell = 0;
+my $codespellfile = "/usr/local/share/codespell/dictionary.txt";
 
 sub help {
 	my ($exitcode) = @_;
@@ -88,6 +90,9 @@ Options:
                              file.  It's your fault if there's no backup or git
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
+  --codespell                Use the codespell dictionary for spelling/typos
+                             (default:/usr/local/share/codespell/dictionary.txt)
+  --codespellfile            Use this codespell dictionary
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -146,6 +151,8 @@ GetOptions(
 	'ignore-perl-version!' => \$ignore_perl_version,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
+	'codespell!'	=> \$codespell,
+	'codespellfile=s'	=> \$codespellfile,
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -449,7 +456,6 @@ my $misspellings;
 my %spelling_fix;
 
 if (open(my $spelling, '<', $spelling_file)) {
-	my @spelling_list;
 	while (<$spelling>) {
 		my $line = $_;
 
@@ -461,15 +467,39 @@ if (open(my $spelling, '<', $spelling_fi
 
 		my ($suspect, $fix) = split(/\|\|/, $line);
 
-		push(@spelling_list, $suspect);
 		$spelling_fix{$suspect} = $fix;
 	}
 	close($spelling);
-	$misspellings = join("|", @spelling_list);
 } else {
 	warn "No typos will be found - file '$spelling_file': $!\n";
 }
 
+if ($codespell) {
+	if (open(my $spelling, '<', $codespellfile)) {
+		while (<$spelling>) {
+			my $line = $_;
+
+			$line =~ s/\s*\n?$//g;
+			$line =~ s/^\s*//g;
+
+			next if ($line =~ m/^\s*#/);
+			next if ($line =~ m/^\s*$/);
+			next if ($line =~ m/, disabled/i);
+
+			$line =~ s/,.*$//;
+
+			my ($suspect, $fix) = split(/->/, $line);
+
+			$spelling_fix{$suspect} = $fix;
+		}
+		close($spelling);
+	} else {
+		warn "No codespell typos will be found - file '$codespellfile': $!\n";
+	}
+}
+
+$misspellings = join("|", sort keys %spelling_fix) if keys %spelling_fix;
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -2305,7 +2335,7 @@ sub process {
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
 		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
-			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
+			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:\b|$|[^a-z@])/gi) {
 				my $typo = $1;
 				my $typo_fix = $spelling_fix{lc($typo)};
 				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

