From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:08 -0700
Message-ID: <533f0930.Qq1sSa38Pp1Z9Jte%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaDDTeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:08 -0700


The patch titled
     Subject: checkpatch: ignore networking block comment style first lines in file
has been removed from the -mm tree.  Its filename was
     checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: ignore networking block comment style first lines in file

It's very common to have normal block comments for the initial comments of
a file description preface.

So for files in drivers/net and net/ don't emit a warning when the first
comment block in the file uses the normal block comment style and not the
networking block comment style.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-networking-block-comment-style-first-lines-in-file scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-networking-block-comment-style-first-lines-in-file
+++ a/scripts/checkpatch.pl
@@ -2219,7 +2219,8 @@ sub process {
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
-		    $rawline =~ /^\+[ \t]*\*/) {
+		    $rawline =~ /^\+[ \t]*\*/ &&
+		    $realline > 2) {
 			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

