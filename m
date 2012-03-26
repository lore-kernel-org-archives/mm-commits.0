From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-to-type-extensions.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:26 -0700
Message-ID: <20120326193026.6147DA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52960 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2CZTa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:27 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298455faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add [] to type extensions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-to-type-extensions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: add [] to type extensions

Add [] to a type extensions.  Fixes false positives on:

    .attrs = (struct attribute *[]) {

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-to-type-extensions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-to-type-extensions
+++ a/scripts/checkpatch.pl
@@ -323,7 +323,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

