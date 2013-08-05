From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-types-option-to-report-only-specific-message-types.patch
 added to -mm tree
Date: Mon, 05 Aug 2013 13:53:03 -0700
Message-ID: <520010af.jMATYCHMr1tE8/dU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3HEUxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-types-option-to-report-only-specific-message-types.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:53:03 -0700


The patch titled
     Subject: checkpatch: add --types option to report only specific message types
has been added to the -mm tree.  Its filename is
     checkpatch-add-types-option-to-report-only-specific-message-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-types-option-to-report-only-specific-message-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-types-option-to-report-only-specific-message-types.patch

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
Subject: checkpatch: add --types option to report only specific message types

Add a --types convenience option to show only specific message types. 
Combined with the --fix option, this can produce specific suggested
formatting patches to files.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   56 +++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-types-option-to-report-only-specific-message-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-types-option-to-report-only-specific-message-types
+++ a/scripts/checkpatch.pl
@@ -31,8 +31,10 @@ my $show_types = 0;
 my $fix = 0;
 my $root;
 my %debug;
-my %ignore_type = ();
 my %camelcase = ();
+my %use_type = ();
+my @use = ();
+my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
@@ -56,6 +58,7 @@ Options:
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
   --show-types               show the message "types" in the output
@@ -120,6 +123,7 @@ GetOptions(
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
+	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
 	'root=s'	=> \$root,
@@ -150,19 +154,38 @@ if ($#ARGV < 0) {
 	exit(1);
 }
 
-@ignore = split(/,/, join(',',@ignore));
-foreach my $word (@ignore) {
-	$word =~ s/\s*\n?$//g;
-	$word =~ s/^\s*//g;
-	$word =~ s/\s+/ /g;
-	$word =~ tr/[a-z]/[A-Z]/;
+sub hash_save_array_words {
+	my ($hashRef, $arrayRef) = @_;
+
+	my @array = split(/,/, join(',', @$arrayRef));
+	foreach my $word (@array) {
+		$word =~ s/\s*\n?$//g;
+		$word =~ s/^\s*//g;
+		$word =~ s/\s+/ /g;
+		$word =~ tr/[a-z]/[A-Z]/;
+
+		next if ($word =~ m/^\s*#/);
+		next if ($word =~ m/^\s*$/);
+
+		$hashRef->{$word}++;
+	}
+}
 
-	next if ($word =~ m/^\s*#/);
-	next if ($word =~ m/^\s*$/);
+sub hash_show_words {
+	my ($hashRef, $prefix) = @_;
 
-	$ignore_type{$word}++;
+	if ($quiet == 0 && keys $hashRef) {
+		print "NOTE: $prefix message types:";
+		foreach my $word (sort keys $hashRef) {
+			print " $word";
+		}
+		print "\n\n";
+	}
 }
 
+hash_save_array_words(\%ignore_type, \@ignore);
+hash_save_array_words(\%use_type, \@use);
+
 my $dbg_values = 0;
 my $dbg_possible = 0;
 my $dbg_type = 0;
@@ -1367,7 +1390,9 @@ sub possible {
 my $prefix = '';
 
 sub show_type {
-       return !defined $ignore_type{$_[0]};
+	return defined $use_type{$_[0]} if (scalar keys %use_type > 0);
+
+	return !defined $ignore_type{$_[0]};
 }
 
 sub report {
@@ -4190,13 +4215,8 @@ sub process {
 		}
 	}
 
-	if ($quiet == 0 && keys %ignore_type) {
-	    print "NOTE: Ignored message types:";
-	    foreach my $ignore (sort keys %ignore_type) {
-		print " $ignore";
-	    }
-	    print "\n\n";
-	}
+	hash_show_words(\%use_type, "Used");
+	hash_show_words(\%ignore_type, "Ignored");
 
 	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
 		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
linux-next.patch

