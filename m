From: akpm@linux-foundation.org
Subject: + git-nfs-fixup.patch added to -mm tree
Date: Sun, 11 Feb 2007 14:39:52 -0800
Message-ID: <200702112239.l1BMdqIP015343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbXBKWjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:39:54 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1BMdqUI015264
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 11 Feb 2007 14:39:52 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-nfs-fixup
has been added to the -mm tree.  Its filename is
     git-nfs-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/gss_krb5_crypto.c |    5 ---
 net/sunrpc/auth_gss/gss_spkm3_token.c |    4 --
 net/sunrpc/clnt.c                     |   40 ------------------------
 3 files changed, 49 deletions(-)

diff -puN net/sunrpc/auth_gss/gss_krb5_crypto.c~git-nfs-fixup net/sunrpc/auth_gss/gss_krb5_crypto.c
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c~git-nfs-fixup
+++ a/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -66,13 +66,8 @@ krb5_encrypt(
 		goto out;
 
 	if (crypto_blkcipher_ivsize(tfm) > 16) {
-<<<<<<< HEAD/net/sunrpc/auth_gss/gss_krb5_crypto.c
-		dprintk("RPC:      gss_k5encrypt: tfm iv size to large %d\n",
-			 crypto_blkcipher_ivsize(tfm));
-=======
 		dprintk("RPC:       gss_k5encrypt: tfm iv size to large %d\n",
 		         crypto_blkcipher_ivsize(tfm));
->>>>>>> /net/sunrpc/auth_gss/gss_krb5_crypto.c
 		goto out;
 	}
 
diff -puN net/sunrpc/auth_gss/gss_spkm3_token.c~git-nfs-fixup net/sunrpc/auth_gss/gss_spkm3_token.c
--- a/net/sunrpc/auth_gss/gss_spkm3_token.c~git-nfs-fixup
+++ a/net/sunrpc/auth_gss/gss_spkm3_token.c
@@ -209,11 +209,7 @@ spkm3_verify_mic_token(unsigned char **t
 
 	/* spkm3 innercontext token preamble */
 	if ((ptr[0] != 0xa4) || (ptr[2] != 0x30)) {
-<<<<<<< HEAD/net/sunrpc/auth_gss/gss_spkm3_token.c
 		dprintk("RPC: BAD SPKM ictoken preamble\n");
-=======
-		dprintk("RPC:       BAD SPKM ictoken preamble\n");
->>>>>>> /net/sunrpc/auth_gss/gss_spkm3_token.c
 		goto out;
 	}
 
diff -puN net/sunrpc/clnt.c~git-nfs-fixup net/sunrpc/clnt.c
--- a/net/sunrpc/clnt.c~git-nfs-fixup
+++ a/net/sunrpc/clnt.c
@@ -749,13 +749,8 @@ call_allocate(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 	unsigned int	bufsiz;
 
-<<<<<<< HEAD/net/sunrpc/clnt.c
 	dprintk("RPC: %4d call_allocate (status %d)\n",
 				task->tk_pid, task->tk_status);
-=======
-	dprint_status(task);
-
->>>>>>> /net/sunrpc/clnt.c
 	task->tk_action = call_bind;
 	if (req->rq_buffer)
 		return;
@@ -766,12 +761,7 @@ call_allocate(struct rpc_task *task)
 
 	if (xprt->ops->buf_alloc(task, bufsiz << 1) != NULL)
 		return;
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	printk(KERN_INFO "RPC: buffer allocation failed for task %p\n", task);
-=======
-
 	dprintk("RPC: %5u rpc_buffer allocation failed\n", task->tk_pid);
->>>>>>> /net/sunrpc/clnt.c
 
 	if (RPC_IS_ASYNC(task) || !signalled()) {
 		xprt_release(task);
@@ -808,12 +798,7 @@ call_encode(struct rpc_task *task)
 	kxdrproc_t	encode;
 	__be32		*p;
 
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %4d call_encode (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 	dprint_status(task);
->>>>>>> /net/sunrpc/clnt.c
 
 	/* Default buffer setup */
 	bufsiz = req->rq_bufsize >> 1;
@@ -945,12 +930,7 @@ call_connect_status(struct rpc_task *tas
 	struct rpc_clnt *clnt = task->tk_client;
 	int status = task->tk_status;
 
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %5u call_connect_status (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 	dprint_status(task);
->>>>>>> /net/sunrpc/clnt.c
 
 	task->tk_status = 0;
 	if (status >= 0) {
@@ -982,12 +962,7 @@ call_connect_status(struct rpc_task *tas
 static void
 call_transmit(struct rpc_task *task)
 {
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %4d call_transmit (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 	dprint_status(task);
->>>>>>> /net/sunrpc/clnt.c
 
 	task->tk_action = call_status;
 	if (task->tk_status < 0)
@@ -1048,12 +1023,7 @@ call_status(struct rpc_task *task)
 	if (req->rq_received > 0 && !req->rq_bytes_sent)
 		task->tk_status = req->rq_received;
 
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %4d call_status (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 	dprint_status(task);
->>>>>>> /net/sunrpc/clnt.c
 
 	status = task->tk_status;
 	if (status >= 0) {
@@ -1142,13 +1112,8 @@ call_decode(struct rpc_task *task)
 	kxdrproc_t	decode = task->tk_msg.rpc_proc->p_decode;
 	__be32		*p;
 
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %4d call_decode (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 	dprintk("RPC: %5u call_decode (status %d)\n",
 			task->tk_pid, task->tk_status);
->>>>>>> /net/sunrpc/clnt.c
 
 	if (task->tk_flags & RPC_CALL_MAJORSEEN) {
 		printk(KERN_NOTICE "%s: server %s OK\n",
@@ -1225,13 +1190,8 @@ static void
 call_refreshresult(struct rpc_task *task)
 {
 	int status = task->tk_status;
-<<<<<<< HEAD/net/sunrpc/clnt.c
-	dprintk("RPC: %4d call_refreshresult (status %d)\n",
-				task->tk_pid, task->tk_status);
-=======
 
 	dprint_status(task);
->>>>>>> /net/sunrpc/clnt.c
 
 	task->tk_status = 0;
 	task->tk_action = call_reserve;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
