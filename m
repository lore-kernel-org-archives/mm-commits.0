From: akpm@linux-foundation.org
Subject: + checkpatchpl-fix-cast-detection.patch added to -mm tree
Date: Fri, 19 Nov 2010 13:13:43 -0800
Message-ID: <201011192113.oAJLDhjB002491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab0KSVOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 16:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@mickler.org, apw@shadowen.org, audun.hoem@gmail.com


The patch titled
     checkpatch.pl: fix CAST detection
has been added to the -mm tree.  Its filename is
     checkpatchpl-fix-cast-detection.patch

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
Subject: checkpatch.pl: fix CAST detection
From: Florian Mickler <florian@mickler.org>

We should only claim that something is a cast if we did not encouter a
token before, that did set av_pending.

This fixes the operator * in the line below to be detected as binary (vs
unary).

kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);

Reported-by: Audun Hoem <audun.hoem@gmail.com>
Signed-off-by: Florian Mickler <florian@mickler.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-fix-cast-detection scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-fix-cast-detection
+++ a/scripts/checkpatch.pl
@@ -859,7 +859,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
+		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/ && $av_pending eq '_') {
 			print "CAST($1)\n" if ($dbg_values > 1);
 			push(@av_paren_type, $type);
 			$type = 'C';
_

Patches currently in -mm which might be from florian@mickler.org are

checkpatchpl-fix-cast-detection.patch

