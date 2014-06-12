From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch added to -mm tree
Date: Thu, 12 Jun 2014 12:28:34 -0700
Message-ID: <5399ff62.qMQeveFCjiqKDi4a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaFLT2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 15:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hutao@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, tangchen@cn.fujitsu.com

Subject: + mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gregkh@linuxfoundation.org,guz.fnst@cn.fujitsu.com,hutao@cn.fujitsu.com,isimatu.yasuaki@jp.fujitsu.com,laijs@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 12:28:34 -0700


The patch titled
     Subject: mem-hotplug: avoid illegal state prefixed with legal state when changing state of memory_block
has been added to the -mm tree.  Its filename is
     mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

