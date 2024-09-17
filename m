Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07B9152E0C
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560528; cv=none; b=pVmTmaZCLKJgNbqGqq3AiRi/fXpUtnjZUy21weuUrrclUiu6zYk2NjZjl3Mp/qNyguQPYtfxVJEiWdhN4gZkg1t1RylrWcl07YP/DFoJ140LlAa4j+9MrUftqkaVtWEUAOZ9xutH19SHSmHOsk1T0P8txbiTVXznfdjn9ZBX7Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560528; c=relaxed/simple;
	bh=G8wvP4AL6kM36HYs1JK8GXHmFKYSvcUuE59rH8kUhM4=;
	h=Date:To:From:Subject:Message-Id; b=Pdu8U9DsPFwQDLuRMidsGNk7rnVVOOsgtpYBox2GYSYNazKaoPC+z1S4v+6UaQSNRbuQ3kl/OK82WEQuz04OTNDWxEWB+FVgw9GD2qWiRPV+DQPOhclRjiW7vqAHGk6lXzpKl9uTcRBYjeOPoVNtBIRYrgFv1UObH0uqU4aJf08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjpWd7Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjpWd7Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23059C4CECE;
	Tue, 17 Sep 2024 08:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560528;
	bh=G8wvP4AL6kM36HYs1JK8GXHmFKYSvcUuE59rH8kUhM4=;
	h=Date:To:From:Subject:From;
	b=WjpWd7KvUX9VyJZ+usi1f9gK6GxR8rmuFPkApTyJi5GjtdbQ+vSezvkwR/ef/JrTE
	 D47wzGwWDsKVCAAbDu4O0BrqsX6uoL4lRVp5rAEKnxDXiFJX1Ryh4q7KntwojbHCzJ
	 Ge5hE/lHIvcnDEDhAN48qgDR+BU2ZCJozBomcmUM=
Date: Tue, 17 Sep 2024 01:08:45 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,ira.weiny@intel.com,david@redhat.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] resource-make-alloc_free_mem_region-works-for-iomem_resource.patch removed from -mm tree
Message-Id: <20240917080848.23059C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: make alloc_free_mem_region() works for iomem_resource
has been removed from the -mm tree.  Its filename was
     resource-make-alloc_free_mem_region-works-for-iomem_resource.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1830,7 +1830,7 @@ static resource_size_t gfr_start(struct
 		return end - size + 1;
 	}
 
-	return ALIGN(base->start, align);
+	return ALIGN(max(base->start, align), align);
 }
 
 static bool gfr_continue(struct resource *base, resource_size_t addr,
_

Patches currently in -mm which might be from ying.huang@intel.com are


