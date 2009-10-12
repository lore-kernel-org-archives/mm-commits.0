From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch added to -mm tree
Date: Mon, 12 Oct 2009 16:17:29 -0700
Message-ID: <200910122317.n9CNHU8S012967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758589AbZJLXST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 19:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, w.sang@pengutronix.de


The patch titled
     scripts/get_maintainer.pl: add patch/file search for keywords
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add patch/file search for keywords
=46rom: Joe Perches <joe@perches.com>

Based on an idea from Wolfram Sang.

Add search for MAINTAINERS line "K:" regex pattern match in a patch or =
file
Matches are added after file pattern matches
Add --keywords command line switch (default 1, on)
Change version to 0.21

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-patch-=
file-search-for-keywords scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-patch-file=
-search-for-keywords
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
=20
 my $P =3D $0;
-my $V =3D '0.20';
+my $V =3D '0.21';
=20
 use Getopt::Long qw(:config no_auto_abbrev);
=20
@@ -37,6 +37,7 @@ my $scm =3D 0;
 my $web =3D 0;
 my $subsystem =3D 0;
 my $status =3D 0;
+my $keywords =3D 1;
 my $from_filename =3D 0;
 my $pattern_depth =3D 0;
 my $version =3D 0;
@@ -84,6 +85,7 @@ if (!GetOptions(
 		'scm!' =3D> \$scm,
 		'web!' =3D> \$web,
 		'pattern-depth=3Di' =3D> \$pattern_depth,
+		'k|keywords!' =3D> \$keywords,
 		'f|file' =3D> \$from_filename,
 		'v|version' =3D> \$version,
 		'h|help' =3D> \$help,
@@ -132,6 +134,8 @@ if (!top_of_kernel_tree($lk_path)) {
 ## Read MAINTAINERS for type/value pairs
=20
 my @typevalue =3D ();
+my %keyword_hash;
+
 open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINE=
RS\n";
 while (<MAINT>) {
     my $line =3D $_;
@@ -149,6 +153,8 @@ while (<MAINT>) {
 	    if ((-d $value)) {
 		$value =3D~ s@([^/])$@$1/@;
 	    }
+	} elsif ($type eq "K") {
+	    $keyword_hash{@typevalue} =3D $value;
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -188,6 +194,7 @@ if ($email_remove_duplicates) {
=20
 my @files =3D ();
 my @range =3D ();
+my @keyword_tvi =3D ();
=20
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -198,11 +205,24 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
+	if (-f $file && $keywords) {
+	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
+	    while (<FILE>) {
+		my $patch_line =3D $_;
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =3D~ m/^.*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
+	    }
+	    close(FILE);
+	}
     } else {
 	my $file_cnt =3D @files;
 	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
+	    my $patch_line =3D $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename =3D $1;
 		$filename =3D~ s@^[^/]*/@@;
@@ -213,6 +233,12 @@ foreach my $file (@ARGV) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
+	    } elsif ($keywords) {
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =3D~ m/^[+-].*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
 	    }
 	}
 	close(PATCH);
@@ -286,6 +312,13 @@ foreach my $file (@files) {
     }
 }
=20
+if ($keywords) {
+    @keyword_tvi =3D sort_and_uniq(@keyword_tvi);
+    foreach my $line (@keyword_tvi) {
+	add_categories($line);
+    }
+}
+
 if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =3D~ m/^(.*):(.*)/) {
@@ -384,6 +417,7 @@ Output type options:
=20
 Other options:
   --pattern-depth =3D> Number of pattern directory traversals (default=
: 0 (all))
+  --keywords =3D> scan patch for keywords (default: 1 (on))
   --version =3D> show version
   --help =3D> show this help information
=20
@@ -486,7 +520,6 @@ sub format_email {
 }
=20
 sub find_starting_index {
-
     my ($index) =3D @_;
=20
     while ($index > 0) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
