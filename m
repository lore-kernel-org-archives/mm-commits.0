From: akpm@osdl.org
Subject: + knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:13:12 -0800
Message-ID: <200701290013.l0T0DCTV006763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXA2ANR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: ratelimit some nfsd messages that are triggered by external events
has been added to the -mm tree.  Its filename is
     knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: ratelimit some nfsd messages that are triggered by external events
From: NeilBrown <neilb@suse.de>

Also remove {NFSD,RPC}_PARANOIA as having the defines doesn't really add
anything.

The printks covered by RPC_PARANOIA were triggered by badly formatted
packets and so should be ratelimited.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c     |    1 -
 fs/nfsd/nfsfh.c      |   14 ++++++--------
 fs/nfsd/vfs.c        |    1 -
 net/sunrpc/svc.c     |   33 ++++++++++++++++-----------------
 net/sunrpc/svcsock.c |   12 ++++++++----
 5 files changed, 30 insertions(+), 31 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events
+++ a/fs/nfsd/export.c
@@ -35,7 +35,6 @@
 #include <linux/lockd/bind.h>
 
 #define NFSDDBG_FACILITY	NFSDDBG_EXPORT
-#define NFSD_PARANOIA 1
 
 typedef struct auth_domain	svc_client;
 typedef struct svc_export	svc_export;
diff -puN fs/nfsd/nfsfh.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events
+++ a/fs/nfsd/nfsfh.c
@@ -24,8 +24,6 @@
 #include <linux/nfsd/nfsd.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_FH
-#define NFSD_PARANOIA 1
-/* #define NFSD_DEBUG_VERBOSE 1 */
 
 
 static int nfsd_nr_verified;
@@ -230,13 +228,12 @@ fh_verify(struct svc_rqst *rqstp, struct
 				error = nfserrno(PTR_ERR(dentry));
 			goto out;
 		}
-#ifdef NFSD_PARANOIA
+
 		if (S_ISDIR(dentry->d_inode->i_mode) &&
 		    (dentry->d_flags & DCACHE_DISCONNECTED)) {
 			printk("nfsd: find_fh_dentry returned a DISCONNECTED directory: %s/%s\n",
 			       dentry->d_parent->d_name.name, dentry->d_name.name);
 		}
-#endif
 
 		fhp->fh_dentry = dentry;
 		fhp->fh_export = exp;
@@ -267,12 +264,13 @@ fh_verify(struct svc_rqst *rqstp, struct
 	/* Finally, check access permissions. */
 	error = nfsd_permission(exp, dentry, access);
 
-#ifdef NFSD_PARANOIA_EXTREME
 	if (error) {
-		printk("fh_verify: %s/%s permission failure, acc=%x, error=%d\n",
-		       dentry->d_parent->d_name.name, dentry->d_name.name, access, (error >> 24));
+		dprintk("fh_verify: %s/%s permission failure, "
+			"acc=%x, error=%d\n",
+			dentry->d_parent->d_name.name,
+			dentry->d_name.name,
+			access, (error >> 24));
 	}
-#endif
 out:
 	if (exp && !IS_ERR(exp))
 		exp_put(exp);
diff -puN fs/nfsd/vfs.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events
+++ a/fs/nfsd/vfs.c
@@ -59,7 +59,6 @@
 #include <asm/uaccess.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_FILEOP
-#define NFSD_PARANOIA
 
 
 /* We must ignore files (but only files) which might have mandatory
diff -puN net/sunrpc/svc.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events
+++ a/net/sunrpc/svc.c
@@ -26,7 +26,6 @@
 #include <linux/sunrpc/clnt.h>
 
 #define RPCDBG_FACILITY	RPCDBG_SVCDSP
-#define RPC_PARANOIA 1
 
 /*
  * Mode for mapping cpus to pools.
@@ -872,15 +871,15 @@ svc_process(struct svc_rqst *rqstp)
 	return 0;
 
 err_short_len:
-#ifdef RPC_PARANOIA
-	printk("svc: short len %Zd, dropping request\n", argv->iov_len);
-#endif
+	if (net_ratelimit())
+		printk("svc: short len %Zd, dropping request\n", argv->iov_len);
+
 	goto dropit;			/* drop request */
 
 err_bad_dir:
-#ifdef RPC_PARANOIA
-	printk("svc: bad direction %d, dropping request\n", dir);
-#endif
+	if (net_ratelimit())
+		printk("svc: bad direction %d, dropping request\n", dir);
+
 	serv->sv_stats->rpcbadfmt++;
 	goto dropit;			/* drop request */
 
@@ -909,10 +908,10 @@ err_bad_prog:
 	goto sendit;
 
 err_bad_vers:
-#ifdef RPC_PARANOIA
-	printk("svc: unknown version (%d for prog %d, %s)\n",
-	       vers, prog, progp->pg_name);
-#endif
+	if (net_ratelimit())
+		printk("svc: unknown version (%d for prog %d, %s)\n",
+		       vers, prog, progp->pg_name);
+
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
 	svc_putnl(resv, progp->pg_lovers);
@@ -920,17 +919,17 @@ err_bad_vers:
 	goto sendit;
 
 err_bad_proc:
-#ifdef RPC_PARANOIA
-	printk("svc: unknown procedure (%d)\n", proc);
-#endif
+	if (net_ratelimit())
+		printk("svc: unknown procedure (%d)\n", proc);
+
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROC_UNAVAIL);
 	goto sendit;
 
 err_garbage:
-#ifdef RPC_PARANOIA
-	printk("svc: failed to decode args\n");
-#endif
+	if (net_ratelimit())
+		printk("svc: failed to decode args\n");
+
 	rpc_stat = rpc_garbage_args;
 err_bad:
 	serv->sv_stats->rpcbadfmt++;
diff -puN net/sunrpc/svcsock.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events
+++ a/net/sunrpc/svcsock.c
@@ -1062,15 +1062,19 @@ svc_tcp_recvfrom(struct svc_rqst *rqstp)
 			 *  bit set in the fragment length header.
 			 *  But apparently no known nfs clients send fragmented
 			 *  records. */
-			printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx (non-terminal)\n",
-			       (unsigned long) svsk->sk_reclen);
+			if (net_ratelimit())
+				printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx"
+				       " (non-terminal)\n",
+				       (unsigned long) svsk->sk_reclen);
 			goto err_delete;
 		}
 		svsk->sk_reclen &= 0x7fffffff;
 		dprintk("svc: TCP record, %d bytes\n", svsk->sk_reclen);
 		if (svsk->sk_reclen > serv->sv_max_mesg) {
-			printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx (large)\n",
-			       (unsigned long) svsk->sk_reclen);
+			if (net_ratelimit())
+				printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx"
+				       " (large)\n",
+				       (unsigned long) svsk->sk_reclen);
 			goto err_delete;
 		}
 	}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
