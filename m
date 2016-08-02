From: akpm@linux-foundation.org
Subject: [patch 053/111] checkpatch: don't complain about BIT macro in
 uapi
Date: Tue, 02 Aug 2016 14:04:39 -0700
Message-ID: <57a10ae7.UOR8XkOOdgw2k3KP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbcHBVRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tomas.winkler@intel.com, joe@perches.com

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
