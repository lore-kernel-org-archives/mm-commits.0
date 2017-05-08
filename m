From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-tracepoint-to-dax_writeback_one-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:43:17 -0700
Message-ID: <5910f485.kk8ruEP/TIcQW5rc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEHWnS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-add-tracepoint-to-dax_writeback_one-fix
has been removed from the -mm tree.  Its filename was
     dax-add-tracepoint-to-dax_writeback_one-fix.patch

This patch was dropped because it was folded into dax-add-tracepoint-to-dax_writeback_one.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dax-add-tracepoint-to-dax_writeback_one-fix

struct blk_dax_ctl has disappeared

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-add-tracepoint-to-dax_writeback_one-fix fs/dax.c
--- a/fs/dax.c~dax-add-tracepoint-to-dax_writeback_one-fix
+++ a/fs/dax.c
@@ -823,7 +823,7 @@ static int dax_writeback_one(struct bloc
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
-	trace_dax_writeback_one(mapping->host, index, dax.size >> PAGE_SHIFT);
+	trace_dax_writeback_one(mapping->host, index, size >> PAGE_SHIFT);
  dax_unlock:
 	dax_read_unlock(id);
 	put_locked_mapping_entry(mapping, index, entry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
dax-add-tracepoint-to-dax_writeback_one.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

