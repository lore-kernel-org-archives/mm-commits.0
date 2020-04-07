From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 065/166] drivers/base/memory: store mapping
 between MMOP_* and string in an array
Date: Mon, 06 Apr 2020 20:07:24 -0700
Message-ID: <20200407030724.a575NWGhH%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDH0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:26 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, torvalds@linux-foundation.org, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: store mapping between MMOP_* and string in an array

Let's use a simple array which we can reuse soon.  While at it, move the
string->mmop conversion out of the device hotplug lock.

Link: http://lkml.kernel.org/r/20200317104942.11178-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array
+++ a/drivers/base/memory.c
@@ -27,6 +27,24 @@
 
 #define MEMORY_CLASS_NAME	"memory"
 
+static const char *const online_type_to_str[] = {
+	[MMOP_OFFLINE] = "offline",
+	[MMOP_ONLINE] = "online",
+	[MMOP_ONLINE_KERNEL] = "online_kernel",
+	[MMOP_ONLINE_MOVABLE] = "online_movable",
+};
+
+static int memhp_online_type_from_str(const char *str)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(online_type_to_str); i++) {
+		if (sysfs_streq(str, online_type_to_str[i]))
+			return i;
+	}
+	return -EINVAL;
+}
+
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
 static int sections_per_block;
@@ -228,26 +246,17 @@ static int memory_subsys_offline(struct
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
+	const int online_type = memhp_online_type_from_str(buf);
 	struct memory_block *mem = to_memory_block(dev);
-	int ret, online_type;
+	int ret;
+
+	if (online_type < 0)
+		return -EINVAL;
 
 	ret = lock_device_hotplug_sysfs();
 	if (ret)
 		return ret;
 
-	if (sysfs_streq(buf, "online_kernel"))
-		online_type = MMOP_ONLINE_KERNEL;
-	else if (sysfs_streq(buf, "online_movable"))
-		online_type = MMOP_ONLINE_MOVABLE;
-	else if (sysfs_streq(buf, "online"))
-		online_type = MMOP_ONLINE;
-	else if (sysfs_streq(buf, "offline"))
-		online_type = MMOP_OFFLINE;
-	else {
-		ret = -EINVAL;
-		goto err;
-	}
