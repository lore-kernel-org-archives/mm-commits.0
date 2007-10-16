From: akpm@linux-foundation.org
Subject: + net-sunrpc-xprtrdma-verbsc-printk-warning-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 22:43:16 -0700
Message-ID: <200710160549.l9G5ndZN011646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932593AbXJPFuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 01:50:10 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9G5ndPc025110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2007 22:49:41 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     net/sunrpc/xprtrdma/verbs.c printk warning fix
has been added to the -mm tree.  Its filename is
     net-sunrpc-xprtrdma-verbsc-printk-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/sunrpc/xprtrdma/verbs.c printk warning fix
From: Andrew Morton <akpm@linux-foundation.org>

sparc64:

net/sunrpc/xprtrdma/verbs.c:1264: warning: long long unsigned int format, u64 arg (arg 3)
net/sunrpc/xprtrdma/verbs.c:1264: warning: long long unsigned int format, u64 arg (arg 4)


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/verbs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/verbs.c~net-sunrpc-xprtrdma-verbsc-printk-warning-fix net/sunrpc/xprtrdma/verbs.c
--- a/net/sunrpc/xprtrdma/verbs.c~net-sunrpc-xprtrdma-verbsc-printk-warning-fix
+++ a/net/sunrpc/xprtrdma/verbs.c
@@ -1263,7 +1263,8 @@ rpcrdma_register_internal(struct rpcrdma
 
 	dprintk("RPC:       %s: phys convert: 0x%llx "
 			"registered 0x%llx length %d\n",
-			__func__, ipb.addr, iov->addr, len);
+			__func__, (unsigned long long)ipb.addr,
+			(unsigned long long)iov->addr, len);
 
 	if (IS_ERR(mr)) {
 		*mrp = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
nfs-convert-to-new-aops.patch
fs-restore-nobh.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
categorize-gfp-flags.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support.patch
mm-mempolicyc-cleanups.patch
uml-fix-stub-address-calculations.patch
uml-arch-um-drivers-formatting.patch
ecryptfs-printk-warning-fixes.patch
rtc-cmos-probe-cleanup.patch
tdfxfb-mtrr-support.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
fbcon-logo-disable-logo-at-boot.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte.patch
net-sunrpc-xprtrdma-verbsc-printk-warning-fix.patch
