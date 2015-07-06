From: akpm@linux-foundation.org
Subject: [merged] libcxgbi-use-kvfree-in-cxgbi_free_big_mem.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:47:55 -0700
Message-ID: <559adb6b.S/zDS6Ad2eSnu8oA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbbGFTrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, JBottomley@odin.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libcxgbi: use kvfree() in cxgbi_free_big_mem()
has been removed from the -mm tree.  Its filename was
     libcxgbi-use-kvfree-in-cxgbi_free_big_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: libcxgbi: use kvfree() in cxgbi_free_big_mem()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/cxgbi/libcxgbi.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/scsi/cxgbi/libcxgbi.h~libcxgbi-use-kvfree-in-cxgbi_free_big_mem drivers/scsi/cxgbi/libcxgbi.h
--- a/drivers/scsi/cxgbi/libcxgbi.h~libcxgbi-use-kvfree-in-cxgbi_free_big_mem
+++ a/drivers/scsi/cxgbi/libcxgbi.h
@@ -685,10 +685,7 @@ static inline void *cxgbi_alloc_big_mem(
 
 static inline void cxgbi_free_big_mem(void *addr)
 {
-	if (is_vmalloc_addr(addr))
-		vfree(addr);
-	else
-		kfree(addr);
+	kvfree(addr);
 }
 
 static inline void cxgbi_set_iscsi_ipv4(struct cxgbi_hba *chba, __be32 ipaddr)
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch

