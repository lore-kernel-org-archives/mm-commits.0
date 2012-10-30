From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-unnecessary-line-continuations.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:15:29 -0700
Message-ID: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51949 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab2J3VPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:15:32 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so49378wib.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:15:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, peter@hurleysoftware.com


The patch titled
     Subject: checkpatch: warn on unnecessary line continuations
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-unnecessary-line-continuations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-improve-network-block-comment-style-checking.patch
linux-next.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

