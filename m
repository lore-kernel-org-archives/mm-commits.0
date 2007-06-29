From: akpm@linux-foundation.org
Subject: - relayfs-fix-overwrites.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:55 -0700
Message-ID: <200706292040.l5TKetX6022469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016AbXF2Uuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: masami.hiramatsu.pt@hitachi.com, dwilder@us.ibm.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     relayfs: fix overwrites
has been removed from the -mm tree.  Its filename was
     relayfs-fix-overwrites.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: relayfs: fix overwrites
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

When I use relayfs with "overwrite" mode, read() still sets incorrect
number of consumed bytes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Tom Zanussi <zanussi@us.ibm.com>
Acked-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~relayfs-fix-overwrites kernel/relay.c
--- a/kernel/relay.c~relayfs-fix-overwrites
+++ a/kernel/relay.c
@@ -812,7 +812,10 @@ static void relay_file_read_consume(stru
 	}
 
 	buf->bytes_consumed += bytes_consumed;
-	read_subbuf = read_pos / buf->chan->subbuf_size;
+	if (!read_pos)
+		read_subbuf = buf->subbufs_consumed;
+	else
+		read_subbuf = read_pos / buf->chan->subbuf_size;
 	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
 		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
 		    (buf->offset == subbuf_size))
@@ -841,8 +844,9 @@ static int relay_file_read_avail(struct 
 	}
 
 	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = (produced / n_subbufs) * n_subbufs;
+		consumed = produced - n_subbufs + 1;
 		buf->subbufs_consumed = consumed;
+		buf->bytes_consumed = 0;
 	}
 	
 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
_

Patches currently in -mm which might be from masami.hiramatsu.pt@hitachi.com are

origin.patch
