From: akpm@linux-foundation.org
Subject: + checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:36:47 -0800
Message-ID: <20120301203648.003F8A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40255 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab2CAUgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:36:49 -0500
Received: by yenq2 with SMTP id q2so114293yen.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:36:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: high precedence operators do not require additional parentheses in #defines
has been added to the -mm tree.  Its filename is
     checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch

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
Subject: checkpatch: high precedence operators do not require additional parentheses in #defines

With any very high precedence operator it is not necessary to enforce
additional parentheses around simple negated expressions.  This prevents
us requesting further perentheses around the following:

    #define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)

For now add logical and bitwise not and unary minus.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines
+++ a/scripts/checkpatch.pl
@@ -2911,7 +2911,7 @@ sub process {
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
-			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
+			    $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
_
Subject: Subject: checkpatch: high precedence operators do not require additional parentheses in #defines

Patches currently in -mm which might be from apw@canonical.com are

checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch

