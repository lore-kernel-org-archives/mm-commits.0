From: akpm@linux-foundation.org
Subject: +
 checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch added
 to -mm tree
Date: Mon, 10 Apr 2017 14:15:53 -0700
Message-ID: <58ebf609.eVyZR1Vltsm9ZPTg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdDJVPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 17:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, ybalrid@ybalrid.info, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid suggesting struct definitions should be const
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch

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
Subject: checkpatch: avoid suggesting struct definitions should be const

Many structs are generally used const and there is a known list of these
structs.

struct definitions should not be generally be declared const.

Add a test for the lack of an open brace immediately after the struct to
avoid definitions.

This avoids the false positive "struct foo should normally be const"
message only when the open brace is on the same line as the definition.

Link: http://lkml.kernel.org/r/0dce709150d712e66f1b90b03827634b53b28085.1491845946.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Arthur Brainville <ybalrid@ybalrid.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-suggesting-struct-definitions-should-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-suggesting-struct-definitions-should-be-const
+++ a/scripts/checkpatch.pl
@@ -6090,11 +6090,11 @@ sub process {
 		}
 
 # check for various structs that are normally const (ops, kgdb, device_tree)
+# and avoid what seem like struct definitions 'struct foo {'
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+($const_structs)\b/) {
+		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
 			WARN("CONST_STRUCT",
-			     "struct $1 should normally be const\n" .
-				$herecurr);
+			     "struct $1 should normally be const\n" . $herecurr);
 		}
 
 # use of NR_CPUS is usually wrong
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch
treewide-correct-diffrent-and-banlance-typos.patch

