From: akpm@linux-foundation.org
Subject: + checkpatch-more-comprehensive-split-strings-warning.patch added to -mm tree
Date: Tue, 03 Dec 2013 15:15:48 -0800
Message-ID: <529e6624.8LEmE64Cu4MnVBKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3LCXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, joe@perches.com

Subject: + checkpatch-more-comprehensive-split-strings-warning.patch added to -mm tree
To: joe@perches.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:15:48 -0800


The patch titled
     Subject: checkpatch: more comprehensive split strings warning
has been added to the -mm tree.  Its filename is
     checkpatch-more-comprehensive-split-strings-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-more-comprehensive-split-strings-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-more-comprehensive-split-strings-warning.patch

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
Subject: checkpatch: more comprehensive split strings warning

The current checkpatch test for split strings does not find several cases
that should be found.

For instance:

[]
@@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 			IWL_DEBUG_RATE(mvm,
-				       "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+				       "GOING BACK TO THE OLD TABLE: SR %d "
+				       "cur-tpt %d old-tpt %d\n",
 				       window->success_ratio,
 				       window->average_tpt,
 				      lq_sta->last_tpt);

does not currently emit a warning.

Improve the test to find these cases.

Add more exceptions to reduce false positives for assembly and octal/hex
string constants.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-more-comprehensive-split-strings-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-more-comprehensive-split-strings-warning
+++ a/scripts/checkpatch.pl
@@ -2049,16 +2049,12 @@ sub process {
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
-# to grep for the string.  Limited to strings used as parameters (those
-# following an open parenthesis), which almost completely eliminates false
-# positives, as well as warning only once per parameter rather than once per
-# line of the string.  Make an exception when the previous string ends in a
-# newline (multiple lines in one string constant) or \n\t (common in inline
-# assembly to indent the instruction on the following line).
+# to grep for the string.  Make exceptions when the previous string ends in a
+# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
+# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
 		if ($line =~ /^\+\s*"/ &&
 		    $prevline =~ /"\s*$/ &&
-		    $prevline =~ /\(/ &&
-		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
 			WARN("SPLIT_STRING",
 			     "quoted string split across lines\n" . $hereprev);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
checkpatch-more-comprehensive-split-strings-warning.patch
linux-next.patch

