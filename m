From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-unnecessary-line-continuations.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:31 -0800
Message-ID: <20121218201032.18B6D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:36534 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:34 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63576eaa.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on unnecessary line continuations
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-unnecessary-line-continuations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on unnecessary line continuations

When the previous line is not a line continuation and the current line has
a line continuation but is not a #define, emit a warning.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-line-continuations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-line-continuations
+++ a/scripts/checkpatch.pl
@@ -3013,6 +3013,15 @@ sub process {
 					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
+
+# check for line continuations outside of #defines
+
+		} else {
+			if ($prevline !~ /^..*\\$/ &&
+			    $line =~ /^\+.*\\$/) {
+				WARN("LINE_CONTINUATIONS",
+				     "Avoid unnecessary line continuations\n" . $herecurr);
+			}
 		}
 
 # do {} while (0) macro tests:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

