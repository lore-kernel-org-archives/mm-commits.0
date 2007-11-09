From: akpm@linux-foundation.org
Subject: + smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:51:32 -0800
Message-ID: <200711090451.lA94pX4V030154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759998AbXKIEvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com


The patch titled
     smbfs: fix calculation of kernel_recvmsg size parameter in smb_receive()
has been added to the -mm tree.  Its filename is
     smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smbfs: fix calculation of kernel_recvmsg size parameter in smb_receive()
From: Jeff Layton <jlayton@redhat.com>

smb_receive calls kernel_recvmsg with a size that's the minimum of the
amount of buffer space in the kvec passed in or req->rq_rlen (which
represents the length of the response).  This does not take into account
any data that was read in a request earlier pass through smb_receive.

If the first pass through smb_receive receives some but not all of the
response, then the next pass can call kernel_recvmsg with a size field
that's too big.  kernel_recvmsg can overrun into the next response,
throwing off the alignment and making it unrecognizable.

This causes messages like this to pop up in the ring buffer:

smb_get_length: Invalid NBT packet, code=69

as well as other errors indicating that the response is unrecognizable.
Typically this is seen on a smbfs mount under heavy I/O.

This patch changes the code to use (req->rq_rlen - req->rq_bytes_recvd)
instead instead of just req->rq_rlen, since that should represent the
amount of unread data in the response.

I think this is correct, but an ACK or NACK from someone more familiar
with this code would be appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/sock.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/smbfs/sock.c~smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive fs/smbfs/sock.c
--- a/fs/smbfs/sock.c~smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive
+++ a/fs/smbfs/sock.c
@@ -329,9 +329,8 @@ smb_receive(struct smb_sb_info *server, 
 	msg.msg_control = NULL;
 
 	/* Dont repeat bytes and count available bufferspace */
-	rlen = smb_move_iov(&p, &num, iov, req->rq_bytes_recvd);
-	if (req->rq_rlen < rlen)
-		rlen = req->rq_rlen;
+	rlen = min_t(int, smb_move_iov(&p, &num, iov, req->rq_bytes_recvd),
+			(req->rq_rlen - req->rq_bytes_recvd));
 
 	result = kernel_recvmsg(sock, &msg, p, num, rlen, flags);
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
git-unionfs.patch
smbfs-fix-debug-builds.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
