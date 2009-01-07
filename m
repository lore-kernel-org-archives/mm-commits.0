From: akpm@linux-foundation.org
Subject: - lib-radix_treec-make-percpu-variable-static.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:27 -0800
Message-ID: <200901072215.n07MFRwY015237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761952AbZAGWP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: radix_tree.c make percpu variable static
has been removed from the -mm tree.  Its filename was
     lib-radix_treec-make-percpu-variable-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: radix_tree.c make percpu variable static
From: Harvey Harrison <harvey.harrison@gmail.com>

radix_tree_preloads is unused outside of this file, make it static.

Noticed by sparse:
lib/radix-tree.c:84:1: warning: symbol 'per_cpu__radix_tree_preloads' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~lib-radix_treec-make-percpu-variable-static lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix_treec-make-percpu-variable-static
+++ a/lib/radix-tree.c
@@ -81,7 +81,7 @@ struct radix_tree_preload {
 	int nr;
 	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
 };
-DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
+static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

