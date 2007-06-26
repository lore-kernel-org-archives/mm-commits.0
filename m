From: akpm@linux-foundation.org
Subject: + relay-file-read-start-pos-fixpatch.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:28:57 -0700
Message-ID: <200706261928.l5QJSvPS000522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758066AbXFZT3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwilder@us.ibm.com, masami.hiramatsu.pt@hitachi.com, zanussi@us.ibm.com


The patch titled
     relay file read: start-pos fix
has been added to the -mm tree.  Its filename is
     relay-file-read-start-pos-fixpatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

relay-file-read-start-pos-fixpatch.patch
relayfs-fix-overwrites.patch
