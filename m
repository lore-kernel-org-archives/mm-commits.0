From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-declaration-with-storage-class-not-at-the-beginning.patch added to -mm tree
Date: Fri, 21 May 2010 13:49:05 -0700
Message-ID: <201005212049.o4LKn5MA000816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0EUUta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 16:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, apw@shadowen.org, khali@linux-fr.org


The patch titled
     checkpatch: warn on declaration with storage class not at the beginning
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-declaration-with-storage-class-not-at-the-beginning.patch

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
Subject: checkpatch: warn on declaration with storage class not at the beginning
From: Tobias Klauser <tklauser@distanz.ch>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-declaration-with-storage-class-not-at-the-beginning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-declaration-with-storage-class-not-at-the-beginning
+++ a/scripts/checkpatch.pl
@@ -2601,6 +2601,11 @@ sub process {
 			CHK("architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
+# Check that the storage class is at the beginning of a declaration
+		if ($line =~ /\b$Storage\b/ && $line !~ /^.\s*$Storage\b/) {
+			WARN("storage class should be at the beginning of the declaration\n" . $herecurr)
+		}
+
 # check the location of the inline attribute, that it is between
 # storage class and type.
 		if ($line =~ /\b$Type\s+$Inline\b/ ||
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
linux-next.patch
checkpatch-warn-on-declaration-with-storage-class-not-at-the-beginning.patch

