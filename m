From: akpm@linux-foundation.org
Subject: [nacked]
 checkpatchpl-add-switch-to-turn-off-check-for-change-id.patch removed from
 -mm tree
Date: Tue, 01 Mar 2016 15:39:05 -0800
Message-ID: <56d62819.HuD1vccEXyKplFQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbcCAXjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 18:39:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwane.pottratz@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: add switch to turn off check for Change-Id
has been removed from the -mm tree.  Its filename was
     checkpatchpl-add-switch-to-turn-off-check-for-change-id.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: "Pottratz, Dwane" <dwane.pottratz@intel.com>
Subject: checkpatch.pl: add switch to turn off check for Change-Id

A commit hook for the Gerrit code review servers inserts change
identifiers.  These identifiers are noise in the context of the upstream
kernel.  However, they are needed in most development environments and the
error needs to be ignored for static analysis tools.

Signed-off-by: Dwane Pottratz <dwane.pottratz@intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-switch-to-turn-off-check-for-change-id scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-switch-to-turn-off-check-for-change-id
+++ a/scripts/checkpatch.pl
@@ -21,6 +21,7 @@ use Getopt::Long qw(:config no_auto_abbr
 my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
+my $chk_changeid = 1;
 my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
@@ -64,6 +65,7 @@ Options:
   -q, --quiet                quiet
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-changeid              do not check for 'Change-Id' line
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -136,6 +138,7 @@ GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'changeid!'	=> \$chk_changeid,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -2332,7 +2335,7 @@ sub process {
 		}
 
 # Check for unwanted Gerrit info
-		if ($in_commit_log && $line =~ /^\s*change-id:/i) {
+		if ($in_commit_log && $line =~ /^\s*change-id:/i && $chk_changeid) {
 			ERROR("GERRIT_CHANGE_ID",
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from dwane.pottratz@intel.com are


