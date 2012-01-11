From: akpm@linux-foundation.org
Subject: [merged] checkpatch-typeof-may-have-more-complex-arguments.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:40 -0800
Message-ID: <20120111213141.04C75200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:39411 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:43 -0500
Received: by faaa20 with SMTP id a20so33257faa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: typeof may have more complex arguments
has been removed from the -mm tree.  Its filename was
     checkpatch-typeof-may-have-more-complex-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: typeof may have more complex arguments

typeof may have various more complex forms as its arguement, not just an
identifier.  For now allow us to leak to the first close perenthesis ')'.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-typeof-may-have-more-complex-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-typeof-may-have-more-complex-arguments
+++ a/scripts/checkpatch.pl
@@ -315,7 +315,7 @@ sub build_types {
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
-				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

