From: akpm@linux-foundation.org
Subject: + checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch added to -mm tree
Date: Fri, 22 Apr 2016 14:36:13 -0700
Message-ID: <571a994d.KvgU8l/3y1K70XbK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcDVVgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: advertise the --fix and --fix-inplace options more
has been added to the -mm tree.  Its filename is
     checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch

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

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch

