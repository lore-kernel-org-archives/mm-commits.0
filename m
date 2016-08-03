From: akpm@linux-foundation.org
Subject: [merged] checkpatch-dont-complain-about-bit-macro-in-uapi.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:41 -0700
Message-ID: <57a23419.EEaK9sZt5P2gSYiI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbcHCSNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas.winkler@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't complain about BIT macro in uapi
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-complain-about-bit-macro-in-uapi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomas Winkler <tomas.winkler@intel.com>
Subject: checkpatch: don't complain about BIT macro in uapi

BIT macro cannot be exported to UAPI, don't complain about it.

Link: http://lkml.kernel.org/r/1468707033-16173-1-git-send-email-tomas.winkler@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-complain-about-bit-macro-in-uapi scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-complain-about-bit-macro-in-uapi
+++ a/scripts/checkpatch.pl
@@ -5732,8 +5732,9 @@ sub process {
 			}
 		}
 
-# check for #defines like: 1 << <digit> that could be BIT(digit)
-		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
+# check for #defines like: 1 << <digit> that could be BIT(digit), it is not exported to uapi
+		if ($realfile !~ m@^include/uapi/@ &&
+		    $line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
 			my $ull = "";
 			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
 			if (CHK("BIT_MACRO",
_

Patches currently in -mm which might be from tomas.winkler@intel.com are


