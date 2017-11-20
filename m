From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:51 -0800
Message-ID: <20171120212451.I06J4F_aJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752978AbdKTVYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: checkpatch: do not check missing blank line before builtin_*_driver
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: checkpatch: do not check missing blank line before builtin_*_driver

checkpatch.pl does not check missing blank line before module_*_driver.
I want it to behave likewise for builtin_*_driver.

Link: http://lkml.kernel.org/r/1505700081-12854-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-do-not-check-missing-blank-line-before-builtin__driver scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-do-not-check-missing-blank-line-before-builtin__driver
+++ a/scripts/checkpatch.pl
@@ -3105,6 +3105,7 @@ sub process {
 		      $line =~ /^\+[a-z_]*init/ ||
 		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
 		      $line =~ /^\+\s*DECLARE/ ||
+		      $line =~ /^\+\s*builtin_[\w_]*driver/ ||
 		      $line =~ /^\+\s*__setup/)) {
 			if (CHK("LINE_SPACING",
 				"Please use a blank line after function/struct/union/enum declarations\n" . $hereprev) &&
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are


