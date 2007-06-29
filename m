From: akpm@linux-foundation.org
Subject: - relay-file-read-start-pos-fixpatch.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:53 -0700
Message-ID: <200706292040.l5TKer5B022466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbXF2Ul5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwilder@us.ibm.com, masami.hiramatsu.pt@hitachi.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     relay file read: start-pos fix
has been removed from the -mm tree.  Its filename was
     relay-file-read-start-pos-fixpatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: relay file read: start-pos fix
From: David Wilder <dwilder@us.ibm.com>

Fix a bug in the relay read interface causing the number of consumed bytes
to be set incorrectly.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN kernel/relay.c~relay-file-read-start-pos-fixpatch kernel/relay.c
--- a/kernel/relay.c~relay-file-read-start-pos-fixpatch
+++ a/kernel/relay.c
@@ -899,7 +899,10 @@ static size_t relay_file_read_start_pos(
 	size_t read_subbuf, padding, padding_start, padding_end;
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
+	size_t consumed = buf->subbufs_consumed % n_subbufs;
 
+	if (!read_pos)
+		read_pos = consumed * subbuf_size + buf->bytes_consumed;
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
 	padding_start = (read_subbuf + 1) * subbuf_size - padding;
_

Patches currently in -mm which might be from dwilder@us.ibm.com are

origin.patch
