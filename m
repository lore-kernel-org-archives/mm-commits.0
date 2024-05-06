Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979193A1CD
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957161; cv=none; b=TRbQtsKlhCgGuzu1K4LYLZiLre2hcwxfjPOKo361wephtelh6TfFzDfuJtjL9X2pS3xa1sBVnFHyvhtrt9dw0dfSzYYNluEZ0bud8he4rHIpz6d2rL77ihR3KVzERALsy+gKD7ZUZRkyy6Pn6LELg2FIuF+SL7mqj255b6yB2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957161; c=relaxed/simple;
	bh=p6ACCzh0H/BsdvVWH1Foh6OR45gQkWn87dpCoaq1vgs=;
	h=Date:To:From:Subject:Message-Id; b=Q2Qe1Awu4Owd5PHtl/CXb4Ip9g6pYoHTNN+QmqCTr6T10kQ8ngDkW/Palj30aTCDpLk34I/3sdCcOns1g5spt5+m+EiWlAX/foYWOURwwflQ/EIO1E4uQwpgGB6YpTPudy6geZr+JPTjP8zQQuCBQDF21j6vhXg1yZFySwi7uZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qltHFm69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qltHFm69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E24CC113CC;
	Mon,  6 May 2024 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957161;
	bh=p6ACCzh0H/BsdvVWH1Foh6OR45gQkWn87dpCoaq1vgs=;
	h=Date:To:From:Subject:From;
	b=qltHFm69ljhDAi5xgoBeD8w9T/5Igh9UK4k0jqTtFytlDP+Fl13BGMTLwo1QbRN7B
	 HA9WIA33CQl57RH2GGjwggR3CV6cQHeEerqoyvDhCYUdcC80n0JfnB7iJYoaqAPIyx
	 z6m4Xc0uXW0tE4k4gbaI0YyFUOIyQsZ4r2LcvpXY=
Date: Sun, 05 May 2024 17:59:20 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-busc-replace-warn_on_once-with-lockdep-asserts.patch removed from -mm tree
Message-Id: <20240506005921.6E24CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
has been removed from the -mm tree.  Its filename was
     dax-busc-replace-warn_on_once-with-lockdep-asserts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
Date: Tue, 30 Apr 2024 11:44:23 -0600

Patch series "dax/bus.c: Fixups for dax-bus locking", v3.

Commit Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by
a local rwsem") introduced a few problems that this series aims to fix. 
Add back device_lock() where it was correctly used (during device
manipulation operations), remove conditional locking in
unregister_dax_dev() and unregister_dax_mapping(), use non-interruptible
versions of rwsem locks when not called from a user process, and fix up a
write vs.  read usage of an rwsem.


This patch (of 4):

In [1], Dan points out that all of the WARN_ON_ONCE() usage in the
referenced patch should be replaced with lockdep_assert_held, or
lockdep_held_assert_write().  Replace these as appropriate.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com
Link: https://lore.kernel.org/r/65f0b5ef41817_aa222941a@dwillia2-mobl3.amr.corp.intel.com.notmuch [1]
Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-1-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
@@ -507,7 +507,7 @@ static int __free_dev_dax_id(struct dev_
 	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held_write(&dax_dev_rwsem);
 
 	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
@@ -713,7 +713,7 @@ static void __unregister_dax_mapping(voi
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
@@ -830,7 +830,7 @@ static int devm_register_dax_mapping(str
 	struct device *dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
 				"region disabled\n"))
@@ -876,7 +876,7 @@ static int alloc_dev_dax_range(struct de
 	struct resource *alloc;
 	int i, rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	/* handle the seed alloc special case */
 	if (!size) {
@@ -935,7 +935,7 @@ static int adjust_dev_dax_range(struct d
 	struct device *dev = &dev_dax->dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
 		return -EINVAL;
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


