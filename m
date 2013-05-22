From: akpm@linux-foundation.org
Subject: + checkpatch-change-camelcase-test-and-make-it-strict.patch added to -mm tree
Date: Wed, 22 May 2013 15:27:43 -0700
Message-ID: <519d465f.LnflQU7dBkEPPDdL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3EVW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 18:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, apw@canonical.com, joe@perches.com

Subject: + checkpatch-change-camelcase-test-and-make-it-strict.patch added to -mm tree
To: joe@perches.com,apw@canonical.com
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 15:27:43 -0700


The patch titled
     Subject: checkpatch: change CamelCase test and make it --strict
has been added to the -mm tree.  Its filename is
     checkpatch-change-camelcase-test-and-make-it-strict.patch

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
Subject: checkpatch: change CamelCase test and make it --strict

Do not bleat a message on nominally acceptable CamelCase uses that are
separated by an _ like drm_core_has_MTRR.

CamelCase tests are also a bit noisy against certain types of code
acceptable to some kernel developers.

Make the test applicable only with --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-change-camelcase-test-and-make-it-strict scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-change-camelcase-test-and-make-it-strict
+++ a/scripts/checkpatch.pl
@@ -2938,12 +2938,12 @@ sub process {
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
-				WARN("CAMELCASE",
-				     "Avoid CamelCase: <$var>\n" . $herecurr);
+				CHK("CAMELCASE",
+				    "Avoid CamelCase: <$var>\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
lib-bitmapc-speed-up-bitmap_find_free_region.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch

