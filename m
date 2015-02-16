From: akpm@linux-foundation.org
Subject: [merged] checkpatch-try-to-avoid-poor-patch-subject-lines.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:36 -0800
Message-ID: <54e25060.+J+UnpPTBc5kMl2O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbBPUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: try to avoid poor patch subject lines
has been removed from the -mm tree.  Its filename was
     checkpatch-try-to-avoid-poor-patch-subject-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: try to avoid poor patch subject lines

Naming the tool that found an issue in the subject line isn't very useful.
 Emit a warning when a common tool (currently checkpatch, sparse or
smatch) is in the subject line.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-try-to-avoid-poor-patch-subject-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-try-to-avoid-poor-patch-subject-lines
+++ a/scripts/checkpatch.pl
@@ -2170,6 +2170,13 @@ sub process {
 			}
 		}
 
+# Check email subject for common tools that don't need to be mentioned
+		if ($in_header_lines &&
+		    $line =~ /^Subject:.*\b(?:checkpatch|sparse|smatch)\b[^:]/i) {
+			WARN("EMAIL_SUBJECT",
+			     "A patch subject line should describe the change not the tool that found it\n" . $herecurr);
+		}
+
 # Check for old stable address
 		if ($line =~ /^\s*cc:\s*.*<?\bstable\@kernel\.org\b>?.*$/i) {
 			ERROR("STABLE_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

