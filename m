Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB422E3365
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218421; cv=none; b=nw2m/rhbHD6n773ShjvMAA476mS5X94HjdxOIKWYcNAMjM4YvyBRhbkJPgTog1m6sNzMBa5ursXtlgBPawtxCaot9DCoui8t8wG63OD1NouCX+Sb/vANhMvNJMUZEY2977p4exvE6QNRMHsOXGOxpF/fyg7U4x+u6pBLbWdyLD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218421; c=relaxed/simple;
	bh=vc1hY+k2Dio+NDuniYaBdhqv5lALOVtR2bUqTejmh98=;
	h=Date:To:From:Subject:Message-Id; b=eF74bS+7rkVy8geBkI2p/FDX7N37R9SXiYvVA82mztImp5nlYK81svmXTjNdNRtUTCiGJrQRPRAorfV66AIUB0uTztTHQ1pL1mtTe9U/WG4r6k7lQtS2KvsU/m4xTkDQAEPCgMmeTl14cVTCm0nFBF/LTxPMUr4rxUNxhwpL+i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s/rDUDA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s/rDUDA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32BBC4CED1;
	Wed,  5 Mar 2025 23:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741218421;
	bh=vc1hY+k2Dio+NDuniYaBdhqv5lALOVtR2bUqTejmh98=;
	h=Date:To:From:Subject:From;
	b=s/rDUDA/XJ8VANPLsnN8sRzvyvTtTNJXsTJSXn7/S9uDpGqzuOALBIPNKcVh+Qo68
	 nWfca7adaZ8UaBRan9omaRZDrFo7v2lbClA77c6GucfeETBc2ZqFGzCmFKPOJDtS/1
	 XCQuW6JGFpZp7DGIRxybySHVjK1Z7VCahv7/hweg=
Date: Wed, 05 Mar 2025 15:47:00 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,ilpo.jarvinen@linux.intel.com,huang.ying.caritas@gmail.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,dan.j.williams@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-resource-leak-in-get_free_mem_region.patch added to mm-nonmm-unstable branch
Message-Id: <20250305234700.F32BBC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: fix resource leak in get_free_mem_region()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-fix-resource-leak-in-get_free_mem_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-resource-leak-in-get_free_mem_region.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: resource: fix resource leak in get_free_mem_region()
Date: Tue, 04 Mar 2025 18:22:53 -0800

Li reports a kmemleak detection in get_free_mem_region() error unwind
path:

  cxl region2: HPA allocation error (-34) for size:0x0000000100000000 in CXL Window 0 [mem 0xa90000000-0x1a8fffffff flags 0x200]
  kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

     __kmalloc_cache_noprof+0x28c/0x350
     get_free_mem_region+0x45/0x380
     alloc_free_mem_region+0x1d/0x30
     size_store+0x180/0x290 [cxl_core]
     kernfs_fop_write_iter+0x13f/0x1e0
     vfs_write+0x37c/0x540
     ksys_write+0x68/0xe0
     do_syscall_64+0x6e/0x190
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

It turns out it not only leaks memory, also fails to unwind changes to the
resource tree (@base, usually iomem_resource).

Fix this by consolidating the devres and devm paths into just devres, and
move those details to a wrapper function.  So now __get_free_mem_region()
only needs to worry about alloc_resource() unwinding, and the devres
failure path is resolved before touching the resource tree.

Link: https://lkml.kernel.org/r/174114125011.1367354.2670882864492961789.stgit@dwillia2-xfh.jf.intel.com
Fixes: 14b80582c43e ("resource: Introduce alloc_free_mem_region()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Closes: http://lore.kernel.org/20250304043415.610286-1-lizhijian@fujitsu.com
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mika Westeberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |  105 +++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 45 deletions(-)

--- a/kernel/resource.c~resource-fix-resource-leak-in-get_free_mem_region
+++ a/kernel/resource.c
@@ -172,6 +172,8 @@ static void free_resource(struct resourc
 		kfree(res);
 }
 
+DEFINE_FREE(free_resource, struct resource *, if (_T) free_resource(_T))
+
 static struct resource *alloc_resource(gfp_t flags)
 {
 	return kzalloc(sizeof(struct resource), flags);
@@ -1631,17 +1633,29 @@ void devm_release_resource(struct device
 }
 EXPORT_SYMBOL(devm_release_resource);
 
+/*
+ * The GFR_REQUEST_REGION case performs a request_region() to be paired
+ * with release_region(). The alloc_free_mem_region() path performs
+ * insert_resource() to be paired with {remove,free}_resource(). The
+ * @res member differentiates the 2 cases.
+ */
 struct region_devres {
 	struct resource *parent;
 	resource_size_t start;
 	resource_size_t n;
+	struct resource *res;
 };
 
 static void devm_region_release(struct device *dev, void *res)
 {
 	struct region_devres *this = res;
 
-	__release_region(this->parent, this->start, this->n);
+	if (!this->res) {
+		__release_region(this->parent, this->start, this->n);
+	} else {
+		remove_resource(this->res);
+		free_resource(this->res);
+	}
 }
 
 static int devm_region_match(struct device *dev, void *res, void *match_data)
@@ -1908,43 +1922,19 @@ static resource_size_t gfr_next(resource
 	return addr + size;
 }
 
-static void remove_free_mem_region(void *_res)
-{
-	struct resource *res = _res;
-
-	if (res->parent)
-		remove_resource(res);
-	free_resource(res);
-}
-
 static struct resource *
-get_free_mem_region(struct device *dev, struct resource *base,
-		    resource_size_t size, const unsigned long align,
-		    const char *name, const unsigned long desc,
-		    const unsigned long flags)
+__get_free_mem_region(struct resource *base, resource_size_t size,
+		      const unsigned long align, const char *name,
+		      const unsigned long desc, const unsigned long flags)
 {
 	resource_size_t addr;
-	struct resource *res;
-	struct region_devres *dr = NULL;
 
 	size = ALIGN(size, align);
 
-	res = alloc_resource(GFP_KERNEL);
+	struct resource *res __free(free_resource) = alloc_resource(GFP_KERNEL);
 	if (!res)
 		return ERR_PTR(-ENOMEM);
 
-	if (dev && (flags & GFR_REQUEST_REGION)) {
-		dr = devres_alloc(devm_region_release,
-				sizeof(struct region_devres), GFP_KERNEL);
-		if (!dr) {
-			free_resource(res);
-			return ERR_PTR(-ENOMEM);
-		}
-	} else if (dev) {
-		if (devm_add_action_or_reset(dev, remove_free_mem_region, res))
-			return ERR_PTR(-ENOMEM);
-	}
-
 	write_lock(&resource_lock);
 	for (addr = gfr_start(base, size, align, flags);
 	     gfr_continue(base, addr, align, flags);
@@ -1958,17 +1948,9 @@ get_free_mem_region(struct device *dev,
 						    size, name, 0))
 				break;
 
-			if (dev) {
-				dr->parent = &iomem_resource;
-				dr->start = addr;
-				dr->n = size;
-				devres_add(dev, dr);
-			}
-
 			res->desc = desc;
 			write_unlock(&resource_lock);
 
-
 			/*
 			 * A driver is claiming this region so revoke any
 			 * mappings.
@@ -1985,25 +1967,58 @@ get_free_mem_region(struct device *dev,
 			 * Only succeed if the resource hosts an exclusive
 			 * range after the insert
 			 */
-			if (__insert_resource(base, res) || res->child)
+			if (__insert_resource(base, res))
+				break;
+			if (res->child) {
+				remove_resource(res);
 				break;
+			}
 
 			write_unlock(&resource_lock);
 		}
 
-		return res;
+		return no_free_ptr(res);
 	}
 	write_unlock(&resource_lock);
 
-	if (flags & GFR_REQUEST_REGION) {
-		free_resource(res);
-		devres_free(dr);
-	} else if (dev)
-		devm_release_action(dev, remove_free_mem_region, res);
-
 	return ERR_PTR(-ERANGE);
 }
 
+static struct resource *
+get_free_mem_region(struct device *dev, struct resource *base,
+		    resource_size_t size, const unsigned long align,
+		    const char *name, const unsigned long desc,
+		    const unsigned long flags)
+{
+
+	struct region_devres *dr __free(kfree) = NULL;
+	struct resource *res;
+
+	if (dev) {
+		dr = devres_alloc(devm_region_release,
+				  sizeof(struct region_devres), GFP_KERNEL);
+		if (!dr)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	res = __get_free_mem_region(base, size, align, name, desc, flags);
+
+	if (IS_ERR(res) || !dr)
+		return res;
+
+	dr->parent = base;
+	dr->start = res->start;
+	dr->n = resource_size(res);
+
+	/* See 'struct region_devres' definition for details */
+	if ((flags & GFR_REQUEST_REGION) == 0)
+		dr->res = res;
+
+	devres_add(dev, no_free_ptr(dr));
+
+	return res;
+}
+
 /**
  * devm_request_free_mem_region - find free region for device private memory
  *
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dcssblk-mark-dax-broken-remove-fs_dax_limited-support.patch
resource-fix-resource-leak-in-get_free_mem_region.patch

