From: akpm@linux-foundation.org
Subject: - lib-proportionsc-trivial-sparse-lock-annotation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:29 -0800
Message-ID: <200901072215.n07MFTj3015289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761958AbZAGWPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: proportions.c trivial sparse lock annotation
has been removed from the -mm tree.  Its filename was
     lib-proportionsc-trivial-sparse-lock-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: proportions.c trivial sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

Suppresses sparse warning:
lib/proportions.c:159:16: warning: context imbalance in 'prop_get_global': wrong count at exit
lib/proportions.c:159:16:    context 'RCU': wanted 0, got 1
lib/proportions.c:164:2: warning: context imbalance in 'prop_put_global': unexpected unlock
lib/proportions.c:164:2:    context 'RCU': wanted 0, got -1

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/proportions.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/proportions.c~lib-proportionsc-trivial-sparse-lock-annotation lib/proportions.c
--- a/lib/proportions.c~lib-proportionsc-trivial-sparse-lock-annotation
+++ a/lib/proportions.c
@@ -147,6 +147,7 @@ out:
  * this is used to track the active references.
  */
 static struct prop_global *prop_get_global(struct prop_descriptor *pd)
+__acquires(RCU)
 {
 	int index;
 
@@ -160,6 +161,7 @@ static struct prop_global *prop_get_glob
 }
 
 static void prop_put_global(struct prop_descriptor *pd, struct prop_global *pg)
+__releases(RCU)
 {
 	rcu_read_unlock();
 }
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

