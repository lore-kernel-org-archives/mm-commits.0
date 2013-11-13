From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:01 -0800
Message-ID: <5283e329.ueAdAYY9pMYNqCSq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3KMUiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, qiuxishi@huawei.com

Subject: [merged] mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb.patch removed from -mm tree
To: qiuxishi@huawei.com,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:01 -0800


The patch titled
     Subject: mm/memory_hotplug.c: rename the function is_memblock_offlined_cb()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/memory_hotplug.c: rename the function is_memblock_offlined_cb()

A is_memblock_offlined() return or 1 means memory block is offlined, but
is_memblock_offlined_cb() returning 1 means memory block is not offlined,
this will confuse somebody, so rename the function.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb
+++ a/mm/memory_hotplug.c
@@ -1701,7 +1701,7 @@ int walk_memory_range(unsigned long star
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int is_memblock_offlined_cb(struct memory_block *mem, void *arg)
+static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int ret = !is_memblock_offlined(mem);
 
@@ -1853,7 +1853,7 @@ void __ref remove_memory(int nid, u64 st
 	 * if this is not the case.
 	 */
 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
-				is_memblock_offlined_cb);
+				check_memblock_offlined_cb);
 	if (ret) {
 		unlock_memory_hotplug();
 		BUG();
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch
linux-next.patch

