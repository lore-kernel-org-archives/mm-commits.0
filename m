From: akpm@linux-foundation.org
Subject: - ecryptfs-public-key-packet-management-slab-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:38 -0800
Message-ID: <200702120724.l1C7OcA4024759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbXBLHYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:24:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs-public-key-packet-management-slab-fix
has been removed from the -mm tree.  Its filename was
     ecryptfs-public-key-packet-management-slab-fix.patch

This patch was dropped because it was folded into ecryptfs-public-key-packet-management.patch

------------------------------------------------------
Subject: ecryptfs-public-key-packet-management-slab-fix
From: Andrew Morton <akpm@osdl.org>

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-public-key-packet-management-slab-fix fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-public-key-packet-management-slab-fix
+++ a/fs/ecryptfs/keystore.c
@@ -538,7 +538,7 @@ parse_tag_1_packet(struct ecryptfs_crypt
 	 * at end of function upon failure */
 	auth_tok_list_item =
 		kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache,
-				 SLAB_KERNEL);
+				 GFP_KERNEL);
 	if (!auth_tok_list_item) {
 		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
 		rc = -ENOMEM;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
