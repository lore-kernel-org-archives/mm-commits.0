From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-whitespace-before-semicolon-at-eol.patch added to -mm tree
Date: Tue, 29 May 2012 11:23:56 -0700
Message-ID: <20120529182356.6B075A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47296 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2E2SX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 14:23:58 -0400
Received: by were53 with SMTP id e53so259198wer.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 11:23:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.nelson@boundarydevices.com, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: check for whitespace before semicolon at EOL
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-whitespace-before-semicolon-at-eol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: checkpatch: check for whitespace before semicolon at EOL

Patches currently in -mm which might be from eric.nelson@boundarydevices.com are

checkpatch-check-for-whitespace-before-semicolon-at-eol.patch

