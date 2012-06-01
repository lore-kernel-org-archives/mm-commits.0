From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-for-whitespace-before-semicolon-at-eol.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:10 -0700
Message-ID: <20120601193310.66C89A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54439 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2FATdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:12 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so140369wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.nelson@boundarydevices.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for whitespace before semicolon at EOL
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-whitespace-before-semicolon-at-eol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric Nelson <eric.nelson@boundarydevices.com>
Subject: checkpatch: check for whitespace before semicolon at EOL

Requires --strict option during invocation:
	~/linux$ scripts/checkpatch --strict foo.patch

This tests for a bad habits of mine like this:

	return 0 ;

Note that it does allow a special case of a bare semicolon
for empty loops:

	while (foo())
		;

Signed-off-by: Eric Nelson <eric.nelson@boundarydevices.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-whitespace-before-semicolon-at-eol scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-whitespace-before-semicolon-at-eol
+++ a/scripts/checkpatch.pl
@@ -2448,6 +2448,13 @@ sub process {
 				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
+
+# check for whitespace before a non-naked semicolon
+		if ($line =~ /^\+.*\S\s+;/) {
+			CHK("SPACING",
+			    "space prohibited before semicolon\n" . $herecurr);
+		}
+
 # Check operator spacing.
 		if (!($line=~/\#\s*include/)) {
 			my $ops = qr{
_

Patches currently in -mm which might be from eric.nelson@boundarydevices.com are

origin.patch

