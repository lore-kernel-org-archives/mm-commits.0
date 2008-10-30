From: akpm@linux-foundation.org
Subject: - fix-incompatibility-with-versions-of-perl-less-than-560.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:51 -0700
Message-ID: <200810301904.m9UJ4pQS024957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095AbYJ3TE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhuntwork@lightcubesolutions.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Fix incompatibility with versions of Perl less than 5.6.0
has been removed from the -mm tree.  Its filename was
     fix-incompatibility-with-versions-of-perl-less-than-560.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix incompatibility with versions of Perl less than 5.6.0
From: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>

Fix headers_install.pl and headers_check.pl to be compatible with versions
of Perl less than 5.6.0.  It has been tested with Perl 5.005_03 and 5.8.8.
I realize this may not be an issue for most people, but there will still
be some that hit it, I imagine.  There are three basic issues:

1. Prior to 5.6.0 open() only used 2 arguments, and the versions of
the scripts in 2.6.27.1 use 3.
2. 5.6.0 also introduced the ability to use uninitialized scalar
variables as file handles, which the current scripts make use of.
3. Lastly, 5.6.0 also introduced the pragma 'use warnings'. We can use
the -w switch and be backwards compatible.

Signed-off-by: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl   |   10 +++++-----
 scripts/headers_install.pl |   17 +++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff -puN scripts/headers_check.pl~fix-incompatibility-with-versions-of-perl-less-than-560 scripts/headers_check.pl
--- a/scripts/headers_check.pl~fix-incompatibility-with-versions-of-perl-less-than-560
+++ a/scripts/headers_check.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
@@ -17,7 +17,6 @@
 # 2) TODO: check for leaked CONFIG_ symbols
 
 use strict;
-use warnings;
 
 my ($dir, $arch, @files) = @ARGV;
 
@@ -27,14 +26,15 @@ my $lineno = 0;
 my $filename;
 
 foreach my $file (@files) {
+	local *FH;
 	$filename = $file;
-	open(my $fh, '<', "$filename") or die "$filename: $!\n";
+	open(FH, "<$filename") or die "$filename: $!\n";
 	$lineno = 0;
-	while ($line = <$fh>) {
+	while ($line = <FH>) {
 		$lineno++;
 		check_include();
 	}
-	close $fh;
+	close FH;
 }
 exit $ret;
 
diff -puN scripts/headers_install.pl~fix-incompatibility-with-versions-of-perl-less-than-560 scripts/headers_install.pl
--- a/scripts/headers_install.pl~fix-incompatibility-with-versions-of-perl-less-than-560
+++ a/scripts/headers_install.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # headers_install prepare the listed header files for use in
 # user space and copy the files to their destination.
@@ -17,28 +17,29 @@
 # 3) Drop all sections defined out by __KERNEL__ (using unifdef)
 
 use strict;
-use warnings;
 
 my ($readdir, $installdir, $arch, @files) = @ARGV;
 
 my $unifdef = "scripts/unifdef -U__KERNEL__";
 
 foreach my $file (@files) {
+	local *INFILE;
+	local *OUTFILE;
 	my $tmpfile = "$installdir/$file.tmp";
-	open(my $infile, '<', "$readdir/$file")
+	open(INFILE, "<$readdir/$file")
 		or die "$readdir/$file: $!\n";
-	open(my $outfile, '>', "$tmpfile") or die "$tmpfile: $!\n";
-	while (my $line = <$infile>) {
+	open(OUTFILE, ">$tmpfile") or die "$tmpfile: $!\n";
+	while (my $line = <INFILE>) {
 		$line =~ s/([\s(])__user\s/$1/g;
 		$line =~ s/([\s(])__force\s/$1/g;
 		$line =~ s/([\s(])__iomem\s/$1/g;
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
 		$line =~ s/^#include <linux\/compiler.h>//;
-		printf $outfile "%s", $line;
+		printf OUTFILE "%s", $line;
 	}
-	close $outfile;
-	close $infile;
+	close OUTFILE;
+	close INFILE;
 	system $unifdef . " $tmpfile > $installdir/$file";
 	unlink $tmpfile;
 }
_

Patches currently in -mm which might be from jhuntwork@lightcubesolutions.com are

linux-next.patch

