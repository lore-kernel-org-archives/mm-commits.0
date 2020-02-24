From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-fix-multiple-const-types.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 15:40:01 -0800
Message-ID: <20200224234001.2sdZ1jtGq%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBXXkD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 18:40:03 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borneo.antonio@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix multiple const * types
has been added to the -mm tree.  Its filename is
     checkpatch-fix-multiple-const-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-multiple-const-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-multiple-const-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -818,12 +818,12 @@ sub build_types {
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

checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch
checkpatch-fix-multiple-const-types.patch
checkpatch-add-command-line-option-for-tab-size.patch
