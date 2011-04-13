From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-line-continuations-in-quoted-strings.patch added to -mm tree
Date: Wed, 13 Apr 2011 14:36:24 -0700
Message-ID: <201104132136.p3DLaOm4001733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932906Ab1DMVg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Apr 2011 17:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     checkpatch: add check for line continuations in quoted strings
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-line-continuations-in-quoted-strings.patch

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

linux-next.patch
maintainers-update-m68knommu-patterns.patch
maintainers-update-various-tty-patterns.patch
maintainers-change-mail-adress-of-hans-j-koch.patch
checkpatch-add-check-for-line-continuations-in-quoted-strings.patch

