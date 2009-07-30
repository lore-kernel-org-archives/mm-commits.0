From: akpm@linux-foundation.org
Subject: [merged] get_maintainerpl-add-git-min-percent-option.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:12 -0700
Message-ID: <200907302038.n6UKcCcp012754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbZG3Uin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer.pl: Add git-min-percent option
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-add-git-min-percent-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer.pl: Add git-min-percent option
From: Joe Perches <joe@perches.com>

Allow an option to control the minimum percentage of sign-offs required
before being considered a maintainer.

git-min-percent has a default value of 5

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-add-git-min-percent-option
+++ a/scripts/get_maintainer.pl
@@ -27,6 +27,7 @@ my $email_git = 1;
 my $email_git_penguin_chiefs = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
+my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -65,6 +66,7 @@ if (!GetOptions(
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
+		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -307,6 +309,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
+    --git-min-percent => minimum percentage of commits required (default: 0)
     --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
@@ -497,6 +500,7 @@ sub recent_git_signoffs {
     my $output = "";
     my $count = 0;
     my @lines = ();
+    my $total_sign_offs;
 
     if (which("git") eq "") {
 	warn("$P: git not found.  Add --nogit to options?\n");
@@ -520,17 +524,26 @@ sub recent_git_signoffs {
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
+
+    $total_sign_offs = 0;
+    foreach my $line (@lines) {
+	if ($line =~ m/([0-9]+)\s+(.*)/) {
+	    $total_sign_offs += $1;
+	} else {
+	    die("$P: Unexpected git output: ${line}\n");
+	}
+    }
+
     foreach my $line (@lines) {
 	if ($line =~ m/([0-9]+)\s+(.*)/) {
 	    my $sign_offs = $1;
 	    $line = $2;
 	    $count++;
 	    if ($sign_offs < $email_git_min_signatures ||
-	        $count > $email_git_max_maintainers) {
+	        $count > $email_git_max_maintainers ||
+		$sign_offs * 100 / $total_sign_offs < $email_git_min_percent) {
 		last;
 	    }
-	} else {
-	    die("$P: Unexpected git output: ${line}\n");
 	}
 	if ($line =~ m/(.+)<(.+)>/) {
 	    my $git_name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

