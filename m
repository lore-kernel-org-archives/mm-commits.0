From: akpm@linux-foundation.org
Subject: [patch 088/115] lib/kstrtox.c: delete end-of-string test
Date: Mon, 10 Jul 2017 15:51:38 -0700
Message-ID: <20170710225138.acPHe6D-_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754641AbdGJWvj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
