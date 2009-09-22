From: akpm@linux-foundation.org
Subject: [merged] checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:46:00 -0700
Message-ID: <200909222046.n8MKk0Di016831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbZIVUxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: limit sN/uN matches to actual bit sizes
has been removed from the -mm tree.  Its filename was
     checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: limit sN/uN matches to actual bit sizes
From: Andy Whitcroft <apw@canonical.com>

Limit our type matcher to the s/u/le/be etc sizes that actually exist to
prevent miss categorising s2 as a type.  Fix up the spelling of the error
also.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-limit-sn-un-matches-to-actual-bit-sizes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-limit-sn-un-matches-to-actual-bit-sizes
+++ a/scripts/checkpatch.pl
@@ -182,7 +182,7 @@ our $UTF8	= qr {
 }x;
 
 our $typeTypedefs = qr{(?x:
-	(?:__)?(?:u|s|be|le)(?:\d|\d\d)|
+	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
 )};
 
@@ -1936,7 +1936,7 @@ sub process {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("Aspace prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

