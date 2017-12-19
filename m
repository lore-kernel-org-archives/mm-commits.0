From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-quoted-string-and-line-continuation-test.patch added to
 -mm tree
Date: Tue, 19 Dec 2017 14:52:39 -0800
Message-ID: <5a399837./qoyrZL/O6Je0vpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdLSWwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 17:52:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve quoted string and line continuation test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-quoted-string-and-line-continuation-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-quoted-string-and-line-continuation-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-quoted-string-and-line-continuation-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch

