Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BB122638
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 03:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725766039; cv=none; b=JbzT1461AxjQm2Ll4dJXSWdA0QkvR54KDuxI+F7fmYZDirU9oVHwwdtmUJfB2Yb6MzkjOsgrEgABuFVCX5I/LgZDgrrtMn1EDJU/zrNhLoAYBXxboPVdsZXf3mvrBuKAIxNh+p36BMAuhq5JQYMKOk+pjqjH/PbOUqj9R9Kfe4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725766039; c=relaxed/simple;
	bh=Z+0LfI1BXKHmnNVlBRWMDAnV1RNcXbe6APge4pxQFVY=;
	h=Date:To:From:Subject:Message-Id; b=S6eL5HYBek3vjV+qaJG94GLdpwFYlQiUeyqimbinH57qbsNfoT738AcJPs7c5smlN7+k5AD6ooDbaIl7ufX+oCc0E75/yCUDDWhMK9g8KYBt8DM+11vAnT6ec3P3Z8Qa0wOrd6d1TJ2MQ6ZW/30kWFa3K5rnvzYy24/zRgX7D0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ArwyLGQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ArwyLGQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E2EC4CEC4;
	Sun,  8 Sep 2024 03:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725766038;
	bh=Z+0LfI1BXKHmnNVlBRWMDAnV1RNcXbe6APge4pxQFVY=;
	h=Date:To:From:Subject:From;
	b=ArwyLGQ8IWZeYOnqf9NkXxRF6NZhpqLt5SjKG+q2r/haTUByXdyBS3wU+itBpcUcC
	 JadWqzEHNokRwTI9rHHfyAXbQ8Dc9o9I8CvErP2gNzCuWvtAYp1LhaIRNIcUAvacDm
	 htQphegS+8mprQFCcgMDdnzR3zMUE2Y4p04YO5RQ=
Date: Sat, 07 Sep 2024 20:27:18 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,ira.weiny@intel.com,david@redhat.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-make-alloc_free_mem_region-works-for-iomem_resource.patch added to mm-unstable branch
Message-Id: <20240908032718.C4E2EC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: make alloc_free_mem_region() works for iomem_resource
has been added to the -mm mm-unstable branch.  Its filename is
     resource-make-alloc_free_mem_region-works-for-iomem_resource.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-make-alloc_free_mem_region-works-for-iomem_resource.patch

This patch will later appear in the mm-unstable branch at
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
From: Huang Ying <ying.huang@intel.com>
Subject: resource: make alloc_free_mem_region() works for iomem_resource
Date: Fri, 6 Sep 2024 11:07:12 +0800

During developing a kunit test case for region_intersects(), some fake
resources need to be inserted into iomem_resource.  To do that, a resource
hole needs to be found first in iomem_resource.

However, alloc_free_mem_region() cannot work for iomem_resource now. 
Because the start address to check cannot be 0 to detect address wrapping
0 in gfr_continue(), while iomem_resource.start == 0.  To make
alloc_free_mem_region() works for iomem_resource, gfr_start() is changed
to avoid to return 0 even if base->start == 0.  We don't need to check 0
as start address.

Link: https://lkml.kernel.org/r/20240906030713.204292-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-make-alloc_free_mem_region-works-for-iomem_resource
+++ a/kernel/resource.c
@@ -1872,7 +1872,7 @@ static resource_size_t gfr_start(struct
 		return end - size + 1;
 	}
 
-	return ALIGN(base->start, align);
+	return ALIGN(max(base->start, align), align);
 }
 
 static bool gfr_continue(struct resource *base, resource_size_t addr,
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-fix-region_intersects-vs-add_memory_driver_managed.patch
resource-make-alloc_free_mem_region-works-for-iomem_resource.patch
resource-kunit-add-test-case-for-region_intersects.patch

