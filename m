From: akpm@linux-foundation.org
Subject: + memory-hotplug-dont-bug-in-register_memory_resource-v2.patch
 added to -mm tree
Date: Mon, 04 Jan 2016 13:45:39 -0800
Message-ID: <568ae803.9wv1r6yRTQLpUnz9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbcADVpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 16:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, shengyong1@huawei.com, tangchen@cn.fujitsu.com, zhugh.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-dont-bug-in-register_memory_resource-v2
has been added to the -mm tree.  Its filename is
     memory-hotplug-dont-bug-in-register_memory_resource-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-dont-bug-in-register_memory_resource-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-dont-bug-in-register_memory_resource-v2.patch

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
Subject: memory-hotplug-dont-bug-in-register_memory_resource-v2

Changes since v1:
- Use ERR_PTR/PTR_ERR/IS_ERR() [David Rientjes]

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
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

 mm/memory_hotplug.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource-v2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-dont-bug-in-register_memory_resource-v2
+++ a/mm/memory_hotplug.c
@@ -127,13 +127,12 @@ void mem_hotplug_done(void)
 }
 
 /* add this memory to iomem resource */
-static int register_memory_resource(u64 start, u64 size,
-				    struct resource **resource)
+static struct resource *register_memory_resource(u64 start, u64 size)
 {
 	struct resource *res;
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
 	if (!res)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	res->name = "System RAM";
 	res->start = start;
@@ -142,10 +141,9 @@ static int register_memory_resource(u64
 	if (request_resource(&iomem_resource, res) < 0) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		return -EEXIST;
+		return ERR_PTR(-EEXIST);
 	}
-	*resource = res;
-	return 0;
+	return res;
 }
 
 static void release_memory_resource(struct resource *res)
@@ -1314,9 +1312,9 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
-	ret = register_memory_resource(start, size, &res);
-	if (ret)
-		return ret;
+	res = register_memory_resource(start, size);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 
 	ret = add_memory_resource(nid, res);
 	if (ret < 0)
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory-hotplug-dont-bug-in-register_memory_resource.patch
memory-hotplug-dont-bug-in-register_memory_resource-v2.patch

