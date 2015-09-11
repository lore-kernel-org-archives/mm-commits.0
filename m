From: akpm@linux-foundation.org
Subject: [merged] checkpatch-always-check-block-comment-styles.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:21 -0700
Message-ID: <55f31985.u5IE56FG/if+xQQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbIKSMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: always check block comment styles
has been removed from the -mm tree.  Its filename was
     checkpatch-always-check-block-comment-styles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: always check block comment styles

Some of the block comment tests that are used only for networking are
appropriate for all patches.

For example, these styles are not encouraged:

	/*
	 block comment without introductory *
	*/
and
	/*
	 * block comment with line terminating */

Remove the networking specific test and add comments.

There are some infrequent false positives where code is lazily
commented out using /* and */ rather than using #if 0/#endif blocks
like:
	/* case foo:
	case bar: */
	case baz:

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-always-check-block-comment-styles scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-always-check-block-comment-styles
+++ a/scripts/checkpatch.pl
@@ -2751,6 +2751,8 @@ sub process {
 			}
 		}
 
+# Block comment styles
+# Networking with an initial /*
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
 		    $rawline =~ /^\+[ \t]*\*/ &&
@@ -2759,22 +2761,23 @@ sub process {
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $prevrawline =~ /^\+[ \t]*\/\*/ &&		#starting /*
+# Block comments use * on subsequent lines
+		if ($prevline =~ /$;[ \t]*$/ &&			#ends in comment
+		    $prevrawline =~ /^\+.*?\/\*/ &&		#starting /*
 		    $prevrawline !~ /\*\/[ \t]*$/ &&		#no trailing */
 		    $rawline =~ /^\+/ &&			#line is new
 		    $rawline !~ /^\+[ \t]*\*/) {		#no leading *
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments start with * on subsequent lines\n" . $hereprev);
+			WARN("BLOCK_COMMENT_STYLE",
+			     "Block comments use * on subsequent lines\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
+# Block comments use */ on trailing lines
+		if ($rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
 		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {	#non blank */
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+			WARN("BLOCK_COMMENT_STYLE",
+			     "Block comments use a trailing */ on a separate line\n" . $herecurr);
 		}
 
 # check for missing blank lines after struct/union declarations
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

