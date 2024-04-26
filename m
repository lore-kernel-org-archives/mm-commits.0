Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1690A8175E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104475; cv=none; b=T55Kll7cRF+B3qP9JOZJJHt7IbLdZDdyeLM80qnpwSO8LDSgXQjt2Lf2UPonEeS95V8enk6RmeBa1hl8Z+0YW5WFk5esptNryELAb3pvWZPjbhgVjt04/3RSCJZSUYqacKzOuipYUAGx5kOqY/5X3oQmSoZtUD75i92ItMP3glk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104475; c=relaxed/simple;
	bh=++aKrWij7eBaACRtOQaLiGJbeBA5OwgEUqj6c0gnZHM=;
	h=Date:To:From:Subject:Message-Id; b=Qk/x9cIiZpjKABY3yczj1NXrgyShV56AWDWKbdWaMI/7t+pp0maTbc9Mhy41P1rAlI40jI7DL549hirA9nKsetpYoFdX3075YUYm5BG6gRWJ0KMcefUB/CyPP8WNL/froIIQ9B5bg3a2/UaM//qMZo2X1GzFGqHPai6i8YmhaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1UYCDNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1UYCDNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCD3C113CD;
	Fri, 26 Apr 2024 04:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104475;
	bh=++aKrWij7eBaACRtOQaLiGJbeBA5OwgEUqj6c0gnZHM=;
	h=Date:To:From:Subject:From;
	b=J1UYCDNLNSkb+DJHS/FIFUSMNiUBF2bmiCyeKgbXyMllG/vOeSVZ75k6ejpMd4q0A
	 PKRbP0nuqo95Qo5GpzrVvT/qp+k+8NdAXN5JCkch5VBiPof0KT6G05qwEwfFeAp41k
	 HhPt4xPxlZ9Et/jUY0P+JNhqrb/6rDSyjwBzG4T4=
Date: Thu, 25 Apr 2024 21:07:54 -0700
To: mm-commits@vger.kernel.org,pstanner@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] devres-switch-to-use-dev_err_probe-for-unification.patch removed from -mm tree
Message-Id: <20240426040754.DBCD3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: devres: switch to use dev_err_probe() for unification
has been removed from the -mm tree.  Its filename was
     devres-switch-to-use-dev_err_probe-for-unification.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: devres: switch to use dev_err_probe() for unification
Date: Wed, 3 Apr 2024 13:46:56 +0300

Patch series "devres: A couple of cleanups".

A couple of ad-hoc cleanups. No functional changes intended. 


This patch (of 2):

The devm_*() APIs are supposed to be called during the ->probe() stage. 
Many drivers (especially new ones) have switched to use dev_err_probe()
for error messaging for the sake of unification.  Let's do the same in the
devres APIs.

Link: https://lkml.kernel.org/r/20240403104820.557487-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20240403104820.557487-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/lib/devres.c~devres-switch-to-use-dev_err_probe-for-unification
+++ a/lib/devres.c
@@ -125,12 +125,13 @@ __devm_ioremap_resource(struct device *d
 	resource_size_t size;
 	void __iomem *dest_ptr;
 	char *pretty_name;
+	int ret;
 
 	BUG_ON(!dev);
 
 	if (!res || resource_type(res) != IORESOURCE_MEM) {
-		dev_err(dev, "invalid resource %pR\n", res);
-		return IOMEM_ERR_PTR(-EINVAL);
+		ret = dev_err_probe(dev, -EINVAL, "invalid resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	if (type == DEVM_IOREMAP && res->flags & IORESOURCE_MEM_NONPOSTED)
@@ -144,20 +145,20 @@ __devm_ioremap_resource(struct device *d
 	else
 		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
 	if (!pretty_name) {
-		dev_err(dev, "can't generate pretty name for resource %pR\n", res);
-		return IOMEM_ERR_PTR(-ENOMEM);
+		ret = dev_err_probe(dev, -ENOMEM, "can't generate pretty name for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
-		dev_err(dev, "can't request region for resource %pR\n", res);
-		return IOMEM_ERR_PTR(-EBUSY);
+		ret = dev_err_probe(dev, -EBUSY, "can't request region for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	dest_ptr = __devm_ioremap(dev, res->start, size, type);
 	if (!dest_ptr) {
-		dev_err(dev, "ioremap failed for resource %pR\n", res);
 		devm_release_mem_region(dev, res->start, size);
-		dest_ptr = IOMEM_ERR_PTR(-ENOMEM);
+		ret = dev_err_probe(dev, -ENOMEM, "ioremap failed for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	return dest_ptr;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

