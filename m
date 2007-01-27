From: akpm@osdl.org
Subject: - md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:33 -0800
Message-ID: <200701270132.l0R1WX3G031938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXA0Bco (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: remove unnecessary printk when raid5 gets an unaligned read.
has been removed from the -mm tree.  Its filename was
     md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: remove unnecessary printk when raid5 gets an unaligned read.
From: NeilBrown <neilb@suse.de>

raid5_mergeable_bvec tries to ensure that raid5 never sees a read request
that does not fit within just one chunk.  However as we must always accept
a single-page read, that is not always possible.

So when "in_chunk_boundary" fails, it might be unusual, but it is not a
problem and printing a message every time is a bad idea.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read
+++ a/drivers/md/raid5.c
@@ -2680,7 +2680,7 @@ static int chunk_aligned_read(request_qu
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		printk("chunk_aligned_read : non aligned\n");
+		PRINTK("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
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
