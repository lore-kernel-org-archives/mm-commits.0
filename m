From: akpm@linux-foundation.org
Subject: + kstrtox-delete-end-of-string-test.patch added to -mm tree
Date: Mon, 15 May 2017 15:03:29 -0700
Message-ID: <591a25b1.ivY8RVGD4rUKoqn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdEOWDa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 18:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kstrtox.c: delete end-of-string test
has been added to the -mm tree.  Its filename is
     kstrtox-delete-end-of-string-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrtox-delete-end-of-string-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrtox-delete-end-of-string-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib/kstrtox.c: delete end-of-string test

Standard "while (*s)" test is unnecessary because NUL won't pass
valid-digit test anyway.  Save one branch per parsed character.

Link: http://lkml.kernel.org/r/20170514193756.GA32563@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kstrtox.c~kstrtox-delete-end-of-string-test lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-delete-end-of-string-test
+++ a/lib/kstrtox.c
@@ -51,7 +51,7 @@ unsigned int _parse_integer(const char *
 
 	res = 0;
 	rv = 0;
-	while (*s) {
+	while (1) {
 		unsigned int val;
 
 		if ('0' <= *s && *s <= '9')
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrtox-delete-end-of-string-test.patch
kstrtox-use-unsigned-int-more.patch

