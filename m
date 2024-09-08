Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF9522638
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 03:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725766037; cv=none; b=Npjp/FeaM6JJ79JerxlTGAyjQFw5teZuxLPXp4+fVH6jcnF8SRg9a+eehm8Yx1PLdKSNN5VaNIbnyN1fbrjV2F632TbD+L/HCUZDDRat40zBeB3+TyKVxIx4rLFBtZk5vePbW2yZsIiHbqH59ZSxjf8DIw3OquPcFelUjYvKlJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725766037; c=relaxed/simple;
	bh=VH20XrO76zBsTq933kkfNCm5aqRt9ztGtkTxyVEFGSg=;
	h=Date:To:From:Subject:Message-Id; b=PT5Y+oOrqUEayIGNfBBrF5chLxP/6EP5sBa6Epz8/c6mH9IS31bgeZDOwkt6ng8nkm4wnUmTlGxd3mTudzSzzuA8+kVRf5y490i5GdsT3EzdFrXlVAKYV5qM9zgzUD849k47h25hWSq9yGKrtTbBNFKtNw/FJ+X6k8BV1Yzewmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfDejp+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfDejp+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3068C4CEC8;
	Sun,  8 Sep 2024 03:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725766036;
	bh=VH20XrO76zBsTq933kkfNCm5aqRt9ztGtkTxyVEFGSg=;
	h=Date:To:From:Subject:From;
	b=SfDejp+KqJ+b2+3ebit+xcKJ7hkBUxG1Ab/y5jElCf+H4c52CKuxamhEhvSIdQV3z
	 BmDpCMsaLsNPurF5XVAuB0xc9DXaPLbro/k09A155rq63KgF5cayAX48UlAkyEYHHD
	 0oq6N3a2okwhXdlCHeLssVUuKX+vyxF7rUvgzDbc=
Date: Sat, 07 Sep 2024 20:27:16 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,ira.weiny@intel.com,david@redhat.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-region_intersects-vs-add_memory_driver_managed.patch added to mm-unstable branch
Message-Id: <20240908032716.B3068C4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: fix region_intersects() vs add_memory_driver_managed()
has been added to the -mm mm-unstable branch.  Its filename is
     resource-fix-region_intersects-vs-add_memory_driver_managed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-region_intersects-vs-add_memory_driver_managed.patch

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
Subject: resource: fix region_intersects() vs add_memory_driver_managed()
Date: Fri, 6 Sep 2024 11:07:11 +0800

On a system with CXL memory, the resource tree (/proc/iomem) related to
CXL memory may look like something as follows.

490000000-50fffffff : CXL Window 0
  490000000-50fffffff : region0
    490000000-50fffffff : dax0.0
      490000000-50fffffff : System RAM (kmem)

Because drivers/dax/kmem.c calls add_memory_driver_managed() during
onlining CXL memory, which makes "System RAM (kmem)" a descendant of "CXL
Window X".  This confuses region_intersects(), which expects all "System
RAM" resources to be at the top level of iomem_resource.  This can lead to
bugs.

For example, when the following command line is executed to write some
memory in CXL memory range via /dev/mem,

 $ dd if=data of=/dev/mem bs=$((1 << 10)) seek=$((0x490000000 >> 10)) count=1
 dd: error writing '/dev/mem': Bad address
 1+0 records in
 0+0 records out
 0 bytes copied, 0.0283507 s, 0.0 kB/s

the command fails as expected.  However, the error code is wrong.  It
should be "Operation not permitted" instead of "Bad address".  More
seriously, the /dev/mem permission checking in devmem_is_allowed() passes
incorrectly.  Although the accessing is prevented later because ioremap()
isn't allowed to map system RAM, it is a potential security issue.  During
command executing, the following warning is reported in the kernel log for
calling ioremap() on system RAM.

 ioremap on RAM at 0x0000000490000000 - 0x0000000490000fff
 WARNING: CPU: 2 PID: 416 at arch/x86/mm/ioremap.c:216 __ioremap_caller.constprop.0+0x131/0x35d
 Call Trace:
  memremap+0xcb/0x184
  xlate_dev_mem_ptr+0x25/0x2f
  write_mem+0x94/0xfb
  vfs_write+0x128/0x26d
  ksys_write+0xac/0xfe
  do_syscall_64+0x9a/0xfd
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

The details of command execution process are as follows.  In the above
resource tree, "System RAM" is a descendant of "CXL Window 0" instead of a
top level resource.  So, region_intersects() will report no System RAM
resources in the CXL memory region incorrectly, because it only checks the
top level resources.  Consequently, devmem_is_allowed() will return 1
(allow access via /dev/mem) for CXL memory region incorrectly. 
Fortunately, ioremap() doesn't allow to map System RAM and reject the
access.

So, region_intersects() needs to be fixed to work correctly with the
resource tree with "System RAM" not at top level as above.  To fix it, if
we found a unmatched resource in the top level, we will continue to search
matched resources in its descendant resources.  So, we will not miss any
matched resources in resource tree anymore.

In the new implementation, an example resource tree

|------------- "CXL Window 0" ------------|
|-- "System RAM" --|

will behave similar as the following fake resource tree for
region_intersects(, IORESOURCE_SYSTEM_RAM, ),

|-- "System RAM" --||-- "CXL Window 0a" --|

Where "CXL Window 0a" is part of the original "CXL Window 0" that
isn't covered by "System RAM".

Link: https://lkml.kernel.org/r/20240906030713.204292-2-ying.huang@intel.com
Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
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

 kernel/resource.c |   58 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

--- a/kernel/resource.c~resource-fix-region_intersects-vs-add_memory_driver_managed
+++ a/kernel/resource.c
@@ -539,20 +539,62 @@ static int __region_intersects(struct re
 			       size_t size, unsigned long flags,
 			       unsigned long desc)
 {
-	struct resource res;
+	resource_size_t ostart, oend;
 	int type = 0; int other = 0;
-	struct resource *p;
+	struct resource *p, *dp;
+	bool is_type, covered;
+	struct resource res;
 
 	res.start = start;
 	res.end = start + size - 1;
 
 	for (p = parent->child; p ; p = p->sibling) {
-		bool is_type = (((p->flags & flags) == flags) &&
-				((desc == IORES_DESC_NONE) ||
-				 (desc == p->desc)));
-
-		if (resource_overlaps(p, &res))
-			is_type ? type++ : other++;
+		if (!resource_overlaps(p, &res))
+			continue;
+		is_type = (p->flags & flags) == flags &&
+			(desc == IORES_DESC_NONE || desc == p->desc);
+		if (is_type) {
+			type++;
+			continue;
+		}
+		/*
+		 * Continue to search in descendant resources as if the
+		 * matched descendant resources cover some ranges of 'p'.
+		 *
+		 * |------------- "CXL Window 0" ------------|
+		 * |-- "System RAM" --|
+		 *
+		 * will behave similar as the following fake resource
+		 * tree when searching "System RAM".
+		 *
+		 * |-- "System RAM" --||-- "CXL Window 0a" --|
+		 */
+		covered = false;
+		ostart = max(res.start, p->start);
+		oend = min(res.end, p->end);
+		for_each_resource(p, dp, false) {
+			if (!resource_overlaps(dp, &res))
+				continue;
+			is_type = (dp->flags & flags) == flags &&
+				(desc == IORES_DESC_NONE || desc == dp->desc);
+			if (is_type) {
+				type++;
+				/*
+				 * Range from 'ostart' to 'dp->start'
+				 * isn't covered by matched resource.
+				 */
+				if (dp->start > ostart)
+					break;
+				if (dp->end >= oend) {
+					covered = true;
+					break;
+				}
+				/* Remove covered range */
+				ostart = max(ostart, dp->end + 1);
+			}
+		}
+		if (!covered)
+			other++;
 	}
 
 	if (type == 0)
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-fix-region_intersects-vs-add_memory_driver_managed.patch
resource-make-alloc_free_mem_region-works-for-iomem_resource.patch
resource-kunit-add-test-case-for-region_intersects.patch

