From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?drivers-base-memory-store-mapping-between-mmop=5F-and-stri?=
 =?US-ASCII?Q?ng-in-an-array.patch?= added to -mm tree
Date: Tue, 17 Mar 2020 21:08:39 -0700
Message-ID: <20200318040839.Gh8MLIOdi%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgCREIm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 00:08:42 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: drivers/base/memory: store mapping between MMOP_* and string in an array
has been added to the -mm tree.  Its filename is
     drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org, David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>, "Rafael J. Wysocki" <rafael@kernel.org>, Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 3/8] drivers/base/memory: store mapping between MMOP_* and string in an array
Date: Tue, 17 Mar 2020 11:49:37 +0100

Let's use a simple array which we can reuse soon. While at it, move the
string->mmop conversion out of the device hotplug lock.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index e7e77cafef80..8a7f29c0bf97 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -28,6 +28,24 @@
 
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
@@ -236,26 +254,17 @@ static int memory_subsys_offline(struct device *dev)
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
-
 	switch (online_type) {
 	case MMOP_ONLINE_KERNEL:
 	case MMOP_ONLINE_MOVABLE:
@@ -271,7 +280,6 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		ret = -EINVAL; /* should never happen */
 	}
 
-err:
 	unlock_device_hotplug();
 
 	if (ret < 0)
-- 
2.24.1

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
virtio-balloon-switch-back-to-oom-handler-for-virtio_balloon_f_deflate_on_oom.patch
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch
mm-memory_hotplug-cleanup-__add_pages.patch
drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch
drivers-base-memory-map-mmop_offline-to-0.patch
drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch
powernv-memtrace-always-online-added-memory-blocks.patch
hv_balloon-dont-check-for-memhp_auto_online-manually.patch
mm-memory_hotplug-unexport-memhp_auto_online.patch
mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
mm-memory_hotplug-allow-to-specify-a-default-online_type.patch
