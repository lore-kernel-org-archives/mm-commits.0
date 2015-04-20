From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-spell-checking-of-email-subject-line.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:16:51 -0700
Message-ID: <553550a3.E2P4zALTBXoIitXf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbDTTKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jani.nikula@intel.com, jani.nikula@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add spell checking of email subject line
has been removed from the -mm tree.  Its filename was
     checkpatch-add-spell-checking-of-email-subject-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add spell checking of email subject line

Only commit log and patch additions are checked for typos and spelling
errors currently.  Add a check of the email subject line too.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
Tested-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-spell-checking-of-email-subject-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-spell-checking-of-email-subject-line
+++ a/scripts/checkpatch.pl
@@ -2303,7 +2303,8 @@ sub process {
 		}
 
 # Check for various typo / spelling mistakes
-		if (defined($misspellings) && ($in_commit_log || $line =~ /^\+/)) {
+		if (defined($misspellings) &&
+		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
 			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
 				my $typo = $1;
 				my $typo_fix = $spelling_fix{lc($typo)};
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

