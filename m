From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-multiple-const-types.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:36 -0700
Message-ID: <20200408020136.U3tSg10KK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borneo.antonio@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix multiple const * types
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-multiple-const-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Antonio Borneo <borneo.antonio@gmail.com>
Subject: checkpatch: fix multiple const * types

Commit 1574a29f8e76 ("checkpatch: allow multiple const * types") claims to
support repetition of pattern "const *", but it actually allows only one
extra instance.

Check the following lines
	int a(char const * const x[]);
	int b(char const * const *x);
	int c(char const * const * const x[]);
	int d(char const * const * const *x);

with command

	./scripts/checkpatch.pl --show-types -f filename

to find that only the first line passes the test, while a warning
is triggered by the other 3 lines:

	WARNING:FUNCTION_ARGUMENTS: function definition argument
	'char const * const' should also have an identifier name

The reason is that the pattern match halts at the second asterisk in the
line, thus the remaining text starting with asterisk fails to match a
valid name for a variable.

Fixed by replacing "?" (Match 1 or 0 times) with "{0,4}" (Match no more
than 4 times) in the regular expression.  Fix also the similar test for
types in unusual order.

Link: http://lkml.kernel.org/r/20200122163852.124417-1-borneo.antonio@gmail.com
Fixes: 1574a29f8e76 ("checkpatch: allow multiple const * types")
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-multiple-const-types
+++ a/scripts/checkpatch.pl
@@ -804,12 +804,12 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+){0,4}
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$TypeMisordered	= qr{
 			$NonptrTypeMisordered
-			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+){0,4}
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
_

Patches currently in -mm which might be from borneo.antonio@gmail.com are
