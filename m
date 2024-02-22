Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB5846BB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560100; cv=none; b=mDajMZFDci768yhJiqSLlxS3TBCLta+1JT18rzEDope5GdcWSDqpL5i7FGRauh1kr/jzf2B1b56YuABQkg+GzTAgVs5PzvG7T6ZtkVwTg7nvqvUJ2hwehV4gLq85DNYTkMnWnViC+5PpoOWuaBgXCEYoBOXdSy4Kfx2v+rZKE4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560100; c=relaxed/simple;
	bh=hYQ6Bdf8OaQ2tJEysoBcHFIeZAadzb4/6qw0Q7a0eO8=;
	h=Date:To:From:Subject:Message-Id; b=qG+iC0G5YQ8D82UDmA7sn28Nav3qwUQWFmdpcNTgy26PstcENKZJ/99hZotMXdgVGy0WvSWmr43pVmH5cxH01yfNih+2S7fLpN2VhXYEb43VLiUOZjTCP7FV5CgFWCYNPNI1rWI/zgooFjAcu2RYomACeCOWKKSE2d8NdsLIkaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TLbcLLyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TLbcLLyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E10C433C7;
	Thu, 22 Feb 2024 00:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560100;
	bh=hYQ6Bdf8OaQ2tJEysoBcHFIeZAadzb4/6qw0Q7a0eO8=;
	h=Date:To:From:Subject:From;
	b=TLbcLLyW0dIqgW8pSF44SBBM1HD0MtYR35kM85yCiwaV840MssQLEcUrqNOM2FArn
	 n4H/c3pn/hI97T1tmFHE5U4t+vOXCJ48TnubBkiilMK5R028uySufPK0EPQEEm9zX8
	 qvU7/Jvf8BWCj5+0fPHHK9n+41rexwEZ88r/sWpw=
Date: Wed, 21 Feb 2024 16:01:39 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-busc-replace-several-sprintf-with-sysfs_emit.patch removed from -mm tree
Message-Id: <20240222000140.32E10C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/bus.c: replace several sprintf() with sysfs_emit()
has been removed from the -mm tree.  Its filename was
     dax-busc-replace-several-sprintf-with-sysfs_emit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: replace several sprintf() with sysfs_emit()
Date: Wed, 24 Jan 2024 12:03:47 -0800

There were several places where drivers/dax/bus.c uses 'sprintf' to print
sysfs data.  Since a sysfs_emit() helper is available specifically for
this purpose, replace all the sprintf() usage for sysfs with sysfs_emit()
in this file.

Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-2-20d16cb8d23d@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-replace-several-sprintf-with-sysfs_emit
+++ a/drivers/dax/bus.c
@@ -269,7 +269,7 @@ static ssize_t id_show(struct device *de
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", dax_region->id);
+	return sysfs_emit(buf, "%d\n", dax_region->id);
 }
 static DEVICE_ATTR_RO(id);
 
@@ -278,8 +278,8 @@ static ssize_t region_size_show(struct d
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%llu\n", (unsigned long long)
-			resource_size(&dax_region->res));
+	return sysfs_emit(buf, "%llu\n",
+			  (unsigned long long)resource_size(&dax_region->res));
 }
 static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
 		region_size_show, NULL);
@@ -289,7 +289,7 @@ static ssize_t region_align_show(struct
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%u\n", dax_region->align);
+	return sysfs_emit(buf, "%u\n", dax_region->align);
 }
 static struct device_attribute dev_attr_region_align =
 		__ATTR(align, 0400, region_align_show, NULL);
@@ -322,7 +322,7 @@ static ssize_t available_size_show(struc
 	size = dax_region_avail_size(dax_region);
 	up_read(&dax_region_rwsem);
 
-	return sprintf(buf, "%llu\n", size);
+	return sysfs_emit(buf, "%llu\n", size);
 }
 static DEVICE_ATTR_RO(available_size);
 
@@ -340,7 +340,7 @@ static ssize_t seed_show(struct device *
 	if (rc)
 		return rc;
 	seed = dax_region->seed;
-	rc = sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
+	rc = sysfs_emit(buf, "%s\n", seed ? dev_name(seed) : "");
 	up_read(&dax_region_rwsem);
 
 	return rc;
@@ -361,7 +361,7 @@ static ssize_t create_show(struct device
 	if (rc)
 		return rc;
 	youngest = dax_region->youngest;
-	rc = sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
+	rc = sysfs_emit(buf, "%s\n", youngest ? dev_name(youngest) : "");
 	up_read(&dax_region_rwsem);
 
 	return rc;
@@ -763,7 +763,7 @@ static ssize_t start_show(struct device
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#llx\n", dax_range->range.start);
+	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.start);
 	put_dax_range();
 
 	return rc;
@@ -779,7 +779,7 @@ static ssize_t end_show(struct device *d
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#llx\n", dax_range->range.end);
+	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.end);
 	put_dax_range();
 
 	return rc;
@@ -795,7 +795,7 @@ static ssize_t pgoff_show(struct device
 	dax_range = get_dax_range(dev);
 	if (!dax_range)
 		return -ENXIO;
-	rc = sprintf(buf, "%#lx\n", dax_range->pgoff);
+	rc = sysfs_emit(buf, "%#lx\n", dax_range->pgoff);
 	put_dax_range();
 
 	return rc;
@@ -969,7 +969,7 @@ static ssize_t size_show(struct device *
 	size = dev_dax_size(dev_dax);
 	up_write(&dax_dev_rwsem);
 
-	return sprintf(buf, "%llu\n", size);
+	return sysfs_emit(buf, "%llu\n", size);
 }
 
 static bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
@@ -1233,7 +1233,7 @@ static ssize_t align_show(struct device
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
-	return sprintf(buf, "%d\n", dev_dax->align);
+	return sysfs_emit(buf, "%d\n", dev_dax->align);
 }
 
 static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
@@ -1311,7 +1311,7 @@ static ssize_t target_node_show(struct d
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
-	return sprintf(buf, "%d\n", dev_dax_target_node(dev_dax));
+	return sysfs_emit(buf, "%d\n", dev_dax_target_node(dev_dax));
 }
 static DEVICE_ATTR_RO(target_node);
 
@@ -1327,7 +1327,7 @@ static ssize_t resource_show(struct devi
 	else
 		start = dev_dax->ranges[0].range.start;
 
-	return sprintf(buf, "%#llx\n", start);
+	return sysfs_emit(buf, "%#llx\n", start);
 }
 static DEVICE_ATTR(resource, 0400, resource_show, NULL);
 
@@ -1338,14 +1338,14 @@ static ssize_t modalias_show(struct devi
 	 * We only ever expect to handle device-dax instances, i.e. the
 	 * @type argument to MODULE_ALIAS_DAX_DEVICE() is always zero
 	 */
-	return sprintf(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
+	return sysfs_emit(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
 }
 static DEVICE_ATTR_RO(modalias);
 
 static ssize_t numa_node_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev_to_node(dev));
+	return sysfs_emit(buf, "%d\n", dev_to_node(dev));
 }
 static DEVICE_ATTR_RO(numa_node);
 
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


