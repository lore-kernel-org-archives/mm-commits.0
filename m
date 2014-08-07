From: akpm@linux-foundation.org
Subject: [merged]
 mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:49 -0700
Message-ID: <53e3dba5.fdTyP4IduyWL6683%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37715 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaHGUDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:50 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so613143qap.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, gregkh@linuxfoundation.org, guz.fnst@cn.fujitsu.com, hutao@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: avoid illegal state prefixed with legal state when changing state of memory_block
has been removed from the -mm tree.  Its filename was
     mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mem-hotplug: avoid illegal state prefixed with legal state when changing state of memory_block

We use the following command to online a memory_block:

echo online|online_kernel|online_movable > /sys/devices/system/memory/memoryXXX/state

But, if we do the following:

echo online_fhsjkghfkd > /sys/devices/system/memory/memoryXXX/state

the block will also be onlined.

This is because the following code in store_mem_state() does not compare
the whole string, but only the prefix of the string.

store_mem_state()
{
	......
 328         if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))

Here, only compare the first 13 letters of the string. If we give "online_kernelXXXXXX",
it will be recognized as online_kernel, which is incorrect.

 329                 online_type = ONLINE_KERNEL;
 330         else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))

We have the same problem here,

 331                 online_type = ONLINE_MOVABLE;
 332         else if (!strncmp(buf, "online", min_t(int, count, 6)))

here,

(Here is more problematic. If we give online_movalbe, which is a typo of online_movable,
 it will be recognized as online without noticing the author.)

 333                 online_type = ONLINE_KEEP;
 334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))

and here.

 335                 online_type = -1;
 336         else {
 337                 ret = -EINVAL;
 338                 goto err;
 339         }
	......
}

This patch fix this problem by using sysfs_streq() to compare the whole string.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reported-by: Hu Tao <hutao@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/base/memory.c~mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block drivers/base/memory.c
--- a/drivers/base/memory.c~mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block
+++ a/drivers/base/memory.c
@@ -315,13 +315,13 @@ store_mem_state(struct device *dev,
 	if (ret)
 		return ret;
 
-	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
+	if (sysfs_streq(buf, "online_kernel"))
 		online_type = ONLINE_KERNEL;
-	else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))
+	else if (sysfs_streq(buf, "online_movable"))
 		online_type = ONLINE_MOVABLE;
-	else if (!strncmp(buf, "online", min_t(int, count, 6)))
+	else if (sysfs_streq(buf, "online"))
 		online_type = ONLINE_KEEP;
-	else if (!strncmp(buf, "offline", min_t(int, count, 7)))
+	else if (sysfs_streq(buf, "offline"))
 		online_type = -1;
 	else {
 		ret = -EINVAL;
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch

