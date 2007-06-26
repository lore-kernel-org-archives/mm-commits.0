From: akpm@linux-foundation.org
Subject: + relayfs-fix-overwrites.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:29:00 -0700
Message-ID: <200706261929.l5QJT0jF000525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524AbXFZT3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:29:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masami.hiramatsu.pt@hitachi.com, dwilder@us.ibm.com, zanussi@us.ibm.com


The patch titled
     relayfs: fix overwrites
has been added to the -mm tree.  Its filename is
     relayfs-fix-overwrites.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

relay-file-read-start-pos-fixpatch.patch
relayfs-fix-overwrites.patch
