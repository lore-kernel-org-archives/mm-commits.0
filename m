From: akpm@osdl.org
Subject: + md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:26:51 -0800
Message-ID: <200701250526.l0P5QpC5006829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225AbXAYF0z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:26:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: remove unnecessary printk when raid5 gets an unaligned read.
has been added to the -mm tree.  Its filename is
     md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2630,7 +2630,7 @@ static int chunk_aligned_read(request_qu
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		printk("chunk_aligned_read : non aligned\n");
+		PRINTK("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
md-update-email-address-and-status-for-md-in-maintainers.patch
md-make-repair-actually-work-for-raid1.patch
md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch
md-avoid-reading-past-the-end-of-a-bitmap-file.patch
knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch
md-fix-potential-memalloc-deadlock-in-md.patch
md-remove-unnecessary-printk-when-raid5-gets-an-unaligned-read.patch
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
