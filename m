From: akpm@linux-foundation.org
Subject: + nlm-have-lockd-call-try_to_freeze.patch added to -mm tree
Date: Tue, 08 Jan 2008 15:58:40 -0800
Message-ID: <200801082358.m08Nwe8I006521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbYAIAAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 19:00:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     NLM: Have lockd call try_to_freeze
has been added to the -mm tree.  Its filename is
     nlm-have-lockd-call-try_to_freeze.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NLM: Have lockd call try_to_freeze
From: Jeff Layton <jlayton@redhat.com>

lockd makes itself freezable, but never calls try_to_freeze().  Have it call
try_to_freeze() within the main loop.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/lockd/svc.c~nlm-have-lockd-call-try_to_freeze fs/lockd/svc.c
--- a/fs/lockd/svc.c~nlm-have-lockd-call-try_to_freeze
+++ a/fs/lockd/svc.c
@@ -155,6 +155,9 @@ lockd(struct svc_rqst *rqstp)
 		long timeout = MAX_SCHEDULE_TIMEOUT;
 		char buf[RPC_MAX_ADDRBUFLEN];
 
+		if (try_to_freeze())
+			continue;
+
 		if (signalled()) {
 			flush_signals(current);
 			if (nlmsvc_ops) {
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch
sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
