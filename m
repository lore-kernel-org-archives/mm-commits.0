From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-fix-strim-semantics-for-strings-that-have-only-blanks.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:10 -0700
Message-ID: <201111012116.pA1LGAIu008155@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, andre.goddard@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: fix strim() semantics for strings that have only blanks
has been removed from the -mm tree.  Its filename was
     lib-stringc-fix-strim-semantics-for-strings-that-have-only-blanks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: lib/string.c: fix strim() semantics for strings that have only blanks

Commit 84c95c9acf0 ("string: on strstrip(), first remove leading spaces
before running over str") improved the performance of the strim()
function.

Unfortunately this changed the semantics of strim() and broke my code. 
Before the patch it was possible to use strim() without using the return
value for removing trailing spaces from strings that had either only
blanks or only trailing blanks.

Now this does not work any longer for strings that *only* have blanks.

Before patch: "   " -> ""    (empty string)
After patch:  "   " -> "   " (no change)

I think we should remove your patch to restore the old behavior.

The description (lib/string.c):

 * Note that the first trailing whitespace is replaced with a %NUL-terminator

=> The first trailing whitespace of a string that only has whitespace
   characters is the first whitespace

The patch restores the old strim() semantics.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Andre Goddard Rosa <andre.goddard@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/string.c~lib-stringc-fix-strim-semantics-for-strings-that-have-only-blanks lib/string.c
--- a/lib/string.c~lib-stringc-fix-strim-semantics-for-strings-that-have-only-blanks
+++ a/lib/string.c
@@ -360,7 +360,6 @@ char *strim(char *s)
 	size_t size;
 	char *end;
 
-	s = skip_spaces(s);
 	size = strlen(s);
 	if (!size)
 		return s;
@@ -370,7 +369,7 @@ char *strim(char *s)
 		end--;
 	*(end + 1) = '\0';
 
-	return s;
+	return skip_spaces(s);
 }
 EXPORT_SYMBOL(strim);
 
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

origin.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch

