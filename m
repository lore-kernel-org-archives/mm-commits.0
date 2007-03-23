From: akpm@linux-foundation.org
Subject: + md-allow-raid4-arrays-to-be-reshaped.patch added to -mm tree
Date: Thu, 22 Mar 2007 23:54:17 -0800
Message-ID: <200703230754.l2N7sHse009483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41411 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422692AbXCWHyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 03:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: allow raid4 arrays to be reshaped
has been added to the -mm tree.  Its filename is
     md-allow-raid4-arrays-to-be-reshaped.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch
knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch
knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch
knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
md-allow-raid4-arrays-to-be-reshaped.patch
md-clear-the-congested_fn-when-stopping-a-raid5.patch
md-convert-compile-time-warnings-into-runtime-warnings.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
