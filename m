From: akpm@linux-foundation.org
Subject: + checkpatch-struct-file_operations-should-normally-be-const.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:46 -0800
Message-ID: <200812090004.mB904kqQ031261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYLIAOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     checkpatch: struct file_operations should normally be const
has been added to the -mm tree.  Its filename is
     checkpatch-struct-file_operations-should-normally-be-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: struct file_operations should normally be const
From: Andy Whitcroft <apw@canonical.com>

In the general use case struct file_operations should be a const object. 
Check for and warn where it is not.  As suggested by Steven and Ingo.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-struct-file_operations-should-normally-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-struct-file_operations-should-normally-be-const
+++ a/scripts/checkpatch.pl
@@ -2509,6 +2509,11 @@ sub process {
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+# check for struct file_operations, ensure they are const.
+		if ($line =~ /\bstruct\s+file_operations\b/ &&
+		    $line !~ /\bconst\b/) {
+			WARN("struct file_operations should normally be const\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
checkpatch-update-copyrights.patch
checkpatch-add-warning-for-p0-patches.patch
checkpatch-allow-parentheses-on-return-for-comparisons.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch
checkpatch-loosen-spacing-on-typedef-function-checks.patch
checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch
checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch
checkpatch-do-not-report-nr_static-as-a-static-declaration.patch
checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
checkpatch-fix-the-perlcritic-errors.patch
checkpatch-version-026.patch

