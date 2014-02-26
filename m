From: akpm@linux-foundation.org
Subject: + checkpatch-use-a-more-consistent-function-argument-style.patch
 added to -mm tree
Date: Wed, 26 Feb 2014 15:32:53 -0800
Message-ID: <530e79a5.x6eDa7uBJz968vjG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaBZXcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-use-a-more-consistent-function-argument-style.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:32:53 -0800


The patch titled
     Subject: checkpatch: use a more consistent function argument style
has been added to the -mm tree.  Its filename is
     checkpatch-use-a-more-consistent-function-argument-style.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-use-a-more-consistent-function-argument-style.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-use-a-more-consistent-function-argument-style.patch

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
Subject: checkpatch: use a more consistent function argument style

Instead of array indexing $_, use temporary variables like all the other
subroutines in the script use.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-use-a-more-consistent-function-argument-style scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-use-a-more-consistent-function-argument-style
+++ a/scripts/checkpatch.pl
@@ -1431,21 +1431,25 @@ sub possible {
 my $prefix = '';
 
 sub show_type {
-	return defined $use_type{$_[0]} if (scalar keys %use_type > 0);
+	my ($type) = @_;
 
-	return !defined $ignore_type{$_[0]};
+	return defined $use_type{$type} if (scalar keys %use_type > 0);
+
+	return !defined $ignore_type{$type};
 }
 
 sub report {
-	if (!show_type($_[1]) ||
-	    (defined $tst_only && $_[2] !~ /\Q$tst_only\E/)) {
+	my ($level, $type, $msg) = @_;
+
+	if (!show_type($type) ||
+	    (defined $tst_only && $msg !~ /\Q$tst_only\E/)) {
 		return 0;
 	}
 	my $line;
 	if ($show_types) {
-		$line = "$prefix$_[0]:$_[1]: $_[2]\n";
+		$line = "$prefix$level:$type: $msg\n";
 	} else {
-		$line = "$prefix$_[0]: $_[2]\n";
+		$line = "$prefix$level: $msg\n";
 	}
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
@@ -1453,12 +1457,15 @@ sub report {
 
 	return 1;
 }
+
 sub report_dump {
 	our @report;
 }
 
 sub ERROR {
-	if (report("ERROR", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if (report("ERROR", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_error++;
 		return 1;
@@ -1466,7 +1473,9 @@ sub ERROR {
 	return 0;
 }
 sub WARN {
-	if (report("WARNING", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if (report("WARNING", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_warn++;
 		return 1;
@@ -1474,7 +1483,9 @@ sub WARN {
 	return 0;
 }
 sub CHK {
-	if ($check && report("CHECK", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if ($check && report("CHECK", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_chk++;
 		return 1;
_

Patches currently in -mm which might be from joe@perches.com are

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
maintainers-update-l-misuses.patch
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

