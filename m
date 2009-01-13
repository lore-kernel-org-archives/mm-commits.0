From: akpm@linux-foundation.org
Subject: + checkpatch-struct-seq_operations-should-normally-be-const.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:24:11 -0800
Message-ID: <200901132224.n0DMOBXG027720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460AbZAMWZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:25:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, mingo@elte.hu


The patch titled
     checkpatch: struct seq_operations should normally be const
has been added to the -mm tree.  Its filename is
     checkpatch-struct-seq_operations-should-normally-be-const.patch

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
Subject: checkpatch: struct seq_operations should normally be const
From: Andy Whitcroft <apw@canonical.com>

In the general use case struct seq_operations should be a const object. 
Check for and warn where it is not.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-struct-seq_operations-should-normally-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-struct-seq_operations-should-normally-be-const
+++ a/scripts/checkpatch.pl
@@ -2527,9 +2527,10 @@ sub process {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
 # check for struct file_operations, ensure they are const.
-		if ($line =~ /\bstruct\s+file_operations\b/ &&
-		    $line !~ /\bconst\b/) {
-			WARN("struct file_operations should normally be const\n" . $herecurr);
+		if ($line !~ /\bconst\b/ &&
+		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+			WARN("struct $1 should normally be const\n" .
+				$herecurr);
 		}
 
 # use of NR_CPUS is usually wrong
_

Patches currently in -mm which might be from apw@canonical.com are

sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
checkpatch-handle-missing-if-open-in-context.patch
checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch
checkpatch-allow-parentheses-on-return-handle-array-values.patch
checkpatch-if-should-not-continue-a-preceeding-brace.patch
checkpatch-struct-seq_operations-should-normally-be-const.patch
checkpatch-version-027.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

