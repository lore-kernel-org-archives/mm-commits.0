From: akpm@linux-foundation.org
Subject: + checkpatch-dont-complain-about-bit-macro-in-uapi.patch added to -mm tree
Date: Tue, 19 Jul 2016 16:02:43 -0700
Message-ID: <578eb193.R9bdhn0EItEb5mxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbcGSXCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 19:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas.winkler@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't complain about BIT macro in uapi
has been added to the -mm tree.  Its filename is
     checkpatch-dont-complain-about-bit-macro-in-uapi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-complain-about-bit-macro-in-uapi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-complain-about-bit-macro-in-uapi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5733,8 +5733,9 @@ sub process {
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

checkpatch-dont-complain-about-bit-macro-in-uapi.patch

