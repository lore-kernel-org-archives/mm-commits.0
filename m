From: akpm@linux-foundation.org
Subject: [merged] checkpatch-is-not-a-valid-modifier.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:12 -0800
Message-ID: <20120111213112.A46531E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:13 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ## is not a valid modifier
has been removed from the -mm tree.  Its filename was
     checkpatch-is-not-a-valid-modifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: ## is not a valid modifier

Inserting a # into the modifiers list will incorrectly add the null string
to the modifiers list, leading to an infinite loop.  As neither of these
is a valid modifier form simply ignore them.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-is-not-a-valid-modifier scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-is-not-a-valid-modifier
+++ a/scripts/checkpatch.pl
@@ -1224,7 +1224,9 @@ sub possible {
 			case|
 			else|
 			asm|__asm__|
-			do
+			do|
+			\#|
+			\#\#|
 		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
 	    )}x;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

