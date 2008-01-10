From: akpm@linux-foundation.org
Subject: - nlm-have-lockd-call-try_to_freeze.patch removed from -mm tree
Date: Thu, 10 Jan 2008 15:57:41 -0800
Message-ID: <200801102357.m0ANvgvg015837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbYAJX6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 18:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NLM: Have lockd call try_to_freeze
has been removed from the -mm tree.  Its filename was
     nlm-have-lockd-call-try_to_freeze.patch

This patch was dropped because it keeps on changing

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
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
