From: akpm@linux-foundation.org
Subject: + checkpatch-improve-the-unnecessary-initialisers-tests.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:34:27 -0800
Message-ID: <563b30b3.UMPYN57K3lV+6Swr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084AbbKEKe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:34:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, shailendra.v@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the unnecessary initialisers tests
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-unnecessary-initialisers-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-unnecessary-initialisers-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-unnecessary-initialisers-tests.patch

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
Subject: checkpatch: improve the unnecessary initialisers tests

Global and static variables don't need to be initialized to 0.

There is already a test for this but the output message doesn't
mention booleans initialized to false.

Improve the output message and the test by adding various forms
with possible specific integer types and possible multiple zeros.

Miscellanea:

o Use a variable to hold the possible 0 test

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
Tested-by: Shailendra Verma <shailendra.v@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-initialisers-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-unnecessary-initialisers-tests
+++ a/scripts/checkpatch.pl
@@ -370,6 +370,8 @@ our $typeTypedefs = qr{(?x:
 	$typeKernelTypedefs\b
 )};
 
+our $zero_initializer = qr{(?:(?:0[xX])?0+$Int_type?|NULL|false)\b};
+
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
@@ -3334,21 +3336,20 @@ sub process {
 		}
 
 # check for global initialisers.
-		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*(?:0|NULL|false)\s*;/) {
+		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/) {
 			if (ERROR("GLOBAL_INITIALISERS",
-				  "do not initialise globals to 0 or NULL\n" .
-				      $herecurr) &&
+				  "do not initialise globals to $1\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/(^.$Type\s*$Ident(?:\s+$Modifier)*)\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/(^.$Type\s*$Ident(?:\s+$Modifier)*)\s*=\s*$zero_initializer\s*;/$1;/;
 			}
 		}
 # check for static initialisers.
-		if ($line =~ /^\+.*\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
+		if ($line =~ /^\+.*\bstatic\s.*=\s*($zero_initializer)\s*;/) {
 			if (ERROR("INITIALISED_STATIC",
-				  "do not initialise statics to 0 or NULL\n" .
+				  "do not initialise statics to $1\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/(\bstatic\s.*?)\s*=\s*$zero_initializer\s*;/$1;/;
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log.patch
checkpatch-improve-the-unnecessary-initialisers-tests.patch

