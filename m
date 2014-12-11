From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-pointer-comparison-to-null-test.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:05:43 -0800
Message-ID: <5489eb07.5ILpl1Yh246gplIR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLKTFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict "pointer comparison to NULL" test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-pointer-comparison-to-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict "pointer comparison to NULL" test

It seems there are more and more uses of "if (!ptr)" in preference to "if
(ptr == NULL)" so add a --strict test to emit a message when using the
latter form.

This also finds (ptr != NULL).

Fix it too if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-pointer-comparison-to-null-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-pointer-comparison-to-null-test
+++ a/scripts/checkpatch.pl
@@ -4522,6 +4522,20 @@ sub process {
 			     "Possible precedence defect with mask then right shift - may need parentheses\n" . $herecurr);
 		}
 
+# check for pointer comparisons to NULL
+		if ($^V && $^V ge 5.10.0) {
+			while ($line =~ /\b$LvalOrFunc\s*(==|\!=)\s*NULL\b/g) {
+				my $val = $1;
+				my $equal = "!";
+				$equal = "" if ($4 eq "!=");
+				if (CHK("COMPARISON_TO_NULL",
+					"Comparison to NULL could be written \"${equal}${val}\"\n" . $herecurr) &&
+					    $fix) {
+					$fixed[$fixlinenr] =~ s/\b\Q$val\E\s*(?:==|\!=)\s*NULL\b/$equal$val/;
+				}
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

