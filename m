From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:09:15 -0700
Message-ID: <53e3dceb.SvEVa4So8Sr/VDfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:41597 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaHGUJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:16 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so612602ykb.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to insert and delete lines to patch/file
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add ability to insert and delete lines to patch/file

This can be valuable to insert or delete blank lines as well as fix
misplaced brace or else uses.

Store indexes of lines to be added/deleted and the new lines.

When creating the --fix file, insert or delete the appropriate lines and
update the patch range information.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  141 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 11 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file
+++ a/scripts/checkpatch.pl
@@ -583,6 +583,8 @@ $chk_signoff = 0 if ($file);
 my @rawlines = ();
 my @lines = ();
 my @fixed = ();
+my @fixed_inserted = ();
+my @fixed_deleted = ();
 my $fixlinenr = -1;
 
 my $vname;
@@ -613,6 +615,8 @@ for my $filename (@ARGV) {
 	@rawlines = ();
 	@lines = ();
 	@fixed = ();
+	@fixed_inserted = ();
+	@fixed_deleted = ();
 	$fixlinenr = -1;
 }
 
@@ -1526,6 +1530,69 @@ sub report_dump {
 	our @report;
 }
 
+sub fixup_current_range {
+	my ($lineRef, $offset, $length) = @_;
+
+	if ($$lineRef =~ /^\@\@ -\d+,\d+ \+(\d+),(\d+) \@\@/) {
+		my $o = $1;
+		my $l = $2;
+		my $no = $o + $offset;
+		my $nl = $l + $length;
+		$$lineRef =~ s/\+$o,$l \@\@/\+$no,$nl \@\@/;
+	}
+}
+
+sub fix_inserted_deleted_lines {
+	my ($linesRef, $insertedRef, $deletedRef) = @_;
+
+	my $range_last_linenr = 0;
+	my $delta_offset = 0;
+
+	my $old_linenr = 0;
+	my $new_linenr = 0;
+
+	my $next_insert = 0;
+	my $next_delete = 0;
+
+	my @lines = ();
+
+	my $inserted = @{$insertedRef}[$next_insert++];
+	my $deleted = @{$deletedRef}[$next_delete++];
+
+	foreach my $old_line (@{$linesRef}) {
+		my $save_line = 1;
+		my $line = $old_line;	#don't modify the array
+		if ($line =~ /^(?:\+\+\+\|\-\-\-)\s+\S+/) {	#new filename
+			$delta_offset = 0;
+		} elsif ($line =~ /^\@\@ -\d+,\d+ \+\d+,\d+ \@\@/) {	#new hunk
+			$range_last_linenr = $new_linenr;
+			fixup_current_range(\$line, $delta_offset, 0);
+		}
+
+		while (defined($deleted) && ${$deleted}{'LINENR'} == $old_linenr) {
+			$deleted = @{$deletedRef}[$next_delete++];
+			$save_line = 0;
+			fixup_current_range(\$lines[$range_last_linenr], $delta_offset--, -1);
+		}
+
+		while (defined($inserted) && ${$inserted}{'LINENR'} == $old_linenr) {
+			push(@lines, ${$inserted}{'LINE'});
+			$inserted = @{$insertedRef}[$next_insert++];
+			$new_linenr++;
+			fixup_current_range(\$lines[$range_last_linenr], $delta_offset++, 1);
+		}
+
+		if ($save_line) {
+			push(@lines, $line);
+			$new_linenr++;
+		}
+
+		$old_linenr++;
+	}
+
+	return @lines;
+}
+
 sub ERROR {
 	my ($type, $msg) = @_;
 
@@ -2377,16 +2444,31 @@ sub process {
 		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
 		      $line =~ /^\+\s*DECLARE/ ||
 		      $line =~ /^\+\s*__setup/)) {
-			CHK("LINE_SPACING",
-			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
+			if (CHK("LINE_SPACING",
+				"Please use a blank line after function/struct/union/enum declarations\n" . $hereprev) &&
+			    $fix) {
+			my $inserted = {
+				LINENR => $fixlinenr,
+				LINE => "\+",
+			};
+			push(@fixed_inserted, $inserted);
+			}
 		}
 
 # check for multiple consecutive blank lines
 		if ($prevline =~ /^[\+ ]\s*$/ &&
 		    $line =~ /^\+\s*$/ &&
 		    $last_blank_line != ($linenr - 1)) {
-			CHK("LINE_SPACING",
-			    "Please don't use multiple blank lines\n" . $hereprev);
+			if (CHK("LINE_SPACING",
+				"Please don't use multiple blank lines\n" . $hereprev) &&
+			    $fix) {
+			my $deleted = {
+				LINENR => $fixlinenr,
+				LINE => $rawline,
+			};
+			push(@fixed_deleted, $deleted);
+			}
+
 			$last_blank_line = $linenr;
 		}
 
@@ -2424,8 +2506,15 @@ sub process {
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
 			# indentation of previous and current line are the same
 		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
-			WARN("LINE_SPACING",
-			     "Missing a blank line after declarations\n" . $hereprev);
+			if (WARN("LINE_SPACING",
+				 "Missing a blank line after declarations\n" . $hereprev) &&
+			    $fix) {
+			my $inserted = {
+				LINENR => $fixlinenr,
+				LINE => "\+",
+			};
+			push(@fixed_inserted, $inserted);
+			}
 		}
 
 # check for spaces at the beginning of a line.
@@ -2627,7 +2716,7 @@ sub process {
 			#print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
 			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
-			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
+			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln - 1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("OPEN_BRACE",
 				      "that open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
@@ -2777,8 +2866,34 @@ sub process {
 # check for initialisation to aggregates open brace on the next line
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
-			ERROR("OPEN_BRACE",
-			      "that open brace { should be on the previous line\n" . $hereprev);
+			if (ERROR("OPEN_BRACE",
+				  "that open brace { should be on the previous line\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/) {
+				my $deleted = {
+					LINENR => $fixlinenr - 1,
+					LINE => $prevrawline,
+				};
+				push(@fixed_deleted, $deleted);
+				$deleted = {
+					LINENR => $fixlinenr,
+					LINE => $rawline,
+				};
+				push(@fixed_deleted, $deleted);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/\s*=\s*$/ = {/;
+				my $inserted = {
+					LINENR => $fixlinenr,
+					LINE => $fixedline,
+				};
+				push(@fixed_inserted, $inserted);
+				$fixedline = $line;
+				$fixedline =~ s/^(.\s*){\s*/$1/;
+				$inserted = {
+					LINENR => $fixlinenr,
+					LINE => $fixedline,
+				};
+				push(@fixed_inserted, $inserted);
+			}
 		}
 
 #
@@ -4900,12 +5015,16 @@ sub process {
 	hash_show_words(\%use_type, "Used");
 	hash_show_words(\%ignore_type, "Ignored");
 
-	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
+	if ($clean == 0 && $fix &&
+	    ("@rawlines" ne "@fixed" ||
+	     $#fixed_inserted >= 0 || $#fixed_deleted >= 0)) {
 		my $newfile = $filename;
 		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
 		my $linecount = 0;
 		my $f;
 
+		@fixed = fix_inserted_deleted_lines(\@fixed, \@fixed_inserted, \@fixed_deleted);
+
 		open($f, '>', $newfile)
 		    or die "$P: Can't open $newfile for write\n";
 		foreach my $fixed_line (@fixed) {
@@ -4913,7 +5032,7 @@ sub process {
 			if ($file) {
 				if ($linecount > 3) {
 					$fixed_line =~ s/^\+//;
-					print $f $fixed_line. "\n";
+					print $f $fixed_line . "\n";
 				}
 			} else {
 				print $f $fixed_line . "\n";
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
maintainers-remove-two-ancient-eata-sections.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

