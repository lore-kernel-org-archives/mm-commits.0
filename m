From: akpm@linux-foundation.org
Subject: [merged] bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:13:20 -0400
Message-ID: <201004081814.o38IEmYo032358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932981Ab0DHSPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adobriyan@gmail.com, akpm@linux-foundation.org, davem@davemloft.net, dedekind@infradead.org, dwmw2@infradead.org, rmk@arm.linux.org.uk, sfr@canb.auug.org.aum


The patch titled
     bitops: rename for_each_bit() to for_each_set_bit(): mtd
has been removed from the -mm tree.  Its filename was
     bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: rename for_each_bit() to for_each_set_bit(): mtd
From: Akinobu Mita <akinobu.mita@gmail.com>

Rename for_each_bit() to for_each_set_bit in the kernel source tree.  To
permit for_each_clear_bit(), should that ever be added.

I'll be sending a patch to Linus this week which removes the temporary
for_each_bit() macro, so this patch will be needed to avoid build
breakage.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/sm_ftl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/sm_ftl.c~bitops-rename-for_each_bit-to-for_each_set_bit-mtd drivers/mtd/sm_ftl.c
--- a/drivers/mtd/sm_ftl.c~bitops-rename-for_each_bit-to-for_each_set_bit-mtd
+++ a/drivers/mtd/sm_ftl.c
@@ -934,7 +934,7 @@ int sm_cache_flush(struct sm_ftl *ftl)
 
 
 	/* Try to read all unread areas of the cache block*/
-	for_each_bit(sector_num, &ftl->cache_data_invalid_bitmap,
+	for_each_set_bit(sector_num, &ftl->cache_data_invalid_bitmap,
 		ftl->block_size / SM_SECTOR_SIZE) {
 
 		if (!sm_read_sector(ftl,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
intel-iommu-use-for_each_set_bit.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch

