From: akpm@linux-foundation.org
Subject: - lib-fix-sparse-shadowed-variable-warning.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:25 -0800
Message-ID: <200901072215.n07MFPBS015234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761952AbZAGWP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: fix sparse shadowed variable warning
has been removed from the -mm tree.  Its filename was
     lib-fix-sparse-shadowed-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

pos is always set before being used, no need to declare a
second one inside the if() block.

lib/prio_heap.c:34:7: warning: symbol 'pos' shadows an earlier one
lib/prio_heap.c:30:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_heap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/prio_heap.c~lib-fix-sparse-shadowed-variable-warning lib/prio_heap.c
--- a/lib/prio_heap.c~lib-fix-sparse-shadowed-variable-warning
+++ a/lib/prio_heap.c
@@ -31,7 +31,7 @@ void *heap_insert(struct ptr_heap *heap,
 
 	if (heap->size < heap->max) {
 		/* Heap insertion */
-		int pos = heap->size++;
+		pos = heap->size++;
 		while (pos > 0 && heap->gt(p, ptrs[(pos-1)/2])) {
 			ptrs[pos] = ptrs[(pos-1)/2];
 			pos = (pos-1)/2;
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

