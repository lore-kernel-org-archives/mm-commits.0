Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD8F329E4B;
	Sun, 12 Apr 2026 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776016555; cv=none; b=uwaegAGJPcTccHYGnsFnYyzJXXSeePqejNwEj8lH2R4PBBtxBmS7QjQr7XkT8FK2eOno4Dn2oMaBLckXDkyC9B2cALwvsHBVHrXcH31LvZKXtlPVavqGIoR7t002laPn9GHAQeohnj95SvxNZWOmo2DqrlvXtp3L36o3PXMaLms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776016555; c=relaxed/simple;
	bh=x2S9LN/2FFE0/+kI1Vz4eWRekS5JbdDRAcR7NFxUnfQ=;
	h=Date:To:From:Subject:Message-Id; b=XIYZKEhDPxCUDasgFI4RQNBI+Kmn+/KAbKagP91oX6yIxzRNvl+3RwC/cic+jFU7PEY00wMvj7JoSScdNs87JILesnIhG/urH7AIAcc+huQE4Wqp85pWBsko6ll8TAq6oVQD1OryLigrBbA84w1k84hqU1befDpXaoXF0Fz+JtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0jC2DR9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0jC2DR9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E105C19424;
	Sun, 12 Apr 2026 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776016554;
	bh=x2S9LN/2FFE0/+kI1Vz4eWRekS5JbdDRAcR7NFxUnfQ=;
	h=Date:To:From:Subject:From;
	b=0jC2DR9BAH+6qO8RaQAe7CKiqIKrmYshAbwg0b4S+0Sz1BtChAoI18M3U6HLY01n7
	 8+0ihkz9wbsik0stqr0fRDIORA+uyUorQborYy96i4OhtxXmJyzFNRRfvXQ+JTYbmn
	 /bUR2X5XIOevOEV8R7n7rSzs0+zuCNcQh0j4KY3k=
Date: Sun, 12 Apr 2026 10:55:51 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20260412175554.5E105C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: device-dax: Fix refcount leak in __devm_create_dev_dax() error path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: device-dax: Fix refcount leak in __devm_create_dev_dax() error path
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

Link: https://lkml.kernel.org/r/20260412070010.2402830-1-lgs201920130244@gmail.com
Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/dax/bus.c~device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path
+++ a/drivers/dax/bus.c
@@ -1453,6 +1453,7 @@ static struct dev_dax *__devm_create_dev
 	}
 
 	dev = &dev_dax->dev;
+	dev->type = &dev_dax_type;
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
@@ -1499,7 +1500,6 @@ static struct dev_dax *__devm_create_dev
 	dev->devt = inode->i_rdev;
 	dev->bus = &dax_bus_type;
 	dev->parent = parent;
-	dev->type = &dev_dax_type;
 
 	rc = device_add(dev);
 	if (rc) {
@@ -1522,14 +1522,13 @@ static struct dev_dax *__devm_create_dev
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

device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch

