From: akpm@linux-foundation.org
Subject: [patch 049/114] checkpatch: improve quoted string and line
 continuation test
Date: Tue, 06 Feb 2018 15:38:52 -0800
Message-ID: <20180206233852.J3r9WA0xI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55006 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754126AbeBFXix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xypron.glpk@gmx.de

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
