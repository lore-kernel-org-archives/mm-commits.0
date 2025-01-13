Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708B425761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742138; cv=none; b=MwkG5Op6xOsdnj90BtSjEUMnCeoqkezTuLpE2B9Zb+c4dX7aQ/lT6IoSqT6hvUaUsYZk1uL3ODpJHkOcb8tQ0PX/9GscKkFDlWdkUz8w5p04UWmY7gUeSJNenquIP+dYO5uKfpjRDy+c1Z6ErL1DPnhiGh32RQjFF0vWHB0JOXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742138; c=relaxed/simple;
	bh=KNDdVi/bLcT9VE9wA24uRBS2ALMsvz4svWzXScQfFnc=;
	h=Date:To:From:Subject:Message-Id; b=tyfS5JVCeNv3QUt0bnCEcRP+UdTU2LkceJV4cMJ4RVGJAYNGJJBplqN7pQniiLEaiihwaRCyiiCvG0pERtHtJBcji15o3wLJ+zCPJtwQ5QjWNsMEd8YLGV24RxyNiw7rU9LBFxuV06p9dRfh0OfUopFOEPPNeEpDrKy17evDJWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zz77EzRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zz77EzRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D5AC4CED6;
	Mon, 13 Jan 2025 04:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742137;
	bh=KNDdVi/bLcT9VE9wA24uRBS2ALMsvz4svWzXScQfFnc=;
	h=Date:To:From:Subject:From;
	b=zz77EzRlSO1+FGd+R6cVuswJIhPM8Yt+JqXiUKJl8KsvmecP/uO1ahDpJrLPvEayC
	 7aPSWgIIQqfR2jlDO2G45Ak0HlJHgkhUUmoU+JKxPGy0KQanmDFJMFowC+KQd+R4AZ
	 3kbx0Dw3vLVHNGZAcXv+Mf5WnnGX0pjlhxUrJvmI=
Date: Sun, 12 Jan 2025 20:22:16 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,ilpo.jarvinen@linux.intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-resource-simplify-api-__devm_release_region-implementation.patch removed from -mm tree
Message-Id: <20250113042216.F1D5AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/resource: simplify API __devm_release_region() implementation
has been removed from the -mm tree.  Its filename was
     kernel-resource-simplify-api-__devm_release_region-implementation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: kernel/resource: simplify API __devm_release_region() implementation
Date: Thu, 17 Oct 2024 23:34:49 +0800

Simplify __devm_release_region() implementation by dedicated API
devres_release() which have below advantages than current
__release_region() + devres_destroy():

It is simpler if __devm_release_region() is undoing what
__devm_request_region() did, otherwise, it can avoid wrong and undesired
__release_region().

Link: https://lkml.kernel.org/r/20241017-release_region_fix-v1-1-84a3e8441284@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/resource.c~kernel-resource-simplify-api-__devm_release_region-implementation
+++ a/kernel/resource.c
@@ -1683,8 +1683,7 @@ void __devm_release_region(struct device
 {
 	struct region_devres match_data = { parent, start, n };
 
-	__release_region(parent, start, n);
-	WARN_ON(devres_destroy(dev, devm_region_release, devm_region_match,
+	WARN_ON(devres_release(dev, devm_region_release, devm_region_match,
 			       &match_data));
 }
 EXPORT_SYMBOL(__devm_release_region);
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are


