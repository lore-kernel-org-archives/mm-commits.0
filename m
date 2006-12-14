From: akpm@osdl.org
Subject: - knfsd-fix-up-some-bit-rot-in-exp_export.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:00 -0800
Message-ID: <200612140618.kBE6HxAo002323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbWLNGSP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:18:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: Fix up some bit-rot in exp_export
has been removed from the -mm tree.  Its filename was
     knfsd-fix-up-some-bit-rot-in-exp_export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: Fix up some bit-rot in exp_export
From: NeilBrown <neilb@suse.de>

The nfsservctl system call isn't used but recent nfs-utils releases for
exporting filesystems, and consequently the code that is uses - exp_export -
has suffered some bitrot.

Particular:
  - some newly added fields in 'struct svc_export' are being initialised
    properly.
  - the return value is now always -ENOMEM ...

This patch fixes both these problems.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-fix-up-some-bit-rot-in-exp_export fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-fix-up-some-bit-rot-in-exp_export
+++ a/fs/nfsd/export.c
@@ -955,6 +955,8 @@ exp_export(struct nfsctl_export *nxp)
 
 	exp = exp_get_by_name(clp, nd.mnt, nd.dentry, NULL);
 
+	memset(&new, 0, sizeof(new));
+
 	/* must make sure there won't be an ex_fsid clash */
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (fsid_key = exp_get_fsid_key(clp, nxp->ex_dev)) &&
@@ -985,6 +987,9 @@ exp_export(struct nfsctl_export *nxp)
 
 	new.h.expiry_time = NEVER;
 	new.h.flags = 0;
+	new.ex_path = kstrdup(nxp->ex_path, GFP_KERNEL);
+	if (!new.ex_path)
+		goto finish;
 	new.ex_client = clp;
 	new.ex_mnt = nd.mnt;
 	new.ex_dentry = nd.dentry;
@@ -1005,10 +1010,11 @@ exp_export(struct nfsctl_export *nxp)
 		/* failed to create at least one index */
 		exp_do_unexport(exp);
 		cache_flush();
-		err = -ENOMEM;
-	}
-
+	} else
+		err = 0;
 finish:
+	if (new.ex_path)
+		kfree(new.ex_path);
 	if (exp)
 		exp_put(exp);
 	if (fsid_key && !IS_ERR(fsid_key))
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

