From: akpm@osdl.org
Subject: - md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:58 -0800
Message-ID: <200701270131.l0R1Vw2I031876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXA0BcG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: make sure the events count in an md array never returns to zero
has been removed from the -mm tree.  Its filename was
     md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: make sure the events count in an md array never returns to zero
From: NeilBrown <neilb@suse.de>

Now that we sometimes step the array events count backwards (when
transitioning dirty->clean where nothing else interesting has happened - so
that we don't need to write to spares all the time), it is possible for the
event count to return to zero, which is potentially confusing and triggers and
MD_BUG.

We could possibly remove the MD_BUG, but is just as easy, and probably safer,
to make sure we never return to zero.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero drivers/md/md.c
--- a/drivers/md/md.c~md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero
+++ a/drivers/md/md.c
@@ -1633,7 +1633,8 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1))
+	    && (mddev->events & 1)
+	    && mddev->events != 1)
 		mddev->events--;
 	else {
 		/* otherwise we have to go forward and ... */
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
