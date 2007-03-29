From: akpm@linux-foundation.org
Subject: - md-allow-raid4-arrays-to-be-reshaped.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:41:42 -0700
Message-ID: <200703290741.l2T7fg8o030252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXC2Hlq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: allow raid4 arrays to be reshaped
has been removed from the -mm tree.  Its filename was
     md-allow-raid4-arrays-to-be-reshaped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: allow raid4 arrays to be reshaped
From: NeilBrown <neilb@suse.de>

All that is missing the the function pointers in raid4_pers.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/md/raid5.c~md-allow-raid4-arrays-to-be-reshaped drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-raid4-arrays-to-be-reshaped
+++ a/drivers/md/raid5.c
@@ -4104,6 +4104,10 @@ static struct mdk_personality raid4_pers
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+#ifdef CONFIG_MD_RAID5_RESHAPE
+	.check_reshape	= raid5_check_reshape,
+	.start_reshape  = raid5_start_reshape,
+#endif
 	.quiesce	= raid5_quiesce,
 };
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
