From: akpm@linux-foundation.org
Subject: [merged] omfs-fix-potential-integer-overflow-in-allocator.patch
 removed from -mm tree
Date: Mon, 01 Jun 2015 12:16:02 -0700
Message-ID: <556caf72.RSY97bVTNpRsIlyu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbFATQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: fix potential integer overflow in allocator
has been removed from the -mm tree.  Its filename was
     omfs-fix-potential-integer-overflow-in-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Copeland <me@bobcopeland.com>
Subject: omfs: fix potential integer overflow in allocator

Both 'i' and 'bits_per_entry' are signed integers but the result is a u64
block number.  Cast i to u64 to avoid truncation on 32-bit targets.

Found by Coverity (CID 200679).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/omfs/bitmap.c~omfs-fix-potential-integer-overflow-in-allocator fs/omfs/bitmap.c
--- a/fs/omfs/bitmap.c~omfs-fix-potential-integer-overflow-in-allocator
+++ a/fs/omfs/bitmap.c
@@ -159,7 +159,7 @@ int omfs_allocate_range(struct super_blo
 	goto out;
 
 found:
-	*return_block = i * bits_per_entry + bit;
+	*return_block = (u64) i * bits_per_entry + bit;
 	*return_size = run;
 	ret = set_run(sb, i, bits_per_entry, bit, run, 1);
 
_

Patches currently in -mm which might be from me@bobcopeland.com are

linux-next.patch

