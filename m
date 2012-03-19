From: akpm@linux-foundation.org
Subject: [merged] afs-read-of-file-returns-ebadmsg.patch removed from -mm tree
Date: Mon, 19 Mar 2012 13:29:59 -0700
Message-ID: <20120319202959.59023A02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55645 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759396Ab2CSUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2012 16:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, dhowells@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: afs: read of large file returns EBADMSG
has been removed from the -mm tree.  Its filename was
     afs-read-of-file-returns-ebadmsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: afs: read of large file returns EBADMSG

A read of a large file on an afs mount failed:

# cat junk.file > /dev/null
cat: junk.file: Bad message

Looking at the trace, call->offset wrapped since it is only an
unsigned short. In afs_extract_data:

        _enter("{%u},{%zu},%d,,%zu", call->offset, len, last, count);
...

        if (call->offset < count) {
                if (last) {
                        _leave(" = -EBADMSG [%d < %zu]", call->offset, count);
                        return -EBADMSG;
                }

Which matches the trace:

[cat   ] ==> afs_extract_data({65132},{524},1,,65536)
[cat   ] <== afs_extract_data() = -EBADMSG [0 < 65536]

call->offset went from 65132 to 0.  Fix this by making call->offset an
unsigned int.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/internal.h~afs-read-of-file-returns-ebadmsg fs/afs/internal.h
--- a/fs/afs/internal.h~afs-read-of-file-returns-ebadmsg
+++ a/fs/afs/internal.h
@@ -109,7 +109,7 @@ struct afs_call {
 	unsigned		reply_size;	/* current size of reply */
 	unsigned		first_offset;	/* offset into mapping[first] */
 	unsigned		last_to;	/* amount of mapping[last] */
-	unsigned short		offset;		/* offset into received data store */
+	unsigned		offset;		/* offset into received data store */
 	unsigned char		unmarshall;	/* unmarshalling phase */
 	bool			incoming;	/* T if incoming call */
 	bool			send_pages;	/* T if data from mapping should be sent */
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch

