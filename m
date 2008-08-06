From: akpm@linux-foundation.org
Subject: - relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:15 -0700
Message-ID: <200808062056.m76KuFWQ014650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129AbYHFU60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tzanussi@gmail.com, compudj@krystal.dyndns.org, eduard.munteanu@linux360.ro, jens.axboe@oracle.com, penberg@cs.helsinki.fi, righi.andrea@gmail.com, stable@kernel.org, mm-commits@vger.


The patch titled
     relay: fix "full buffer with exactly full last subbuffer" accounting problem
has been removed from the -mm tree.  Its filename was
     relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relay: fix "full buffer with exactly full last subbuffer" accounting problem
From: Tom Zanussi <tzanussi@gmail.com>

In relay's current read implementation, if the buffer is completely full
but hasn't triggered the buffer-full condition (i.e. the last write
didn't cross the subbuffer boundary) and the last subbuffer is exactly
full, the subbuffer accounting code erroneously finds nothing available.
This patch fixes the problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com> 
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer kernel/relay.c
--- a/kernel/relay.c~relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer
+++ a/kernel/relay.c
@@ -944,6 +944,10 @@ static void relay_file_read_consume(stru
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t read_subbuf;
 
+	if (buf->subbufs_produced == buf->subbufs_consumed &&
+	    buf->offset == buf->bytes_consumed)
+		return;
+
 	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
 		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
 		buf->bytes_consumed = 0;
@@ -975,6 +979,8 @@ static int relay_file_read_avail(struct 
 
 	relay_file_read_consume(buf, read_pos, 0);
 
+	consumed = buf->subbufs_consumed;
+
 	if (unlikely(buf->offset > subbuf_size)) {
 		if (produced == consumed)
 			return 0;
@@ -993,8 +999,12 @@ static int relay_file_read_avail(struct 
 	if (consumed > produced)
 		produced += n_subbufs * subbuf_size;
 
-	if (consumed == produced)
+	if (consumed == produced) {
+		if (buf->offset == subbuf_size &&
+		    buf->subbufs_produced > buf->subbufs_consumed)
+			return 1;
 		return 0;
+	}
 
 	return 1;
 }
_

Patches currently in -mm which might be from tzanussi@gmail.com are


