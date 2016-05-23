From: akpm@linux-foundation.org
Subject: + seqlock-fix-raw_read_seqcount_latch.patch added to -mm tree
Date: Mon, 23 May 2016 13:51:37 -0700
Message-ID: <57436d59.81JB4+ZWJbQTVfAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbcEWUvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: seqlock: fix raw_read_seqcount_latch()
has been added to the -mm tree.  Its filename is
     seqlock-fix-raw_read_seqcount_latch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seqlock-fix-raw_read_seqcount_latch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seqlock-fix-raw_read_seqcount_latch.patch

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
Subject: seqlock: fix raw_read_seqcount_latch()

lockless_dereference() is supposed to take pointer not integer.

Link: http://lkml.kernel.org/r/20160521201448.GA7429@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/seqlock.h~seqlock-fix-raw_read_seqcount_latch include/linux/seqlock.h
--- a/include/linux/seqlock.h~seqlock-fix-raw_read_seqcount_latch
+++ a/include/linux/seqlock.h
@@ -277,7 +277,7 @@ static inline void raw_write_seqcount_ba
 
 static inline int raw_read_seqcount_latch(seqcount_t *s)
 {
-	return lockless_dereference(s->sequence);
+	return lockless_dereference(s)->sequence;
 }
 
 /**
@@ -331,7 +331,7 @@ static inline int raw_read_seqcount_latc
  *	unsigned seq, idx;
  *
  *	do {
- *		seq = lockless_dereference(latch->seq);
+ *		seq = lockless_dereference(latch)->seq;
  *
  *		idx = seq & 0x01;
  *		entry = data_query(latch->data[idx], ...);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seqlock-fix-raw_read_seqcount_latch.patch

