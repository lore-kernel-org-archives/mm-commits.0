From: akpm@linux-foundation.org
Subject: + afs-read-of-file-returns-ebadmsg.patch added to -mm tree
Date: Tue, 13 Mar 2012 13:56:51 -0700
Message-ID: <20120313205651.CE3C8A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41073 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2CMU4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 16:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, dhowells@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: afs: read of large file returns EBADMSG
has been added to the -mm tree.  Its filename is
     afs-read-of-file-returns-ebadmsg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: afs: read of large file returns EBADMSG

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
afs-read-of-file-returns-ebadmsg.patch

