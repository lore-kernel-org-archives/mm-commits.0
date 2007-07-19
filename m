From: akpm@linux-foundation.org
Subject: + afs-use-patched-rxrpc_kernel_send_data-correctly.patch added to -mm tree
Date: Thu, 19 Jul 2007 13:50:15 -0700
Message-ID: <200707192050.l6JKoFQm022279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763457AbXGSUu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: use patched rxrpc_kernel_send_data() correctly
has been added to the -mm tree.  Its filename is
     afs-use-patched-rxrpc_kernel_send_data-correctly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFS: use patched rxrpc_kernel_send_data() correctly
From: David Howells <dhowells@redhat.com>

Fix afs_send_simple_reply() to accept a greater-than-zero return value from
rxrpc_kernel_send_data() as being a successful return rather than thinking
it an error and aborting the call.

rxrpc_kernel_send_data() previously returned zero incorrectly when it
worked successfully, but has been patched to return the number of bytes it
transmitted.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/rxrpc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/afs/rxrpc.c~afs-use-patched-rxrpc_kernel_send_data-correctly fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~afs-use-patched-rxrpc_kernel_send_data-correctly
+++ a/fs/afs/rxrpc.c
@@ -792,6 +792,7 @@ void afs_send_simple_reply(struct afs_ca
 {
 	struct msghdr msg;
 	struct iovec iov[1];
+	int n;
 
 	_enter("");
 
@@ -806,8 +807,9 @@ void afs_send_simple_reply(struct afs_ca
 	msg.msg_flags		= 0;
 
 	call->state = AFS_CALL_AWAIT_ACK;
-	switch (rxrpc_kernel_send_data(call->rxcall, &msg, len)) {
-	case 0:
+	n = rxrpc_kernel_send_data(call->rxcall, &msg, len);
+	switch (n) {
+	case 0 ... INT_MAX:
 		_leave(" [replied]");
 		return;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
afs-fix-file-locking.patch
afs-use-patched-rxrpc_kernel_send_data-correctly.patch
mutex-subsystem-synchro-test-module.patch
