From: akpm@linux-foundation.org
Subject: + relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch added to -mm tree
Date: Mon, 28 Jul 2008 22:54:52 -0700
Message-ID: <200807290554.m6T5sq9s017412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbYG2Fzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tzanussi@gmail.com, compudj@krystal.dyndns.org, eduard.munteanu@linux360.ro, jens.axboe@oracle.com, penberg@cs.helsinki.fi, righi.andrea@gmail.com


The patch titled
     relay: fix 4 off-by-one errors occuring when writing to a CPU buffer
has been added to the -mm tree.  Its filename is
     relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relay: fix 4 off-by-one errors occuring when writing to a CPU buffer
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

origin.patch
relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch

