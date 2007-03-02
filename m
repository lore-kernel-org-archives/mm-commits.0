From: akpm@linux-foundation.org
Subject: + md-fix-for-raid6-reshape.patch added to -mm tree
Date: Thu, 01 Mar 2007 21:06:39 -0800
Message-ID: <200703020506.l2256dOv000815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42315 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422742AbXCBFGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix for raid6 reshape
has been added to the -mm tree.  Its filename is
     md-fix-for-raid6-reshape.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix for raid6 reshape
From: NeilBrown <neilb@suse.de>

Recent patch for raid6 reshape had a change missing that showed up in
subsequent review.

Many places in the raid5 code used "conf->raid_disks-1" to mean "number of
data disks".  With raid6 that had to be changed to "conf->raid_disk -
conf->max_degraded" or similar.  One place was missed.

This bug means that if a raid6 reshape were aborted in the middle the
recorded position would be wrong.  On restart it would either fail (as the
position wasn't on an appropriate boundary) or would leave a section of the
array unreshaped, causing data corruption.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-fix-for-raid6-reshape drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-for-raid6-reshape
+++ a/drivers/md/raid5.c
@@ -3642,7 +3642,7 @@ static sector_t reshape_request(mddev_t 
 		release_stripe(sh);
 	}
 	spin_lock_irq(&conf->device_lock);
-	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
+	conf->expand_progress = (sector_nr + i) * new_data_disks);
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
md-fix-for-raid6-reshape.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
