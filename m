From: akpm@linux-foundation.org
Subject: [merged]
 bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:20 -0700
Message-ID: <543d6a18.Gl/Txr2vhiCEDOa9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaJNSXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bio-integrity: remove the needless fail handle of bip_slab creating
has been removed from the -mm tree.  Its filename was
     bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: bio-integrity: remove the needless fail handle of bip_slab creating

bip_slab is created with SLAB_PANIC, so the fail handler is unneeded.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio-integrity.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN block/bio-integrity.c~bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating block/bio-integrity.c
--- a/block/bio-integrity.c~bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating
+++ a/block/bio-integrity.c
@@ -646,6 +646,4 @@ void __init bio_integrity_init(void)
 				     sizeof(struct bio_integrity_payload) +
 				     sizeof(struct bio_vec) * BIP_INLINE_VECS,
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	if (!bip_slab)
-		panic("Failed to create slab\n");
 }
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

origin.patch
linux-next.patch

