From: akpm@linux-foundation.org
Subject: + seq_file-delete-small-value-optimization.patch added to -mm
 tree
Date: Tue, 16 May 2017 13:59:10 -0700
Message-ID: <591b681e.gjX+Qze+EqpV3Q6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdEPU7L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file.c: delete small-value optimization
has been added to the -mm tree.  Its filename is
     seq_file-delete-small-value-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_file-delete-small-value-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_file-delete-small-value-optimization.patch

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
Subject: fs/seq_file.c: delete small-value optimization

num_to_str() optimizes printing small integers [0..9], so the same check
higher in callchain is unnecessary.

Link: http://lkml.kernel.org/r/20170516204246.GA18123@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/seq_file.c~seq_file-delete-small-value-optimization fs/seq_file.c
--- a/fs/seq_file.c~seq_file-delete-small-value-optimization
+++ a/fs/seq_file.c
@@ -694,11 +694,6 @@ void seq_put_decimal_ull(struct seq_file
 	if (m->count + 1 >= m->size)
 		goto overflow;
 
-	if (num < 10) {
-		m->buf[m->count++] = num + '0';
-		return;
-	}
-
 	len = num_to_str(m->buf + m->count, m->size - m->count, num);
 	if (!len)
 		goto overflow;
@@ -733,11 +728,6 @@ void seq_put_decimal_ll(struct seq_file
 		num = -num;
 	}
 
-	if (num < 10) {
-		m->buf[m->count++] = num + '0';
-		return;
-	}
