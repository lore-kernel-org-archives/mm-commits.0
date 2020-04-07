From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 132/166] checkpatch: fix multiple const * types
Date: Mon, 06 Apr 2020 20:11:04 -0700
Message-ID: <20200407031104.0elpB8xmi%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgDGDLF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:05 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, borneo.antonio@gmail.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
