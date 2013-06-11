From: akpm@linux-foundation.org
Subject: +
 checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 15:50:34 -0700
Message-ID: <51b7a9ba.omr6c7qo3ylv39/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3FKWuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:34 -0700


The patch titled
     Subject: checkpatch: warn when networking block comment lines don't start with *
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch

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
Subject: checkpatch: warn when networking block comment lines don't start with *

Some block comments in network are written as:

	/* block comment line 1
	   block comment line 2
	 */

Emit a warning on the "block comment line 2" because it should be

	/* block comment line 1
	 * block comment line 2
	 */

This warning is only emitted on the second line of a block comment.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-networking-block-comment-lines-dont-start-with scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-networking-block-comment-lines-dont-start-with
+++ a/scripts/checkpatch.pl
@@ -1898,6 +1898,14 @@ sub process {
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $prevrawline =~ /^\+[ \t]*\/\*/ &&		#starting /*
+		    $prevrawline !~ /\*\/[ \t]*$/ &&		#no trailing */
+		    $rawline !~ /^\+[ \t]*\*/) {		#no leading *
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments start with * on subsequent lines\n" . $hereprev);
+		}
+
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch

