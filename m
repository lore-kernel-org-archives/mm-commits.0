From: akpm@linux-foundation.org
Subject: - remove-warning-vfs-is-out-of-sync-with-lock-manager.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:21 -0800
Message-ID: <200702022137.l12LbLRa018498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946109AbXBBVho (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:37:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Remove warning: VFS is out of sync with lock manager
has been removed from the -mm tree.  Its filename was
     remove-warning-vfs-is-out-of-sync-with-lock-manager.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove warning: VFS is out of sync with lock manager
From: Neil Brown <neilb@suse.de>

But keep it as a dprintk

The message can be generated in a quite normal situation:
 If a 'lock' request is interrupted, then the lock client needs to
  record that the server has the lock, incase it does.
 When we come the unlock, the server might say it doesn't, even
  though we think it does (or might) and this generates the message.

Signed-off-by: Neil Brown <neilb@suse.de>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/file.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/nfs/file.c~remove-warning-vfs-is-out-of-sync-with-lock-manager fs/nfs/file.c
--- a/fs/nfs/file.c~remove-warning-vfs-is-out-of-sync-with-lock-manager
+++ a/fs/nfs/file.c
@@ -434,8 +434,9 @@ static int do_vfs_lock(struct file *file
 			BUG();
 	}
 	if (res < 0)
-		printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n",
-				__FUNCTION__);
+		dprintk(KERN_WARNING "%s: VFS is out of sync with lock manager"
+			" - error %d!\n",
+				__FUNCTION__, res);
 	return res;
 }
 
_

Patches currently in -mm which might be from neilb@suse.de are

use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
