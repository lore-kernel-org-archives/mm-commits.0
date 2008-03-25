From: akpm@linux-foundation.org
Subject: - ipw2200-le_add_cpu-conversion.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:34 -0700
Message-ID: <200803250019.m2P0JY8i032695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbYCYAaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, linville@tuxdriver.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     ipw2200: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     ipw2200-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipw2200: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2200.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/wireless/ipw2200.c~ipw2200-le_add_cpu-conversion drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~ipw2200-le_add_cpu-conversion
+++ a/drivers/net/wireless/ipw2200.c
@@ -10349,9 +10349,7 @@ static int ipw_tx_skb(struct ipw_priv *p
 					 remaining_bytes,
 					 PCI_DMA_TODEVICE));
 
-			tfd->u.data.num_chunks =
-			    cpu_to_le32(le32_to_cpu(tfd->u.data.num_chunks) +
-					1);
+			le32_add_cpu(&tfd->u.data.num_chunks, 1);
 		}
 	}
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
git-udf.patch
git-net.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
git-sched.patch
scsi-le_add_cpu-conversion.patch
git-cryptodev.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-remove-unused-fs64_add-and-fs64_sub.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

