From: akpm@linux-foundation.org
Subject: + proc-use-do-while-in-name_to_int.patch added to -mm tree
Date: Thu, 28 Sep 2017 14:44:55 -0700
Message-ID: <59cd6d57./83utZdNi42ew27q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdI1Vo4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 17:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use do-while in name_to_int()
has been added to the -mm tree.  Its filename is
     proc-use-do-while-in-name_to_int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-do-while-in-name_to_int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-do-while-in-name_to_int.patch

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

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-uninline-name_to_int.patch
proc-use-do-while-in-name_to_int.patch
seq_file-delete-small-value-optimization.patch

