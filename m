From: akpm@linux-foundation.org
Subject: [patch 12/94] proc: use do-while in name_to_int()
Date: Fri, 17 Nov 2017 15:26:52 -0800
Message-ID: <20171117232652.b7ESiuXsp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759137AbdKQX0y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: use do-while in name_to_int()

Gcc doesn't know that "len" is guaranteed to be >=1 by dcache and
generates standard while-loop prologue duplicating loop condition.

	add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-27 (-27)
	function                                     old     new   delta
	name_to_int                                  104      77     -27

Link: http://lkml.kernel.org/r/20170912195213.GB17730@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/util.c~proc-use-do-while-in-name_to_int fs/proc/util.c
--- a/fs/proc/util.c~proc-use-do-while-in-name_to_int
+++ a/fs/proc/util.c
@@ -8,7 +8,7 @@ unsigned name_to_int(const struct qstr *
 
 	if (len > 1 && *name == '0')
 		goto out;
-	while (len-- > 0) {
+	do {
 		unsigned c = *name++ - '0';
 		if (c > 9)
 			goto out;
@@ -16,7 +16,7 @@ unsigned name_to_int(const struct qstr *
 			goto out;
 		n *= 10;
 		n += c;
-	}
+	} while (--len > 0);
 	return n;
 out:
 	return ~0U;
_
