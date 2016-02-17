From: akpm@linux-foundation.org
Subject: + devm_memremap_release-fix-memremapd-addr-handling.patch added
 to -mm tree
Date: Tue, 16 Feb 2016 16:18:52 -0800
Message-ID: <56c3bc6c.68JP1t/teuo12xdM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbcBQASx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 19:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, dan.j.williams@intel.com, hch@lst.de, ross.zwisler@linux.intel.com, stable@vger.kernel.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: devm_memremap_release(): fix memremap'd addr handling
has been added to the -mm tree.  Its filename is
     devm_memremap_release-fix-memremapd-addr-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/devm_memremap_release-fix-memremapd-addr-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/devm_memremap_release-fix-memremapd-addr-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: devm_memremap_release(): fix memremap'd addr handling

The pmem driver calls devm_memremap() to map a persistent memory range. 
When the pmem driver is unloaded, this memremap'd range is not released.

Fix devm_memremap_release() to handle a given memremap'd address properly.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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

devm_memremap_release-fix-memremapd-addr-handling.patch

