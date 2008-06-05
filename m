From: akpm@linux-foundation.org
Subject: - net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:27 -0700
Message-ID: <200806051821.m55ILRWX023228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbYFESVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, ram.vepa@neterion.com, santosh.rastapur@neterion.com, sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com, mm-commits@vger.kernel.org


The patch titled
     net/s2io: set_rxd_buffer_pointer returns -ENOMEM, not ENOMEM
has been removed from the -mm tree.  Its filename was
     net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/s2io: set_rxd_buffer_pointer returns -ENOMEM, not ENOMEM
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ramkrishna Vepa <ram.vepa@neterion.com>
Cc: Rastapur Santosh <santosh.rastapur@neterion.com>
Cc: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/s2io.c~net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem drivers/net/s2io.c
--- a/drivers/net/s2io.c~net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem
+++ a/drivers/net/s2io.c
@@ -6997,7 +6997,7 @@ static  int rxd_owner_bit_reset(struct s
 						       &skb,(u64 *)&temp0_64,
 						       (u64 *)&temp1_64,
 						       (u64 *)&temp2_64,
-							size) == ENOMEM) {
+							size) == -ENOMEM) {
 					return 0;
 				}
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch

