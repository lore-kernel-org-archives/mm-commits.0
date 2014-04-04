From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:04 -0700
Message-ID: <533f092c.qAJ0pQjaHMQSxbxN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaDDTeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:04 -0700


The patch titled
     Subject: checkpatch: add test for char * arrays that could be static const
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for char * arrays that could be static const

static const char* arrays create smaller text as each function call does
not have to populate the array.

Emit a warning when char *arrays aren't static const and the array is not
apparently global by being declared in the first column.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-char-arrays-that-could-be-static-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-char-arrays-that-could-be-static-const
+++ a/scripts/checkpatch.pl
@@ -2675,6 +2675,13 @@ sub process {
 				$herecurr);
                }
 
+# check for non-global char *foo[] = {"bar", ...} declarations.
+		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
+			WARN("STATIC_CONST_CHAR_ARRAY",
+			     "char * array declaration might be better as static const\n" .
+				$herecurr);
+               }
+
 # check for function declarations without arguments like "int foo()"
 		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
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

