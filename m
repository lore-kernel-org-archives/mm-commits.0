From: akpm@linux-foundation.org
Subject: [merged] checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:36 -0800
Message-ID: <20120111213137.08EEE200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44200 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:38 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32631eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ensure cast type is unique in the context parser
has been removed from the -mm tree.  Its filename was
     checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: ensure cast type is unique in the context parser

Ensure the cast type is unique in the context parser, we do not want them
to detect as a comma ','.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-ensure-cast-type-is-unique-in-the-context-parser scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ensure-cast-type-is-unique-in-the-context-parser
+++ a/scripts/checkpatch.pl
@@ -1032,7 +1032,7 @@ sub annotate_values {
 		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/ && $av_pending eq '_') {
 			print "CAST($1)\n" if ($dbg_values > 1);
 			push(@av_paren_type, $type);
-			$type = 'C';
+			$type = 'c';
 
 		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

