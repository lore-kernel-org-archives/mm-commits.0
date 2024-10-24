Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294D1662E8
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750524; cv=none; b=WXialxHe07Rpy9WpFL78HUzqDrW9fMqvCbLafzc1DFLMOEBla1kidtVnegClCN+7wrByt0tK+gnkMDdKPeMpC7KjP5nBxn6V9Eu2+JAjPMdcMAWtC4k/mf4u8zL4mNS4S8OgHRF7ZVMR8c0RMFwtjYkVwacAwhQKK53xTr7gntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750524; c=relaxed/simple;
	bh=NMrcGEPxI+c6LcVmTKIavZazg6hwR6SsqZsa2FsVw3M=;
	h=Date:To:From:Subject:Message-Id; b=tfNCJ6yrLAPJRXcgJsfYvfs517MCLIiwQYaGatXZ2V5tD7IWAUYYIu/zR2ubOfEjQA/B/4+M2BHvZvXdOyGRkQQA74maUn7s99nDuZhOEMLQ3f7/dHbYuDnDlFGLLR4SZ3m5p9H9InNjXkXhas9uc84DfHqJ8vNg/uDGTtgN9xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfWNAolM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfWNAolM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D3BC4CECC;
	Thu, 24 Oct 2024 06:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750523;
	bh=NMrcGEPxI+c6LcVmTKIavZazg6hwR6SsqZsa2FsVw3M=;
	h=Date:To:From:Subject:From;
	b=MfWNAolMM5jyAwHJGhvCppi/4ZskiDWewy9zArnrJdmVxoCR4xw1C88vbrtFmmG8r
	 2QOOraZV9U+EWcxcgjp2VWRSkkJlsLnT3qp44Xeb7gMA0gycPMZyNjau6l/DqUjYrP
	 rdvOoAq4fhRbgojS9FSBTW0HShAMXw8fh7F0XYfo=
Date: Wed, 23 Oct 2024 23:15:23 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,linux@roeck-us.net,jonathan.cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,arnd@arndb.de,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] resource-remove-dependency-on-sparsemem-from-get_free_region.patch removed from -mm tree
Message-Id: <20241024061523.C1D3BC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: remove dependency on SPARSEMEM from GET_FREE_REGION
has been removed from the -mm tree.  Its filename was
     resource-remove-dependency-on-sparsemem-from-get_free_region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: resource: remove dependency on SPARSEMEM from GET_FREE_REGION
Date: Tue, 15 Oct 2024 13:15:54 +0800

We want to use the functions (get_free_mem_region()) configured via
GET_FREE_REGION in resource kunit tests.  However, GET_FREE_REGION
depends on SPARSEMEM now.  This makes resource kunit tests cannot be
built on some architectures lacking SPARSEMEM, or causes config warning
as follows,

  WARNING: unmet direct dependencies detected for GET_FREE_REGION
  Depends on [n]: SPARSEMEM [=n]
  Selected by [y]:
  - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]

When get_free_mem_region() was introduced the only consumers were those
looking to pass the address range to memremap_pages().  That address
range needed to be mindful of the maximum addressable platform physical
address which at the time only SPARSMEM defined via MAX_PHYSMEM_BITS.

Given that memremap_pages() also depended on SPARSEMEM via ZONE_DEVICE,
it was easier to just depend on that definition than invent a general
MAX_PHYSMEM_BITS concept outside of SPARSEMEM.

Turns out that decision was buggy and did not account for KASAN
consumption of physical address space.  That problem was resolved
recently with commit ea72ce5da228 ("x86/kaslr: Expose and use the end
of the physical memory address space"), and GET_FREE_REGION dropped its
MAX_PHYSMEM_BITS dependency.

Then commit 99185c10d5d9 ("resource, kunit: add test case for
region_intersects()"), went ahead and fixed up the only remaining
dependency on SPARSEMEM which was usage of the PA_SECTION_SHIFT macro
for setting the default alignment.  A PAGE_SIZE fallback is fine in the
SPARSEMEM=n case.

With those build dependencies gone GET_FREE_REGION no longer depends on
SPARSEMEM.  So, the patch removes dependency on SPARSEMEM from
GET_FREE_REGION to fix the build issues.

Link: https://lkml.kernel.org/r/20241016014730.339369-1-ying.huang@intel.com
Link: https://lore.kernel.org/lkml/20240922225041.603186-1-linux@roeck-us.net/
Link: https://lkml.kernel.org/r/20241015051554.294734-1-ying.huang@intel.com
Fixes: 99185c10d5d9 ("resource, kunit: add test case for region_intersects()")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~resource-remove-dependency-on-sparsemem-from-get_free_region
+++ a/mm/Kconfig
@@ -1085,7 +1085,6 @@ config HMM_MIRROR
 	depends on MMU
 
 config GET_FREE_REGION
-	depends on SPARSEMEM
 	bool
 
 config DEVICE_PRIVATE
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch

