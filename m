From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-fix-cast-detection.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:41 -0800
Message-ID: <201101132009.p0DK9MUs029966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933677Ab1AMUKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@mickler.org, apw@shadowen.org, audun.hoem@gmail.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl: fix CAST detection
has been removed from the -mm tree.  Its filename was
     checkpatchpl-fix-cast-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

