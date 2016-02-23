From: akpm@linux-foundation.org
Subject: [merged] devm_memremap_release-fix-memremapd-addr-handling.patch
 removed from -mm tree
Date: Tue, 23 Feb 2016 12:49:50 -0800
Message-ID: <56ccc5ee.VYyqQ2qf0iotWxsT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbcBWUtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 15:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, dan.j.williams@intel.com, hch@lst.de, ross.zwisler@linux.intel.com, stable@vger.kernel.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: devm_memremap_release(): fix memremap'd addr handling
has been removed from the -mm tree.  Its filename was
     devm_memremap_release-fix-memremapd-addr-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: devm_memremap_release(): fix memremap'd addr handling

The pmem driver calls devm_memremap() to map a persistent memory range.
When the pmem driver is unloaded, this memremap'd range is not
released so the kernel will leak a vma.

Fix devm_memremap_release() to handle a given memremap'd address properly.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/memremap.c~devm_memremap_release-fix-memremapd-addr-handling kernel/memremap.c
--- a/kernel/memremap.c~devm_memremap_release-fix-memremapd-addr-handling
+++ a/kernel/memremap.c
@@ -114,7 +114,7 @@ EXPORT_SYMBOL(memunmap);
 
 static void devm_memremap_release(struct device *dev, void *res)
 {
-	memunmap(res);
+	memunmap(*(void **)res);
 }
 
 static int devm_memremap_match(struct device *dev, void *res, void *match_data)
_

Patches currently in -mm which might be from toshi.kani@hpe.com are


