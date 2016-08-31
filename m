From: akpm@linux-foundation.org
Subject: [nacked] memory-hotplug-fix-store_mem_state-return-value.patch
 removed from -mm tree
Date: Wed, 31 Aug 2016 14:31:34 -0700
Message-ID: <57c74cb6.FjYFdZDv1tFH0xHR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753356AbcHaVbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 17:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, abanman@sgi.com, baiyaowei@cmss.chinamobile.com, dan.j.williams@intel.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, qiuxishi@huawei.com, rientjes@google.com, slaoub@gmail.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix store_mem_state() return value
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-store_mem_state-return-value.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: memory-hotplug: fix store_mem_state() return value

Attempting to online memory which is already online will cause this:

1. store_mem_state() called with buf="online"
2. device_online() returns 1 because device is already online
3. store_mem_state() returns 1
4. calling code interprets this as 1-byte buffer read
5. store_mem_state() called again with buf="nline"
6. store_mem_state() returns -EINVAL

Example:

$ cat /sys/devices/system/memory/memory0/state
online
$ echo online > /sys/devices/system/memory/memory0/state
-bash: echo: write error: Invalid argument

Fix the return value of store_mem_state() so this doesn't happen.

Link: http://lkml.kernel.org/r/1472658241-32748-1-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Andrew Banman <abanman@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-fix-store_mem_state-return-value drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-fix-store_mem_state-return-value
+++ a/drivers/base/memory.c
@@ -361,7 +361,7 @@ store_mem_state(struct device *dev,
 err:
 	unlock_device_hotplug();
 
-	if (ret)
+	if (ret < 0)
 		return ret;
 	return count;
 }
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are


