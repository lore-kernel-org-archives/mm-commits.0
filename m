From: akpm@linux-foundation.org
Subject: + checkpatch-add-to-type-extensions.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:36:49 -0800
Message-ID: <20120301203649.E7FF8A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35626 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab2CAUgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:36:51 -0500
Received: by vcbfk26 with SMTP id fk26so114549vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:36:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: add [] to type extensions
has been added to the -mm tree.  Its filename is
     checkpatch-add-to-type-extensions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: checkpatch: add [] to type extensions

Patches currently in -mm which might be from apw@canonical.com are

checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch

