From: akpm@linux-foundation.org
Subject: +
 dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch added to -mm tree
Date: Wed, 20 Nov 2013 13:53:27 -0800
Message-ID: <528d2f57.Qv1tJo83viNgC4ln%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KTVx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 16:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joro@8bytes.org, alexander.h.duyck@intel.com, shuah.kh@samsung.com

Subject: + dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch added to -mm tree
To: shuah.kh@samsung.com,alexander.h.duyck@intel.com,joro@8bytes.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 13:53:27 -0800


The patch titled
     Subject: dma-debug: enhance dma_debug_device_change() to check for mapping errors
has been added to the -mm tree.  Its filename is
     dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: dma-debug: enhance dma_debug_device_change() to check for mapping errors

dma-debug checks to verify if driver validated the address returned by dma
mapping routines when driver does unmap.  If a driver doesn't call unmap,
failure to check mapping errors isn't detected and reported.

Enhance the existing bus notifier_call dma_debug_device_change() to check
for mapping errors at the same time it detects leaked dma buffers for
BUS_NOTIFY_UNBOUND_DRIVER event.  It scans for mapping errors and if any
found, prints one warning message that includes mapping error count.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors
+++ a/lib/dma-debug.c
@@ -717,6 +717,7 @@ static int device_dma_allocations(struct
 	struct dma_debug_entry *entry;
 	unsigned long flags;
 	int count = 0, i;
+	int map_err_cnt = 0;
 
 	local_irq_save(flags);
 
@@ -724,6 +725,8 @@ static int device_dma_allocations(struct
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
 			if (entry->dev == dev) {
+				if (entry->map_err_type == MAP_ERR_NOT_CHECKED)
+					map_err_cnt += 1;
 				count += 1;
 				*out_entry = entry;
 			}
@@ -733,6 +736,10 @@ static int device_dma_allocations(struct
 
 	local_irq_restore(flags);
 
+	if (map_err_cnt)
+		dev_warn(entry->dev,
+			"DMA-API: device driver failed to check map errors: "
+			"[count] = %d\n", map_err_cnt);
 	return count;
 }
 
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

origin.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors.patch

