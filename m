From: akpm@linux-foundation.org
Subject: + checkpatch-if-should-not-continue-a-preceeding-brace.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:24:09 -0800
Message-ID: <200901132224.n0DMO9k5027717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbZAMWZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: if should not continue a preceeding brace
has been added to the -mm tree.  Its filename is
     checkpatch-if-should-not-continue-a-preceeding-brace.patch

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
Subject: checkpatch: if should not continue a preceeding brace
From: Andy Whitcroft <apw@canonical.com>

We should not be continuing a braced section with an if, for example:

	if (...) {
	} if (...) {
	}

Detect this and suggest adding a newline.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-if-should-not-continue-a-preceeding-brace scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-if-should-not-continue-a-preceeding-brace
+++ a/scripts/checkpatch.pl
@@ -2108,6 +2108,11 @@ sub process {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
+# if should not continue a brace
+		if ($line =~ /}\s*if\b/) {
+			ERROR("trailing statements should be on next line\n" .
+				$herecurr);
+		}
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
 		    $line !~ /\G(?:
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

