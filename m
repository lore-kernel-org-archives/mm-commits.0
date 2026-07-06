Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02CB19ABD8;
	Mon,  6 Jul 2026 00:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783297503; cv=none; b=FVnnLA9lCV6MP/iiMiOMTWNrHfPI1lDVDJ8H6MVNI4Qd7non+1fnXEn7wuItFTdwZiAumeYL+l3J1KulvYApHc1bP27w4Scqtmfv5rZFd/OcysI5e4a6OtLwnZrGKr+YXWY+T4A3fE+eLjEiZjoA77ByGcjtQ5uGEaXLnZDFWoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783297503; c=relaxed/simple;
	bh=bCGdQ2URblDgbOtay0qpBnB6xMFjeIx5gHRDomOOfb4=;
	h=Date:To:From:Subject:Message-Id; b=k9ezPNCu56l83LE/2pHI4vfSvZ1bgdz9tOeZOMSkWjxx08swEFlHIpxjBWBFiLN2yI7MC7ssv/ENcdczo9e+a4E90rJKFX29JX8JFwrNWdhs1AeTqtoE5I5FKX3BL8Q6L8Lk6Hp/RE81DJKQ42y5h7wT7B9F7pW003gf0rtokwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhzzuSo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhzzuSo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2A81F000E9;
	Mon,  6 Jul 2026 00:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783297502;
	bh=f9x0hn9xNIk0s66fvdI0ZtWo+WKKUa3VOwQiKb65Zpo=;
	h=Date:To:From:Subject;
	b=GhzzuSo3hMf1XF9MC8yo5fxLg8R8e0z5l4LmlaC1IVM/T2rqgwckCMkJUGTeFKC/N
	 sFVeOWOd83GgpAAOiG1m2gvbMWnBWBpiDIPoBMM7q4DPb4leF1VAH4mD+tMSvKnac1
	 FLjoWi/ErKHT0BItl/mS46TusgSknhHLVOwo12aU=
Date: Sun, 05 Jul 2026 17:25:01 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch removed from -mm tree
Message-Id: <20260706002502.1E2A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: device-dax: fix refcount leak in __devm_create_dev_dax() error path
has been removed from the -mm tree.  Its filename was
     device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: device-dax: fix refcount leak in __devm_create_dev_dax() error path
Date: Sun, 12 Apr 2026 15:00:10 +0800

After device_initialize(), the embedded struct device in dev_dax is
expected to be released through the device core with put_device().

In __devm_create_dev_dax(), several failure paths after
device_initialize() free dev_dax directly instead of dropping the device
reference, which bypasses the normal device core lifetime handling and
leaks the reference held on the embedded struct device.

Fix this by assigning dev->type before device_initialize(), so the release
callback is available, use put_device() in the post-initialization error
paths, and keep dev_dax range cleanup explicit since it is not handled by
dev_dax_release().

Link: https://lore.kernel.org/20260412070010.2402830-1-lgs201920130244@gmail.com
Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/dax/bus.c~device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path
+++ a/drivers/dax/bus.c
@@ -1485,6 +1485,7 @@ static struct dev_dax *__devm_create_dev
 	}
 
 	dev = &dev_dax->dev;
+	dev->type = &dev_dax_type;
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
@@ -1531,7 +1532,6 @@ static struct dev_dax *__devm_create_dev
 	dev->devt = inode->i_rdev;
 	dev->bus = &dax_bus_type;
 	dev->parent = parent;
-	dev->type = &dev_dax_type;
 
 	rc = device_add(dev);
 	if (rc) {
@@ -1554,14 +1554,13 @@ static struct dev_dax *__devm_create_dev
 	return dev_dax;
 
 err_alloc_dax:
-	kfree(dev_dax->pgmap);
 err_pgmap:
 	free_dev_dax_ranges(dev_dax);
 err_range:
-	free_dev_dax_id(dev_dax);
+	put_device(dev);
+	return ERR_PTR(rc);
 err_id:
 	kfree(dev_dax);
-
 	return ERR_PTR(rc);
 }
 
_

Patches currently in -mm which might be from lgs201920130244@gmail.com are


