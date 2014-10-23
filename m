From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 11:26:14 -0700
Message-ID: <54494846.VZXJ2SHf/UJjDITr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJWS0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 14:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jani.nikula@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix use via symlink, make missing spelling file non-fatal
has been added to the -mm tree.  Its filename is
     checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch

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
Subject: checkpatch: fix use via symlink, make missing spelling file non-fatal

Commit 66b47b4a9dad ("checkpatch: look for common misspellings") made it
difficult to use checkpatch via a symlink.

Fix that and make a missing spelling.txt file non-fatal.  Emit a warning
when the spelling.txt file can not be opened.

Reference: http://xkcd.com/1172/

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal
+++ a/scripts/checkpatch.pl
@@ -7,10 +7,11 @@
 
 use strict;
 use POSIX;
+use File::Basename;
+use Cwd 'abs_path';
 
 my $P = $0;
-$P =~ s@(.*)/@@g;
-my $D = $1;
+my $D = dirname(abs_path($P));
 
 my $V = '0.32';
 
@@ -438,26 +439,29 @@ our $allowed_asm_includes = qr{(?x:
 
 # Load common spelling mistakes and build regular expression list.
 my $misspellings;
-my @spelling_list;
 my %spelling_fix;
-open(my $spelling, '<', $spelling_file)
-    or die "$P: Can't open $spelling_file for reading: $!\n";
-while (<$spelling>) {
-	my $line = $_;
 
-	$line =~ s/\s*\n?$//g;
-	$line =~ s/^\s*//g;
+if (open(my $spelling, '<', $spelling_file)) {
+	my @spelling_list;
+	while (<$spelling>) {
+		my $line = $_;
 
-	next if ($line =~ m/^\s*#/);
-	next if ($line =~ m/^\s*$/);
+		$line =~ s/\s*\n?$//g;
+		$line =~ s/^\s*//g;
 
-	my ($suspect, $fix) = split(/\|\|/, $line);
+		next if ($line =~ m/^\s*#/);
+		next if ($line =~ m/^\s*$/);
+
+		my ($suspect, $fix) = split(/\|\|/, $line);
 
-	push(@spelling_list, $suspect);
-	$spelling_fix{$suspect} = $fix;
+		push(@spelling_list, $suspect);
+		$spelling_fix{$suspect} = $fix;
+	}
+	close($spelling);
+	$misspellings = join("|", @spelling_list);
+} else {
+	warn "No typos will be found - file '$spelling_file': $!\n";
 }
-close($spelling);
-$misspellings = join("|", @spelling_list);
 
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
@@ -2246,7 +2250,7 @@ sub process {
 		}
 
 # Check for various typo / spelling mistakes
-		if ($in_commit_log || $line =~ /^\+/) {
+		if (defined($misspellings) && ($in_commit_log || $line =~ /^\+/)) {
 			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
 				my $typo = $1;
 				my $typo_fix = $spelling_fix{lc($typo)};
_

Patches currently in -mm which might be from joe@perches.com are

mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

