From: akpm@linux-foundation.org
Subject: [merged] checkincludespl-add-option-to-remove-duplicates-in-place.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:29 -0700
Message-ID: <200909232004.n8NK4Tsc021373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbZIWUJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     checkincludes.pl: add option to remove duplicates in place
has been removed from the -mm tree.  Its filename was
     checkincludespl-add-option-to-remove-duplicates-in-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkincludes.pl: add option to remove duplicates in place
From: "Luis R. Rodriguez" <lrodriguez@Atheros.com>

checkincludes.pl is more useful if it actually removed the lines.  This
adds support for that with -r.

[akpm@linux-foundation.org: improve usage message]
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |   66 +++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 7 deletions(-)

diff -puN scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place
+++ a/scripts/checkincludes.pl
@@ -1,33 +1,85 @@
 #!/usr/bin/perl
 #
-# checkincludes: Find files included more than once in (other) files.
+# checkincludes: find/remove files included more than once
+#
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
+# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# This script checks for duplicate includes. It also has support
+# to remove them in place. Note that this will not take into
+# consideration macros so you should run this only if you know
+# you do have real dups and do not have them under #ifdef's. You
+# could also just review the results.
 
 sub usage {
-	print "Usage: checkincludes.pl <file list>\n";
+	print "Usage: checkincludes.pl [-r]\n";
+	print "By default we just warn of duplicates\n";
+	print "To remove duplicated includes in place use -r\n";
 	exit 1;
 }
 
+my $remove = 0;
+
 if ($#ARGV < 0) {
-        usage();
+	usage();
+}
+
+if ($#ARGV >= 1) {
+	if ($ARGV[0] =~ /^-/) {
+		if ($ARGV[0] eq "-r") {
+			$remove = 1;
+			shift;
+		} else {
+			usage();
+		}
+	}
 }
 
 foreach $file (@ARGV) {
 	open(FILE, $file) or die "Cannot open $file: $!.\n";
 
 	my %includedfiles = ();
+	my @file_lines = ();
 
 	while (<FILE>) {
 		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
 			++$includedfiles{$1};
 		}
+		push(@file_lines, $_);
 	}
 
 	close(FILE);
-	
-	foreach $filename (keys %includedfiles) {
-		if ($includedfiles{$filename} > 1) {
-			print "$file: $filename is included more than once.\n";
+
+	if (!$remove) {
+		foreach $filename (keys %includedfiles) {
+			if ($includedfiles{$filename} > 1) {
+				print "$file: $filename is included more than once.\n";
+			}
 		}
+		next;
 	}
+
+	open(FILE,">$file") || die("Cannot write to $file: $!");
+
+	my $dups = 0;
+	foreach (@file_lines) {
+		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
+			foreach $filename (keys %includedfiles) {
+				if ($1 eq $filename) {
+					if ($includedfiles{$filename} > 1) {
+						$includedfiles{$filename}--;
+						$dups++;
+					} else {
+						print FILE $_;
+					}
+				}
+			}
+		} else {
+			print FILE $_;
+		}
+	}
+	if ($dups > 0) {
+		print "$file: removed $dups duplicate includes\n";
+	}
+	close(FILE);
 }
_

Patches currently in -mm which might be from lrodriguez@Atheros.com are

origin.patch
linux-next.patch

