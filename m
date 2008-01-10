From: akpm@linux-foundation.org
Subject: - sunrpc-export-svc_sock_update_bufs.patch removed from -mm tree
Date: Thu, 10 Jan 2008 15:57:34 -0800
Message-ID: <200801102357.m0ANvYN7015831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbYAJX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 18:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     SUNRPC: export svc_sock_update_bufs
has been removed from the -mm tree.  Its filename was
     sunrpc-export-svc_sock_update_bufs.patch

This patch was dropped because it keeps on changing

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SUNRPC: export svc_sock_update_bufs
From: Jeff Layton <jlayton@redhat.com>

Needed since the plan is to not have a svc_create_thread helper and to have
current users of that function just call kthread_run directly.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sunrpc/svcsock.c~sunrpc-export-svc_sock_update_bufs net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~sunrpc-export-svc_sock_update_bufs
+++ a/net/sunrpc/svcsock.c
@@ -1350,6 +1350,7 @@ void svc_sock_update_bufs(struct svc_ser
 	}
 	spin_unlock_bh(&serv->sv_lock);
 }
+EXPORT_SYMBOL(svc_sock_update_bufs);
 
 /*
  * Receive the next request on any socket.  This code is carefully
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
