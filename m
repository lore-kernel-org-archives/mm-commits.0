From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:49:47 -0700
Message-ID: <200910302049.n9UKnlK4009045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454AbZJ3Uu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: add patch/file search for keywords
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add patch/file search for keywords
From: Joe Perches <joe@perches.com>

Based on an idea from Wolfram Sang.

Add search for MAINTAINERS line "K:" regex pattern match in a patch or file
Matches are added after file pattern matches
Add --keywords command line switch (default 1, on)
Change version to 0.21

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-patch-file-search-for-keywords scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-patch-file-search-for-keywords
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.20';
+my $V = '0.21';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -37,6 +37,7 @@ my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
 my $status = 0;
+my $keywords = 1;
 my $from_filename = 0;
 my $pattern_depth = 0;
 my $version = 0;
@@ -84,6 +85,7 @@ if (!GetOptions(
 		'scm!' => \$scm,
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
+		'k|keywords!' => \$keywords,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
 		'h|help' => \$help,
@@ -132,6 +134,8 @@ if (!top_of_kernel_tree($lk_path)) {
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
+my %keyword_hash;
+
 open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS\n";
 while (<MAINT>) {
     my $line = $_;
@@ -149,6 +153,8 @@ while (<MAINT>) {
 	    if ((-d $value)) {
 		$value =~ s@([^/])$@$1/@;
 	    }
+	} elsif ($type eq "K") {
+	    $keyword_hash{@typevalue} = $value;
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -188,6 +194,7 @@ if ($email_remove_duplicates) {
 
 my @files = ();
 my @range = ();
+my @keyword_tvi = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -198,11 +205,24 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
+	if (-f $file && $keywords) {
+	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
+	    while (<FILE>) {
+		my $patch_line = $_;
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =~ m/^.*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
+	    }
+	    close(FILE);
+	}
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
+	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
@@ -213,6 +233,12 @@ foreach my $file (@ARGV) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
+	    } elsif ($keywords) {
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =~ m/^[+-].*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
 	    }
 	}
 	close(PATCH);
@@ -286,6 +312,13 @@ foreach my $file (@files) {
     }
 }
 
+if ($keywords) {
+    @keyword_tvi = sort_and_uniq(@keyword_tvi);
+    foreach my $line (@keyword_tvi) {
+	add_categories($line);
+    }
+}
+
 if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
@@ -384,6 +417,7 @@ Output type options:
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
+  --keywords => scan patch for keywords (default: 1 (on))
   --version => show version
   --help => show this help information
 
@@ -486,7 +520,6 @@ sub format_email {
 }
 
 sub find_starting_index {
-
     my ($index) = @_;
 
     while ($index > 0) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

