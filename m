Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABDE13A25E
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712266504; cv=none; b=tiq9gkUmBoJadH0pN93KLNBqNWgoTGgVfpk764dg2LT5iYJh3+6f74qONAIaOY8I20qd+ZRH1UvGqD/ehxVsHvG47ztvxiLl1KNSdk6W1QiFvT+IV5QOg62d3yklmI+Hs/92TlSMe4pHLudSPZX/+vT/u42xH3yvUPu0gJ/Iv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712266504; c=relaxed/simple;
	bh=G3bFjNeYSoF6hsySe3pbKDX7hs6z6TRJtZidbCF7fuU=;
	h=Date:To:From:Subject:Message-Id; b=MButzzYqilzWhP/yNevGlAUu6ItgLu7g/lC6sec5Fw9JSp4zYP6LqVNS+hViYAfRxwCDJOCS4fnqHmtUxMcFat02AxJIcjKzt8gV/eE6Ht+yf0LlIVTg9usbAATMQzBKpmynrJir/46NwgtwaAM6fWecijzTqgB119BbWST52N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+lUCgpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+lUCgpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3D8C433F1;
	Thu,  4 Apr 2024 21:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712266504;
	bh=G3bFjNeYSoF6hsySe3pbKDX7hs6z6TRJtZidbCF7fuU=;
	h=Date:To:From:Subject:From;
	b=k+lUCgpc0hOsdbsdt5S61lb0qyf2oNbsM12DS2Ft8+Oe91luSGCwBf5Inxd3+opMa
	 zYa8RqIBisDc8OnAVIluk8Tfd0FwQAVOIopJ6O4I7g9XI7YqXtWPNWiVpsez7fjXiL
	 KJOmQkGZjB0gbyVA5jEe70pQTiKUCnIJuZk6KziM=
Date: Thu, 04 Apr 2024 14:35:03 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] dax-busc-replace-warn_on_once-with-lockdep-asserts.patch removed from -mm tree
Message-Id: <20240404213504.0E3D8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
has been removed from the -mm tree.  Its filename was
     dax-busc-replace-warn_on_once-with-lockdep-asserts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
Date: Tue, 02 Apr 2024 00:24:28 -0600

In [1], Dan points out that all of the WARN_ON_ONCE() usage in the
referenced patch should be replaced with lockdep_assert_held(_write)().

Replace those, and additionally, replace a couple of other WARN_ON_ONCE()
introduced in the same patch for actual failure cases (i.e.  when
acquiring a semaphore fails in a remove / unregister path) with
dev_WARN_ONCE() as is the precedent here.

Recall that previously, unregistration paths was implicitly protected by
overloading the device lock, which the patch in [1] sought to remove. 
This meant adding a semaphore acquisition in these unregistration paths. 
Since that can fail, and it doesn't make sense to return errors from these
paths, retain the two instances of (now) dev_WARN_ONCE().

Link: https://lore.kernel.org/r/65f0b5ef41817_aa222941a@dwillia2-mobl3.amr.corp.intel.com.notmuch [1]
Link: https://lkml.kernel.org/r/20240402-vv-dax_abi_fixes-v1-1-c3e0fdbafba5@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-replace-warn_on_once-with-lockdep-asserts
+++ a/drivers/dax/bus.c
@@ -192,7 +192,7 @@ static u64 dev_dax_size(struct dev_dax *
 	u64 size = 0;
 	int i;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held(&dax_dev_rwsem);
 
 	for (i = 0; i < dev_dax->nr_range; i++)
 		size += range_len(&dev_dax->ranges[i].range);
@@ -302,7 +302,7 @@ static unsigned long long dax_region_ava
 	resource_size_t size = resource_size(&dax_region->res);
 	struct resource *res;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held(&dax_region_rwsem);
 
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
@@ -447,7 +447,7 @@ static void trim_dev_dax_range(struct de
 	struct range *range = &dev_dax->ranges[i].range;
 	struct dax_region *dax_region = dev_dax->region;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
@@ -471,6 +471,7 @@ static void __unregister_dev_dax(void *d
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	lockdep_assert_held_write(&dax_region_rwsem);
 	kill_dev_dax(dev_dax);
 	device_del(dev);
 	free_dev_dax_ranges(dev_dax);
@@ -482,7 +483,8 @@ static void unregister_dev_dax(void *dev
 	if (rwsem_is_locked(&dax_region_rwsem))
 		return __unregister_dev_dax(dev);
 
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
+	if (dev_WARN_ONCE(dev, down_write_killable(&dax_region_rwsem) != 0,
+			  "unable to acquire region rwsem\n"))
 		return;
 	__unregister_dev_dax(dev);
 	up_write(&dax_region_rwsem);
@@ -507,7 +509,7 @@ static int __free_dev_dax_id(struct dev_
 	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held_write(&dax_dev_rwsem);
 
 	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
@@ -713,7 +715,7 @@ static void __unregister_dax_mapping(voi
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
@@ -726,7 +728,8 @@ static void unregister_dax_mapping(void
 	if (rwsem_is_locked(&dax_region_rwsem))
 		return __unregister_dax_mapping(data);
 
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
+	if (dev_WARN_ONCE(data, down_write_killable(&dax_region_rwsem) != 0,
+			  "unable to acquire region rwsem\n"))
 		return;
 	__unregister_dax_mapping(data);
 	up_write(&dax_region_rwsem);
@@ -830,7 +833,7 @@ static int devm_register_dax_mapping(str
 	struct device *dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
 				"region disabled\n"))
@@ -876,7 +879,7 @@ static int alloc_dev_dax_range(struct de
 	struct resource *alloc;
 	int i, rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	/* handle the seed alloc special case */
 	if (!size) {
@@ -935,7 +938,7 @@ static int adjust_dev_dax_range(struct d
 	struct device *dev = &dev_dax->dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
 		return -EINVAL;
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


