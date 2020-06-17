From: akpm@linux-foundation.org
Subject: + checkpatch-support-deprecated-terms-checking.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 14:32:19 -0700
Message-ID: <20200617213219.wXjao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVcU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sj38.park@gmail.com, mpe@ellerman.id.au, jslaby@suse.cz, colin.king@canonical.com, sjpark@amazon.de


The patch titled
     Subject: checkpatch: support deprecated terms checking
has been added to the -mm tree.  Its filename is
     checkpatch-support-deprecated-terms-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-support-deprecated-terms-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-support-deprecated-terms-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: checkpatch: support deprecated terms checking

Patch series "Recommend denylist/allowlist instead of blacklist/whitelist:, v4.

This patchset 1) adds support of deprecated terms in the 'checkpatch.pl'
and 2) set the 'blacklist' and 'whitelist' as deprecated with replacement
suggestion of 'denylist' and 'allowlist', because the suggestions are
incontrovertible, doesn't make people hurt, and more self-explanatory.


This patch (of 2):

Some terms could be deprecated for various reasons, but it is hard to
update the entire old usages.  That said, we could at least encourage new
patches to use the suggested replacements.  This commit adds check of
deprecated terms in the 'checkpatch.pl' for that.  The script will get
deprecated terms and suggested replacements of those from
'scripts/deprecated_terms.txt' file and warn if the deprecated terms are
used.  The mechanism and the format of the file are almost the same as
that of 'spelling.txt'.  For the reason, this commit modularizes the read
of the 'spelling.txt' and reuses.

Link: http://lkml.kernel.org/r/20200611062550.20113-1-sjpark@amazon.com
Link: http://lkml.kernel.org/r/20200611062550.20113-2-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: SeongJae Park <sj38.park@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl        |   60 ++++++++++++++++++++++++---------
 scripts/deprecated_terms.txt |    5 ++
 2 files changed, 50 insertions(+), 15 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-support-deprecated-terms-checking
+++ a/scripts/checkpatch.pl
@@ -57,6 +57,7 @@ my $max_line_length = 100;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
+my $deprecated_terms_file = "$D/deprecated_terms.txt";
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
@@ -692,29 +693,40 @@ our $allowed_asm_includes = qr{(?x:
 )};
 # memory.h: ARM has a custom one
 
-# Load common spelling mistakes and build regular expression list.
-my $misspellings;
-my %spelling_fix;
+sub read_word_corrections {
+	my ($file, $fixesRef) = @_;
+	my $suspects;
 
-if (open(my $spelling, '<', $spelling_file)) {
-	while (<$spelling>) {
-		my $line = $_;
+	if (open(my $corrections, '<', $file)) {
+		while (<$corrections>) {
+			my $line = $_;
 
-		$line =~ s/\s*\n?$//g;
-		$line =~ s/^\s*//g;
+			$line =~ s/\s*\n?$//g;
+			$line =~ s/^\s*//g;
 
-		next if ($line =~ m/^\s*#/);
-		next if ($line =~ m/^\s*$/);
+			next if ($line =~ m/^\s*#/);
+			next if ($line =~ m/^\s*$/);
 
-		my ($suspect, $fix) = split(/\|\|/, $line);
+			my ($suspect, $fix) = split(/\|\|/, $line);
 
-		$spelling_fix{$suspect} = $fix;
+			$fixesRef->{$suspect} = $fix;
+		}
+		close($corrections);
+	} else {
+		warn "No correction will be found - file '$file': $!\n";
 	}
-	close($spelling);
-} else {
-	warn "No typos will be found - file '$spelling_file': $!\n";
 }
 
+# Load deprecated terms and build regular expression list.
+my %deprecated_terms_fix;
+read_word_corrections($deprecated_terms_file, \%deprecated_terms_fix);
+my $deprecated_terms = join("|", sort keys %deprecated_terms_fix) if keys %deprecated_terms_fix;
+
+# Load common spelling mistakes and build regular expression list.
+my $misspellings;
+my %spelling_fix;
+read_word_corrections($spelling_file, \%spelling_fix);
+
 if ($codespell) {
 	if (open(my $spelling, '<', $codespellfile)) {
 		while (<$spelling>) {
@@ -2956,6 +2968,24 @@ sub process {
 				}
 			}
 		}
+
+# Check for deprecated terms
+		if (defined($deprecated_terms) &&
+		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
+			while ($rawline =~ /(?:^|[^a-z@])($deprecated_terms)(?:\b|$|[^a-z@])/gi) {
+				my $deprecated_term = $1;
+				my $suggested = $deprecated_terms_fix{lc($deprecated_term)};
+				$suggested = ucfirst($suggested) if ($deprecated_term=~ /^[A-Z]/);
+				$suggested = uc($suggested) if ($deprecated_term =~ /^[A-Z]+$/);
+				my $msg_level = \&WARN;
+				$msg_level = \&CHK if ($file);
+				if (&{$msg_level}("DEPRECATED_TERM",
+						  "Use of '$deprecated_term' is deprecated, please '$suggested', instead.\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($deprecated_term)($|[^A-Za-z@])/$1$suggested$3/;
+				}
+			}
+		}
 
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
--- /dev/null
+++ a/scripts/deprecated_terms.txt
@@ -0,0 +1,5 @@
+# License: GPLv2
+#
+# The format of each line is:
+# deprecated||suggested
+#
_

Patches currently in -mm which might be from sjpark@amazon.de are

checkpatch-support-deprecated-terms-checking.patch
scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch
