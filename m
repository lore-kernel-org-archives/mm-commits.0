From: akpm@linux-foundation.org
Subject: [to-be-updated] ufs-use-little-endian-bitops.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:19 -0800
Message-ID: <201101131947.p0DJkxIN028812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756950Ab1AMTrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     ufs-use-little-endian-bitops.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/util.h~ufs-use-little-endian-bitops fs/ufs/util.h
--- a/fs/ufs/util.h~ufs-use-little-endian-bitops
+++ a/fs/ufs/util.h
@@ -408,7 +408,7 @@ static inline unsigned _ubh_find_next_ze
 	for (;;) {
 		count = min_t(unsigned int, size + offset, uspi->s_bpf);
 		size -= count - offset;
-		pos = ext2_find_next_zero_bit (ubh->bh[base]->b_data, count, offset);
+		pos = find_next_zero_le_bit((unsigned long *)ubh->bh[base]->b_data, count, offset);
 		if (pos < count || !size)
 			break;
 		base++;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch
spufs-use-simple_write_to_buffer.patch

