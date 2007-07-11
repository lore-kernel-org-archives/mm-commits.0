From: akpm@linux-foundation.org
Subject: + relay-fix-bogus-cast-in-subbuf_splice_actor.patch added to -mm tree
Date: Wed, 11 Jul 2007 13:58:44 -0700
Message-ID: <200707112058.l6BKwiib016397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933136AbXGKU7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zanussi@us.ibm.com, jens.axboe@oracle.com


The patch titled
     relay: fix bogus cast in subbuf_splice_actor()
has been added to the -mm tree.  Its filename is
     relay-fix-bogus-cast-in-subbuf_splice_actor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: relay: fix bogus cast in subbuf_splice_actor()
From: Tom Zanussi <zanussi@us.ibm.com>

The current code that sets the read position in subbuf_splice_actor may give
erroneous results if the buffer size isn't a power of 2.  This patch fixes the
problem.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-fix-bogus-cast-in-subbuf_splice_actor kernel/relay.c
--- a/kernel/relay.c~relay-fix-bogus-cast-in-subbuf_splice_actor
+++ a/kernel/relay.c
@@ -1074,7 +1074,9 @@ static int subbuf_splice_actor(struct fi
 	unsigned int pidx, poff, total_len, subbuf_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
-	size_t read_start = ((size_t)*ppos) % rbuf->chan->alloc_size;
+	uint64_t pos = (uint64_t) *ppos;
+	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
+	size_t read_start = (size_t) do_div(pos, alloc_size);
 	size_t read_subbuf = read_start / subbuf_size;
 	size_t padding = rbuf->padding[read_subbuf];
 	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
_

Patches currently in -mm which might be from zanussi@us.ibm.com are

git-block.patch
relay-fix-subbuf_splice_actor-comment.patch
relay-fix-bogus-cast-in-subbuf_splice_actor.patch
kernel-relayc-make-functions-static.patch
