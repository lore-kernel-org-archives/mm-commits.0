From: akpm@linux-foundation.org
Subject: + relay-reset-consumed.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:13:58 -0800
Message-ID: <200803052213.m25MDwUY023696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763738AbYCEWUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwilder@us.ibm.com, zanussi@us.ibm.com


The patch titled
     Relay Reset Consumed
has been added to the -mm tree.  Its filename is
     relay-reset-consumed.patch

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
Subject: Relay Reset Consumed
From: "David J. Wilder" <dwilder@us.ibm.com>

Allow a relay channel to be reset i.e.  unconsumed.  Basically allows a
'rewind' function for flight-recorder tracing.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/relay.txt |   11 ++++
 include/linux/relay.h               |    1 
 kernel/relay.c                      |   58 +++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/relay.txt~relay-reset-consumed Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt~relay-reset-consumed
+++ a/Documentation/filesystems/relay.txt
@@ -161,6 +161,7 @@ TBD(curr. line MT:/API/)
     relay_close(chan)
     relay_flush(chan)
     relay_reset(chan)
+    relay_reset_consumed(chan)
 
   channel management typically called on instigation of userspace:
 
@@ -452,6 +453,16 @@ state without reallocating channel buffe
 existing mappings.  It should however only be called when it's safe to
 do so, i.e. when the channel isn't currently being written to.
 
+The read(2) implementation always 'consumes' the bytes read,
+i.e. those bytes won't be available again to subsequent reads.
+Certain applications may nonetheless wish to allow the 'consumed' data
+to be re-read; relay_reset_consumed() is provided for that purpose -
+it resets the internal consumed counters for all buffers in the
+channel.  For example, if a first set of reads 'drains' the channel,
+and then relay_reset_consumed() is called, a second set of reads will
+get the exact same data (assuming no new data was written between the
+first set of reads and the second).
+
 Finally, there are a couple of utility callbacks that can be used for
 different purposes.  buf_mapped() is called whenever a channel buffer
 is mmapped from user space and buf_unmapped() is called when it's
diff -puN include/linux/relay.h~relay-reset-consumed include/linux/relay.h
--- a/include/linux/relay.h~relay-reset-consumed
+++ a/include/linux/relay.h
@@ -175,6 +175,7 @@ extern void relay_subbufs_consumed(struc
 				   unsigned int cpu,
 				   size_t consumed);
 extern void relay_reset(struct rchan *chan);
+extern void relay_reset_consumed(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
 extern size_t relay_switch_subbuf(struct rchan_buf *buf,
diff -puN kernel/relay.c~relay-reset-consumed kernel/relay.c
--- a/kernel/relay.c~relay-reset-consumed
+++ a/kernel/relay.c
@@ -378,6 +378,57 @@ void relay_reset(struct rchan *chan)
 }
 EXPORT_SYMBOL_GPL(relay_reset);
 
+/**
+ *	__relay_reset_consumed - reset a channel buffer's consumed count
+ *	@buf: the channel buffer
+ *
+ *	See relay_reset_consumed for description of effect.
+ */
+static void __relay_reset_consumed(struct rchan_buf *buf)
+{
+	size_t n_subbufs = buf->chan->n_subbufs;
+	size_t produced = buf->subbufs_produced;
+	size_t consumed = buf->subbufs_consumed;
+
+	if (produced < n_subbufs)
+		buf->subbufs_consumed = 0;
+	else {
+		consumed = produced - n_subbufs;
+		if (buf->offset)
+			consumed++;
+		buf->subbufs_consumed = consumed;
+	}
+	buf->bytes_consumed = 0;
+}
+
+/**
+ *	relay_reset_consumed - reset the channel's consumed counts
+ *	@chan: the channel
+ *
+ *	This has the effect of making all data previously read (and
+ *	not overwritten by subsequent writes) from a channel available
+ *	for reading again.
+ *
+ *	NOTE: Care should be taken that the channel isn't actually
+ *	being used by anything when this call is made.
+ */
+void relay_reset_consumed(struct rchan *chan)
+{
+	unsigned int i;
+	struct rchan_buf *prev = NULL;
+
+	if (!chan)
+		return;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		if (!chan->buf[i] || chan->buf[i] == prev)
+			break;
+		__relay_reset_consumed(chan->buf[i]);
+		prev = chan->buf[i];
+	}
+}
+EXPORT_SYMBOL_GPL(relay_reset_consumed);
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -840,11 +891,8 @@ static int relay_file_read_avail(struct 
 		return 1;
 	}
 
-	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = produced - n_subbufs + 1;
-		buf->subbufs_consumed = consumed;
-		buf->bytes_consumed = 0;
-	}
+	if (unlikely(produced - consumed >= n_subbufs))
+		__relay_reset_consumed(buf);
 
 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
 	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
_

Patches currently in -mm which might be from dwilder@us.ibm.com are

relay-reset-consumed.patch
trace-code-and-documentation.patch
trace-sample.patch

