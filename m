From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-dont-bug-in-register_memory_resource.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:00:06 -0800
Message-ID: <569e95c6.fAF2yIO4qS4JttMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASUAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, shengyong1@huawei.com, tangchen@cn.fujitsu.com, zhugh.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: don't BUG() in register_memory_resource()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-dont-bug-in-register_memory_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory-hotplug: don't BUG() in register_memory_resource()

Out of memory condition is not a bug and while we can't add new memory in
such case crashing the system seems wrong.  Propagating the return value
from register_memory_resource() requires interface change.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Sheng Yong <shengyong1@huawei.com>
Cc: Zhu Guihua <zhugh.fnst@cn.fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource
+++ a/mm/memory_hotplug.c
@@ -131,7 +131,8 @@ static struct resource *register_memory_
 {
 	struct resource *res;
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-	BUG_ON(!res);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
 
 	res->name = "System RAM";
 	res->start = start;
@@ -140,7 +141,7 @@ static struct resource *register_memory_
 	if (request_resource(&iomem_resource, res) < 0) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		res = NULL;
+		return ERR_PTR(-EEXIST);
 	}
 	return res;
 }
@@ -1312,8 +1313,8 @@ int __ref add_memory(int nid, u64 start,
 	int ret;
 
 	res = register_memory_resource(start, size);
-	if (!res)
-		return -EEXIST;
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 
 	ret = add_memory_resource(nid, res);
 	if (ret < 0)
_

Patches currently in -mm which might be from vkuznets@redhat.com are


