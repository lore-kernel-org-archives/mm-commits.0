From: akpm@linux-foundation.org
Subject: + net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch added to -mm tree
Date: Mon, 12 May 2008 16:40:05 -0700
Message-ID: <200805122340.m4CNe5js014987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYELXks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, ram.vepa@neterion.com, santosh.rastapur@neterion.com, sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com


The patch titled
     net/s2io: set_rxd_buffer_pointer returns -ENOMEM, not ENOMEM
has been added to the -mm tree.  Its filename is
     net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch

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
@@ -6951,7 +6951,7 @@ static  int rxd_owner_bit_reset(struct s
 						       &skb,(u64 *)&temp0_64,
 						       (u64 *)&temp1_64,
 						       (u64 *)&temp2_64,
-							size) == ENOMEM) {
+							size) == -ENOMEM) {
 					return 0;
 				}
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

ntfs-le_add_cpu-conversion.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
cifs-cifssmbposixlock-should-return-einval-on-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

