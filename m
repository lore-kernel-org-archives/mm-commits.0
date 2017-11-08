From: akpm@linux-foundation.org
Subject: +
 checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch
 added to -mm tree
Date: Wed, 08 Nov 2017 15:32:44 -0800
Message-ID: <5a03941c.bzialPuNAx6SLUNW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbdKHXcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2017 18:32:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not check missing blank line before builtin_*_driver
has been added to the -mm tree.  Its filename is
     checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
radix-tree-remove-unneeded-include-linux-bugh.patch
checkpatch-do-not-check-missing-blank-line-before-builtin__driver.patch
init-version-include-linux-exporth-instead-of-linux-moduleh.patch

