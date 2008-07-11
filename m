From: akpm@linux-foundation.org
Subject: - block-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:34 -0700
Message-ID: <200807112351.m6BNpY8o011052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbYGKXvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     block-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoecmd.c~block-use-get_unaligned_-helpers drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~block-use-get_unaligned_-helpers
+++ a/drivers/block/aoe/aoecmd.c
@@ -1003,7 +1003,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	 * Enough people have their dip switches set backwards to
 	 * warrant a loud message for this special case.
 	 */
-	aoemajor = be16_to_cpu(get_unaligned(&h->major));
+	aoemajor = get_unaligned_be16(&h->major);
 	if (aoemajor == 0xfff) {
 		printk(KERN_ERR "aoe: Warning: shelf address is all ones.  "
 			"Check shelf dip switches.\n");
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

