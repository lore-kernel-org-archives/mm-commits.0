From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-store_mem_state-return-value.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:10 -0700
Message-ID: <57fc19f6.6bCAqT7dSaSuWr4v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36939 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbcJJWpM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, abanman@sgi.com, baiyaowei@cmss.chinamobile.com, dan.j.williams@intel.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, qiuxishi@huawei.com, rientjes@google.com, sjenning@redhat.com, slaoub@gmail.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix store_mem_state() return value
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-store_mem_state-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: memory-hotplug: fix store_mem_state() return value

If store_mem_state() is called to online memory which is already online,
it will return 1, the value it got from device_online().

This is wrong because store_mem_state() is a device_attribute .store
function. Thus a non-negative return value represents input bytes read.

Set the return value to -EINVAL in this case.

Link: http://lkml.kernel.org/r/1472743777-24266-1-git-send-email-arbab@linux.vnet.ibm.com
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
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-fix-store_mem_state-return-value drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-fix-store_mem_state-return-value
+++ a/drivers/base/memory.c
@@ -361,8 +361,11 @@ store_mem_state(struct device *dev,
 err:
 	unlock_device_hotplug();
 
-	if (ret)
+	if (ret < 0)
 		return ret;
+	if (ret)
+		return -EINVAL;
+
 	return count;
 }
 
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are


