Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301D04685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560103; cv=none; b=Sh+ap6wUl5ZoQOF85kXIiH7HsyYohe/+xjdrff37zVO/spS7XtlfacG8VYIqeci9CiZQKXUsMLwyVEiigIs8qW0OFC5OC7EhYLBY50LiL7HHHEW12ibnfj6PI4aeWDWVMCxU+634zdKVViznFpcxwec0QJou/W6S0OX551ehvO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560103; c=relaxed/simple;
	bh=EWzP6tqqaYXBqtJVm+0j5D6u8Tg8XKUghCfNNHcGF58=;
	h=Date:To:From:Subject:Message-Id; b=lQtPUy1YeNNalc2EufvdsnfokZJQYwfhGPTvgfJFIP58MgRmxEYdeUMTQO/ucgD6PREVVyMUblwSdDHcoeb/63kcovj/FWa3DGhBDLiUjOJSqWWPetQwVOPKQDDyaaYmny9Mv9ROw2M6l98c11xWRbDornuv5pI1ZrpP4DOMkuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qRHFwiTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qRHFwiTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06849C43390;
	Thu, 22 Feb 2024 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560103;
	bh=EWzP6tqqaYXBqtJVm+0j5D6u8Tg8XKUghCfNNHcGF58=;
	h=Date:To:From:Subject:From;
	b=qRHFwiTvCd3xAhKPabXpLjPriRiutmWzCcEpkbqRfACjkOtx0qSekg9P2dLFaQfud
	 9MZ7vUoLO0iP2ZEm/AqYbxThxGMC8sHX7qFqCbUd3kxNvWOmuxt1lg4/4qFkYoGI6w
	 40GnzHkPs2M8++noCLnmN4YIxOH2PfmvBfbMzQKE=
Date: Wed, 21 Feb 2024 16:01:42 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch removed from -mm tree
Message-Id: <20240222000143.06849C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: add a sysfs knob to control memmap_on_memory behavior
has been removed from the -mm tree.  Its filename was
     dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax: add a sysfs knob to control memmap_on_memory behavior
Date: Wed, 24 Jan 2024 12:03:50 -0800

Add a sysfs knob for dax devices to control the memmap_on_memory setting
if the dax device were to be hotplugged as system memory.

The default memmap_on_memory setting for dax devices originating via pmem
or hmem is set to 'false' - i.e.  no memmap_on_memory semantics, to
preserve legacy behavior.  For dax devices via CXL, the default is on. 
The sysfs control allows the administrator to override the above defaults
if needed.

Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-5-20d16cb8d23d@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang, Ying <ying.huang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-dax |   17 ++++++++
 drivers/dax/bus.c                       |   43 ++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/Documentation/ABI/testing/sysfs-bus-dax~dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior
+++ a/Documentation/ABI/testing/sysfs-bus-dax
@@ -134,3 +134,20 @@ KernelVersion:	v5.1
 Contact:	nvdimm@lists.linux.dev
 Description:
 		(RO) The id attribute indicates the region id of a dax region.
+
+What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
+Date:		January, 2024
+KernelVersion:	v6.8
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Control the memmap_on_memory setting if the dax device
+		were to be hotplugged as system memory. This determines whether
+		the 'altmap' for the hotplugged memory will be placed on the
+		device being hotplugged (memmap_on_memory=1) or if it will be
+		placed on regular memory (memmap_on_memory=0). This attribute
+		must be set before the device is handed over to the 'kmem'
+		driver (i.e.  hotplugged into system-ram). Additionally, this
+		depends on CONFIG_MHP_MEMMAP_ON_MEMORY, and a globally enabled
+		memmap_on_memory parameter for memory_hotplug. This is
+		typically set on the kernel command line -
+		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
--- a/drivers/dax/bus.c~dax-add-a-sysfs-knob-to-control-memmap_on_memory-behavior
+++ a/drivers/dax/bus.c
@@ -1349,6 +1349,48 @@ static ssize_t numa_node_show(struct dev
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	if (val == true && !mhp_supports_memmap_on_memory()) {
+		dev_dbg(dev, "memmap_on_memory is not available\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = down_write_killable(&dax_dev_rwsem);
+	if (rc)
+		return rc;
+
+	if (dev_dax->memmap_on_memory != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->memmap_on_memory = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1375,6 +1417,7 @@ static struct attribute *dev_dax_attribu
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


