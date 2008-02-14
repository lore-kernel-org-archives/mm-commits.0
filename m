From: akpm@linux-foundation.org
Subject: + ipw2200-le_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:35 -0800
Message-ID: <200802140024.m1E0OZlX021971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934752AbYBNA0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, linville@tuxdriver.com, yi.zhu@intel.com


The patch titled
     ipw2200: le*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     ipw2200-le_add_cpu-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -10326,9 +10326,7 @@ static int ipw_tx_skb(struct ipw_priv *p
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

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
