From: akpm@linux-foundation.org
Subject: [patch 01/10] seqlock: fix raw_read_seqcount_latch()
Date: Thu, 26 May 2016 15:16:06 -0700
Message-ID: <574775a6.unnTYO16yKXLeFNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbcEZWQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, a.p.zijlstra@chello.nl

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
