From: akpm@linux-foundation.org
Subject: - sunrpc-export-svc_sock_update_bufs.patch removed from -mm tree
Date: Sat, 05 Jan 2008 19:06:31 -0800
Message-ID: <200801060306.m0636Bdg022912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbYAFDHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 22:07:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: export svc_sock_update_bufs
has been removed from the -mm tree.  Its filename was
     sunrpc-export-svc_sock_update_bufs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: export svc_sock_update_bufs
From: Jeff Layton <jlayton@redhat.com>

Needed since the plan is to not have a svc_create_thread helper and to have
current users of that function just call kthread_run directly.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sunrpc_syms.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sunrpc/sunrpc_syms.c~sunrpc-export-svc_sock_update_bufs net/sunrpc/sunrpc_syms.c
--- a/net/sunrpc/sunrpc_syms.c~sunrpc-export-svc_sock_update_bufs
+++ a/net/sunrpc/sunrpc_syms.c
@@ -78,6 +78,7 @@ EXPORT_SYMBOL(svc_auth_register);
 EXPORT_SYMBOL(auth_domain_lookup);
 EXPORT_SYMBOL(svc_authenticate);
 EXPORT_SYMBOL(svc_set_client);
+EXPORT_SYMBOL(svc_sock_update_bufs);
 
 /* RPC statistics */
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from jlayton@redhat.com are

sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
