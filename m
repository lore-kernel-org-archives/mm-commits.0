From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-check-for-line-continuations-in-quoted-strings.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:26 -0700
Message-ID: <201105252030.p4PKUnwH014995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932590Ab1EYUsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add check for line continuations in quoted strings
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-line-continuations-in-quoted-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add check for line continuations in quoted strings
From: Joe Perches <joe@perches.com>

Add a warning for unterminated quoted strings with line continuations as
these frequently add unwanted whitespace.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-line-continuations-in-quoted-strings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-line-continuations-in-quoted-strings
+++ a/scripts/checkpatch.pl
@@ -2748,6 +2748,11 @@ sub process {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for line continuations in quoted strings with odd counts of "
+		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
+			WARN("Avoid line continuations in quoted strings\n" . $herecurr);
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
checkpatch-suggest-using-min_t-or-max_t.patch

