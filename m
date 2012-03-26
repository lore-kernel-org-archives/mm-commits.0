From: akpm@linux-foundation.org
Subject: [merged] checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:24 -0700
Message-ID: <20120326193024.5801BA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35450 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2CZTaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:25 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so831445vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: high precedence operators do not require additional parentheses in #defines
has been removed from the -mm tree.  Its filename was
     checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2916,7 +2916,7 @@ sub process {
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
-			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
+			    $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

