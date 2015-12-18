From: akpm@linux-foundation.org
Subject: + memory-hotplug-dont-bug-in-register_memory_resource.patch added to -mm tree
Date: Fri, 18 Dec 2015 14:50:58 -0800
Message-ID: <56748dd2.mwStyCZv5+Y17CuR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbbLRWu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 17:50:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, shengyong1@huawei.com, tangchen@cn.fujitsu.com, zhugh.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: don't BUG() in register_memory_resource()
has been added to the -mm tree.  Its filename is
     memory-hotplug-dont-bug-in-register_memory_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-dont-bug-in-register_memory_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-dont-bug-in-register_memory_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory-hotplug: don't BUG() in register_memory_resource()

Out of memory condition is not a bug and while we can't add new memory in
such case crashing the system seems wrong.  Propagating the return value
from register_memory_resource() requires interface change.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Sheng Yong <shengyong1@huawei.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhu Guihua <zhugh.fnst@cn.fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource
+++ a/mm/memory_hotplug.c
@@ -127,11 +127,13 @@ void mem_hotplug_done(void)
 }
 
 /* add this memory to iomem resource */
-static struct resource *register_memory_resource(u64 start, u64 size)
+static int register_memory_resource(u64 start, u64 size,
+				    struct resource **resource)
 {
 	struct resource *res;
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-	BUG_ON(!res);
+	if (!res)
+		return -ENOMEM;
 
 	res->name = "System RAM";
 	res->start = start;
@@ -140,9 +142,10 @@ static struct resource *register_memory_
 	if (request_resource(&iomem_resource, res) < 0) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		res = NULL;
+		return -EEXIST;
 	}
-	return res;
+	*resource = res;
+	return 0;
 }
 
 static void release_memory_resource(struct resource *res)
@@ -1311,9 +1314,9 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
-	res = register_memory_resource(start, size);
-	if (!res)
-		return -EEXIST;
+	ret = register_memory_resource(start, size, &res);
+	if (ret)
+		return ret;
 
 	ret = add_memory_resource(nid, res);
 	if (ret < 0)
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory-hotplug-dont-bug-in-register_memory_resource.patch

