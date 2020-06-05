From: akpm@linux-foundation.org
Subject: [merged]
 kernel-relayc-fix-read_pos-error-when-multiple-readers.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:20:01 -0700
Message-ID: <20200605202001.ZJKFMK28s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgFEUUC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, gregkh@linuxfoundation.org, jannh@google.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, yangpc@wangsu.com


The patch titled
     Subject: kernel/relay.c: fix read_pos error when multiple readers
has been removed from the -mm tree.  Its filename was
     kernel-relayc-fix-read_pos-error-when-multiple-readers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pengcheng Yang <yangpc@wangsu.com>
Subject: kernel/relay.c: fix read_pos error when multiple readers

When reading, read_pos should start with bytes_consumed, not file->f_pos. 
Because when there is more than one reader, the read_pos corresponding to
file->f_pos may have been consumed, which will cause the data that has
been consumed to be read and the bytes_consumed update error.

Link: http://lkml.kernel.org/r/1579691175-28949-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>e
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/kernel/relay.c~kernel-relayc-fix-read_pos-error-when-multiple-readers
+++ a/kernel/relay.c
@@ -996,14 +996,14 @@ static void relay_file_read_consume(stru
 /*
  *	relay_file_read_avail - boolean, are there unconsumed bytes available?
  */
-static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
+static int relay_file_read_avail(struct rchan_buf *buf)
 {
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t produced = buf->subbufs_produced;
 	size_t consumed = buf->subbufs_consumed;
 
-	relay_file_read_consume(buf, read_pos, 0);
+	relay_file_read_consume(buf, 0, 0);
 
 	consumed = buf->subbufs_consumed;
 
@@ -1064,23 +1064,20 @@ static size_t relay_file_read_subbuf_ava
 
 /**
  *	relay_file_read_start_pos - find the first available byte to read
- *	@read_pos: file read position
  *	@buf: relay channel buffer
  *
- *	If the @read_pos is in the middle of padding, return the
+ *	If the read_pos is in the middle of padding, return the
  *	position of the first actually available byte, otherwise
  *	return the original value.
  */
-static size_t relay_file_read_start_pos(size_t read_pos,
-					struct rchan_buf *buf)
+static size_t relay_file_read_start_pos(struct rchan_buf *buf)
 {
 	size_t read_subbuf, padding, padding_start, padding_end;
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t consumed = buf->subbufs_consumed % n_subbufs;
+	size_t read_pos = consumed * subbuf_size + buf->bytes_consumed;
 
-	if (!read_pos)
-		read_pos = consumed * subbuf_size + buf->bytes_consumed;
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
 	padding_start = (read_subbuf + 1) * subbuf_size - padding;
@@ -1136,10 +1133,10 @@ static ssize_t relay_file_read(struct fi
 	do {
 		void *from;
 
-		if (!relay_file_read_avail(buf, *ppos))
+		if (!relay_file_read_avail(buf))
 			break;
 
-		read_start = relay_file_read_start_pos(*ppos, buf);
+		read_start = relay_file_read_start_pos(buf);
 		avail = relay_file_read_subbuf_avail(read_start, buf);
 		if (!avail)
 			break;
_

Patches currently in -mm which might be from yangpc@wangsu.com are
