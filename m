From: akpm@linux-foundation.org
Subject: +
 checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch added to -mm tree
Date: Thu, 06 Mar 2014 16:14:51 -0800
Message-ID: <53190f7b.a9r5jV04YLrvxzAi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCGAOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 19:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 16:14:51 -0800


The patch titled
     Subject: checkpatch: always warn on missing blank line after variable declaration block
has been added to the -mm tree.  Its filename is
     checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

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
Subject: checkpatch: always warn on missing blank line after variable declaration block

Make the test system wide, modify the message too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block
+++ a/scripts/checkpatch.pl
@@ -2249,8 +2249,7 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
+		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
 		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
 		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
 		    $sline =~ /^\+\s+/ &&			#Not at char 1
@@ -2260,7 +2259,7 @@ sub process {
 		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
-			     "networking uses a blank line after declarations\n" . $hereprev);
+			     "Missing a blank line after declarations\n" . $hereprev);
 		}
 
 # check for spaces at the beginning of a line.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
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
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

