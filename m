From: akpm@linux-foundation.org
Subject: [merged]
 parse-maintainers-add-ability-to-specify-filenames.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:23:24 -0800
Message-ID: <20171120212324.m_tAAEC3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40090 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdKTVXZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse-maintainers: add ability to specify filenames
has been removed from the -mm tree.  Its filename was
     parse-maintainers-add-ability-to-specify-filenames.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: parse-maintainers: add ability to specify filenames

parse-maintainers.pl is convenient, but currently hard-codes the filenames
that are used.

Allow user-specified filenames to simplify the use of the script.

Link: http://lkml.kernel.org/r/48703c068b3235223ffa3b2eb268fa0a125b25e0.1502251549.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/parse-maintainers.pl |   52 +++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff -puN scripts/parse-maintainers.pl~parse-maintainers-add-ability-to-specify-filenames scripts/parse-maintainers.pl
--- a/scripts/parse-maintainers.pl~parse-maintainers-add-ability-to-specify-filenames
+++ a/scripts/parse-maintainers.pl
@@ -2,9 +2,44 @@
 # SPDX-License-Identifier: GPL-2.0
 
 use strict;
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $input_file = "MAINTAINERS";
+my $output_file = "MAINTAINERS.new";
+my $output_section = "SECTION.new";
+my $help = 0;
 
 my $P = $0;
 
+if (!GetOptions(
+		'input=s' => \$input_file,
+		'output=s' => \$output_file,
+		'section=s' => \$output_section,
+		'h|help|usage' => \$help,
+	    )) {
+    die "$P: invalid argument - use --help if necessary\n";
+}
+
+if ($help != 0) {
+    usage();
+    exit 0;
+}
+
+sub usage {
+    print <<EOT;
+usage: $P [options] <pattern matching regexes>
+
+  --input => MAINTAINERS file to read (default: MAINTAINERS)
+  --output => sorted MAINTAINERS file to write (default: MAINTAINERS.new)
+  --section => new sorted MAINTAINERS file to write to (default: SECTION.new)
+
+If <pattern match regexes> exist, then the sections that match the
+regexes are not written to the output file but are written to the
+section file.
+
+EOT
+}
+
 # sort comparison functions
 sub by_category($$) {
     my ($a, $b) = @_;
@@ -56,13 +91,20 @@ sub trim {
 sub alpha_output {
     my ($hashref, $filename) = (@_);
 
+    return if ! scalar(keys %$hashref);
+
     open(my $file, '>', "$filename") or die "$P: $filename: open failed - $!\n";
+    my $separator;
     foreach my $key (sort by_category keys %$hashref) {
 	if ($key eq " ") {
-	    chomp $$hashref{$key};
 	    print $file $$hashref{$key};
 	} else {
-	    print $file "\n" . $key . "\n";
+	    if (! defined $separator) {
+		$separator = "\n";
+	    } else {
+		print $file $separator;
+	    }
+	    print $file $key . "\n";
 	    foreach my $pattern (sort by_pattern split('\n', %$hashref{$key})) {
 		print $file ($pattern . "\n");
 	    }
@@ -112,7 +154,7 @@ sub file_input {
 my %hash;
 my %new_hash;
 
-file_input(\%hash, "MAINTAINERS");
+file_input(\%hash, $input_file);
 
 foreach my $type (@ARGV) {
     foreach my $key (keys %hash) {
@@ -123,7 +165,7 @@ foreach my $type (@ARGV) {
     }
 }
 
-alpha_output(\%hash, "MAINTAINERS.new");
-alpha_output(\%new_hash, "SECTION.new");
+alpha_output(\%hash, $output_file);
+alpha_output(\%new_hash, $output_section);
 
 exit(0);
_

Patches currently in -mm which might be from joe@perches.com are


