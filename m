From: akpm@linux-foundation.org
Subject: + checkpatch-change-externals-to-globals.patch added to -mm tree
Date: Wed, 21 Jul 2010 13:34:55 -0700
Message-ID: <201007212034.o6LKYvGB013760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab0GUUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 16:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kagen101@gmail.com, apw@shadowen.org, w.sang@pengutronix.de


The patch titled
     checkpatch: change externals to globals
has been added to the -mm tree.  Its filename is
     checkpatch-change-externals-to-globals.patch

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
Subject: checkpatch: change externals to globals
From: Joe Eloff <kagen101@gmail.com>

Make error message say 'ERROR: do not initialise globals to 0 or NULL'
rather than 'ERROR: do not initialise externals to 0 or NULL'.  Makes more
sense in the context since there is an extern keyword in C and that is a
global declaration within the scope of the current file.

Signed-off-by: Joe Eloff <kagen101@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-change-externals-to-globals scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-change-externals-to-globals
+++ a/scripts/checkpatch.pl
@@ -1791,9 +1791,9 @@ sub process {
 			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 		}
 
-# check for external initialisers.
+# check for global initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
-			ERROR("do not initialise externals to 0 or NULL\n" .
+			ERROR("do not initialise globals to 0 or NULL\n" .
 				$herecurr);
 		}
 # check for static initialisers.
_

Patches currently in -mm which might be from kagen101@gmail.com are

checkpatch-change-externals-to-globals.patch

