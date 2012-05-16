From: akpm@linux-foundation.org
Subject: + sunrpc-fix-kernel-doc-warnings.patch added to -mm tree
Date: Wed, 16 May 2012 15:19:56 -0700
Message-ID: <20120516221956.A0380A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64556 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2EPWT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 18:19:59 -0400
Received: by bkty5 with SMTP id y5so63092bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 15:19:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, Trond.Myklebust@netapp.com, bfields@fieldses.org


The patch titled
     Subject: sunrpc: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     sunrpc-fix-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: sunrpc: fix kernel-doc warnings

Fix kernel-doc warnings in sunrpc/rpc_pipe.c and sunrpc/rpcb_clnt.c:

Warning(net/sunrpc/rpcb_clnt.c:428): No description found for parameter 'net'
Warning(net/sunrpc/rpcb_clnt.c:567): No description found for parameter 'net'

Warning(net/sunrpc/rpc_pipe.c:133): No description found for parameter 'pipe'
Warning(net/sunrpc/rpc_pipe.c:133): Excess function parameter 'inode' description in 'rpc_queue_upcall'
Warning(net/sunrpc/rpc_pipe.c:839): No description found for parameter 'pipe'
Warning(net/sunrpc/rpc_pipe.c:839): Excess function parameter 'ops' description in 'rpc_mkpipe_dentry'
Warning(net/sunrpc/rpc_pipe.c:839): Excess function parameter 'flags' description in 'rpc_mkpipe_dentry'
Warning(net/sunrpc/rpc_pipe.c:949): No description found for parameter 'dentry'
Warning(net/sunrpc/rpc_pipe.c:949): Excess function parameter 'clnt' description in 'rpc_remove_client_dir'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/rpc_pipe.c  |    8 +++-----
 net/sunrpc/rpcb_clnt.c |    2 ++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN net/sunrpc/rpc_pipe.c~sunrpc-fix-kernel-doc-warnings net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~sunrpc-fix-kernel-doc-warnings
+++ a/net/sunrpc/rpc_pipe.c
@@ -120,7 +120,7 @@ EXPORT_SYMBOL_GPL(rpc_pipe_generic_upcal
 
 /**
  * rpc_queue_upcall - queue an upcall message to userspace
- * @inode: inode of upcall pipe on which to queue given message
+ * @pipe: upcall pipe on which to queue given message
  * @msg: message to queue
  *
  * Call with an @inode created by rpc_mkpipe() to queue an upcall.
@@ -819,9 +819,7 @@ static int rpc_rmdir_depopulate(struct d
  * @parent: dentry of directory to create new "pipe" in
  * @name: name of pipe
  * @private: private data to associate with the pipe, for the caller's use
- * @ops: operations defining the behavior of the pipe: upcall, downcall,
- *	release_pipe, open_pipe, and destroy_msg.
- * @flags: rpc_pipe flags
+ * @pipe: &rpc_pipe containing input parameters
  *
  * Data is made available for userspace to read by calls to
  * rpc_queue_upcall().  The actual reads will result in calls to
@@ -943,7 +941,7 @@ struct dentry *rpc_create_client_dir(str
 
 /**
  * rpc_remove_client_dir - Remove a directory created with rpc_create_client_dir()
- * @clnt: rpc client
+ * @dentry: dentry for the pipe
  */
 int rpc_remove_client_dir(struct dentry *dentry)
 {
diff -puN net/sunrpc/rpcb_clnt.c~sunrpc-fix-kernel-doc-warnings net/sunrpc/rpcb_clnt.c
--- a/net/sunrpc/rpcb_clnt.c~sunrpc-fix-kernel-doc-warnings
+++ a/net/sunrpc/rpcb_clnt.c
@@ -396,6 +396,7 @@ static int rpcb_register_call(struct rpc
 
 /**
  * rpcb_register - set or unset a port registration with the local rpcbind svc
+ * @net: target network namespace
  * @prog: RPC program number to bind
  * @vers: RPC version number to bind
  * @prot: transport protocol to register
@@ -523,6 +524,7 @@ static int rpcb_unregister_all_protofami
 
 /**
  * rpcb_v4_register - set or unset a port registration with the local rpcbind
+ * @net: target network namespace
  * @program: RPC program number of service to (un)register
  * @version: RPC version number of service to (un)register
  * @address: address family, IP address, and port to (un)register
_
Subject: Subject: sunrpc: fix kernel-doc warnings

Patches currently in -mm which might be from rdunlap@xenotime.net are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
sunrpc-fix-kernel-doc-warnings.patch
kmodc-fix-kernel-doc-warning.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

