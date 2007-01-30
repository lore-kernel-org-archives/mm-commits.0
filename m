From: akpm@osdl.org
Subject: + remove-warning-vfs-is-out-of-sync-with-lock-manager.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:07:44 -0800
Message-ID: <200701300107.l0U17ij7005024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36130 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXA3BIC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:08:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     Remove warning: VFS is out of sync with lock manager
has been added to the -mm tree.  Its filename is
     remove-warning-vfs-is-out-of-sync-with-lock-manager.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch
remove-warning-vfs-is-out-of-sync-with-lock-manager.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
