From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-quoted-string-and-line-continuation-test.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:57:33 -0800
Message-ID: <20180207195733.eUEEZzR4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbeBGT5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, xypron.glpk@gmx.de


The patch titled
     Subject: checkpatch: improve quoted string and line continuation test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-quoted-string-and-line-continuation-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve quoted string and line continuation test

Given this patch context,

+#define EFI_ST_DISK_IMG { \
+       0x00000240, "\xbe\x5b\x7c\xac\x22\xc0\x74\x0b" /* .[|.".t. */ \
+       }

the current code misreports a quoted string line continuation defect as
there is a single quote in comment.

The 'raw' line should not be tested for quote count, the comment
substituted line should be instead.

Link: http://lkml.kernel.org/r/13f2735df10c33ca846e26f42f5cce6618157200.1513698599.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-quoted-string-and-line-continuation-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-quoted-string-and-line-continuation-test
+++ a/scripts/checkpatch.pl
@@ -5312,7 +5312,7 @@ sub process {
 		}
 
 # check for line continuations in quoted strings with odd counts of "
-		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
+		if ($rawline =~ /\\$/ && $sline =~ tr/"/"/ % 2) {
 			WARN("LINE_CONTINUATIONS",
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are


