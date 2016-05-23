From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:51:38 -0700
Message-ID: <57435f4a.pij7ng2VM2U4m3Wm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: advertise the --fix and --fix-inplace options more
has been removed from the -mm tree.  Its filename was
     checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: advertise the --fix and --fix-inplace options more

The --fix option is relatively unknown and underutilized.

Add some text to show that it's available when style defects are found.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-advertise-the-fix-and-fix-inplace-options-more scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-advertise-the-fix-and-fix-inplace-options-more
+++ a/scripts/checkpatch.pl
@@ -5975,6 +5975,14 @@ sub process {
 	}
 
 	if ($quiet == 0) {
+		# If there were any defects found and not already fixing them
+		if (!$clean and !$fix) {
+			print << "EOM"
+
+NOTE: For some of the reported defects, checkpatch may be able to
+      mechanically convert to the typical style using --fix or --fix-inplace.
+EOM
+		}
 		# If there were whitespace errors which cleanpatch can fix
 		# then suggest that.
 		if ($rpt_cleaners) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

