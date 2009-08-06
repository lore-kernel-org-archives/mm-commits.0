From: akpm@linux-foundation.org
Subject: + checkincludespl-add-option-to-remove-duplicates-in-place.patch added to -mm tree
Date: Wed, 05 Aug 2009 19:00:02 -0700
Message-ID: <200908060200.n76202PO015280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbZHFCAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 22:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org


The patch titled
     checkincludes.pl: add option to remove duplicates in place
has been added to the -mm tree.  Its filename is
     checkincludespl-add-option-to-remove-duplicates-in-place.patch

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
Subject: checkincludes.pl: add option to remove duplicates in place
From: "Luis R. Rodriguez" <lrodriguez@Atheros.com>

checkincludes.pl is more useful if it actually removed the lines.  This
adds support for that with -r.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |   57 +++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff -puN scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place
+++ a/scripts/checkincludes.pl
@@ -2,32 +2,77 @@
 #
 # checkincludes: Find files included more than once in (other) files.
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
+# Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
 
 sub usage {
-	print "Usage: checkincludes.pl <file list>\n";
+	print "Usage: checkincludes.pl [-r]\n";
+	print "By default we just warn of duplicates\n";
+	print "To remove files in place use -r\n";
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

checkincludespl-close-file-as-soon-as-were-done-with-it.patch
checkincludespl-provide-usage-helper.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
checkincludespl-add-option-to-remove-duplicates-in-place-fix.patch

