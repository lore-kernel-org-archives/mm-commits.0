From: akpm@linux-foundation.org
Subject: + get_maintainerpl-add-git-min-percent-option.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:57:33 -0700
Message-ID: <200907132157.n6DLvXMj019464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571AbZGMV6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     get_maintainer.pl: Add git-min-percent option
has been added to the -mm tree.  Its filename is
     get_maintainerpl-add-git-min-percent-option.patch

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
maintainers-ia64-pair-p-m-entries-properly.patch
maintainers-remove-ivtv-user-lists-add-cx18-url.patch
maintainers-qlge-10gb-ethernet-pair-p-m-entries-properly.patch
maintainers-use-tabs-in-acer-aspire-one.patch
maintainers-remove-l-linux-kernel-vgerkernelorg.patch
maintainers-move-arpd-to-credits.patch
maintainers-update-kernel-janitors.patch
maintainers-add-pps-patterns.patch
maintainers-usb-serial-digi-acceleport-use-separate-p-for-al-borchers.patch
maintainers-input-add-dmitrys-name-to-his-email-address.patch
maintainers-remove-cs461x-sound-card-section.patch
maintainers-qlogic-qla2xxx-add-andrew-vasquez-email-address.patch
maintainers-qlogic-qla3xxx-add-ron-mercer-email-address.patch
maintainers-scott-murray-is-no-longer-with-somanetworks.patch
scripts-get_maintainerpl-add-f-directory-use.patch
get_maintainerpl-add-git-min-percent-option.patch

