Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0347C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A6621741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087132;
	bh=Lfd3k5k/Sx5fNU/dDjIKcgtz6vIQ/z7tmVctqVlki5A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NFfW7KAHpKWFw9uOJ8uEYMHVWWXEvSIdn4O58yOVWui/8nACkXsWJA5avpN68TNyn
	 jLsNUAh6ACP8eyrMbI1BnvYZcBktuH10KkChxq2/XJjKOV+HxKp3bu0xK2oGiCFc/N
	 W2dujKZ12jm6i1RL+3TQQasd2n3GDFmSgXbnN+L0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgIZCZc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbgIZCZc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:32 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E4C20BED;
        Sat, 26 Sep 2020 02:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087129;
        bh=Lfd3k5k/Sx5fNU/dDjIKcgtz6vIQ/z7tmVctqVlki5A=;
        h=Date:From:To:Subject:From;
        b=ejwwVJzMVqRBdzTlRn2sVEnxLmVeiR3s4DtU4OiDScQcTpwRR6K9o4kS/CM8gm097
         mvD31JUUAq5nGfjriyPU+qyzBvC8yCqC+CA4nhfs4D1RJpvBE6fbCHw1kNRieFURQ8
         xDl5Au26WBreUP1NLu59PfgUzwbmLrC1DsZBYKh0=
Date:   Fri, 25 Sep 2020 19:25:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanaijie@huawei.com, will@kernel.org,
        vishal.l.verma@intel.com, vgoyal@redhat.com,
        thomas.lendacky@amd.com, tglx@linutronix.de,
        sstabellini@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@linux.alibaba.com, rdunlap@infradead.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        paulus@ozlabs.org, pasha.tatashin@soleen.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, lkp@intel.com,
        justin.he@arm.com, Jonathan.Cameron@huawei.com,
        joao.m.martins@oracle.com, jmoyer@redhat.com, jgross@suse.com,
        jglisse@redhat.com, jgg@mellanox.com, ira.weiny@intel.com,
        hulkci@huawei.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, daniel@ffwll.ch,
        catalin.marinas@arm.com, bskeggs@redhat.com, Brice.Goglin@inria.fr,
        bp@alien8.de, boris.ostrovsky@oracle.com, bhelgaas@google.com,
        benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        dan.j.williams@intel.com
Subject:  + device-dax-add-dis-contiguous-resource-support.patch
 added to -mm tree
Message-ID: <20200926022526.2Q0nl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add dis-contiguous resource support
has been added to the -mm tree.  Its filename is
     device-dax-add-dis-contiguous-resource-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-dis-contiguous=
-resource-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-dis-contiguous=
-resource-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: add dis-contiguous resource support

Break the requirement that device-dax instances are physically contiguous.
With this constraint removed it allows fragmented available capacity to
be fully allocated.

This capability is useful to mitigate the "noisy neighbor" problem with
memory-side-cache management for virtual machines, or any other scenario
where a platform address boundary also designates a performance boundary.=
=20
For example a direct mapped memory side cache might rotate cache colors at
1GB boundaries.  With dis-contiguous allocations a device-dax instance
could be configured to contain only 1 cache color.

It also satisfies Joao's use case (see link) for partitioning memory for
exclusive guest access.  It allows for a future potential mode where the
host kernel need not allocate 'struct page' capacity up-front.

Link: https://lore.kernel.org/lkml/20200110190313.17144-1-joao.m.martins@or=
acle.com/
Link: https://lkml.kernel.org/r/159643104304.4062302.16561669534797528660.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106116875.30709.11456649969327399771.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c              |  231 +++++++++++++++++++++++--------
 drivers/dax/dax-private.h      |    9 -
 drivers/dax/device.c           |   53 ++++---
 drivers/dax/kmem.c             |  130 +++++++++++------
 tools/testing/nvdimm/dax-dev.c |   20 +-
 5 files changed, 321 insertions(+), 122 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-dis-contiguous-resource-support
+++ a/drivers/dax/bus.c
@@ -136,15 +136,27 @@ static bool is_static(struct dax_region
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) !=3D 0;
 }
=20
+static u64 dev_dax_size(struct dev_dax *dev_dax)
+{
+	u64 size =3D 0;
+	int i;
+
+	device_lock_assert(&dev_dax->dev);
+
+	for (i =3D 0; i < dev_dax->nr_range; i++)
+		size +=3D range_len(&dev_dax->ranges[i].range);
+
+	return size;
+}
+
 static int dax_bus_probe(struct device *dev)
 {
 	struct dax_device_driver *dax_drv =3D to_dax_drv(dev->driver);
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct dax_region *dax_region =3D dev_dax->region;
-	struct range *range =3D &dev_dax->range;
 	int rc;
=20
-	if (range_len(range) =3D=3D 0 || dev_dax->id < 0)
+	if (dev_dax_size(dev_dax) =3D=3D 0 || dev_dax->id < 0)
 		return -ENXIO;
=20
 	rc =3D dax_drv->probe(dev_dax);
@@ -354,15 +366,19 @@ void kill_dev_dax(struct dev_dax *dev_da
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
=20
-static void free_dev_dax_range(struct dev_dax *dev_dax)
+static void free_dev_dax_ranges(struct dev_dax *dev_dax)
 {
 	struct dax_region *dax_region =3D dev_dax->region;
-	struct range *range =3D &dev_dax->range;
+	int i;
=20
 	device_lock_assert(dax_region->dev);
-	if (range_len(range))
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct range *range =3D &dev_dax->ranges[i].range;
+
 		__release_region(&dax_region->res, range->start,
 				range_len(range));
+	}
+	dev_dax->nr_range =3D 0;
 }
=20
 static void unregister_dev_dax(void *dev)
@@ -372,7 +388,7 @@ static void unregister_dev_dax(void *dev
 	dev_dbg(dev, "%s\n", __func__);
=20
 	kill_dev_dax(dev_dax);
-	free_dev_dax_range(dev_dax);
+	free_dev_dax_ranges(dev_dax);
 	device_del(dev);
 	put_device(dev);
 }
@@ -423,7 +439,7 @@ static ssize_t delete_store(struct devic
 	device_lock(dev);
 	device_lock(victim);
 	dev_dax =3D to_dev_dax(victim);
-	if (victim->driver || range_len(&dev_dax->range))
+	if (victim->driver || dev_dax_size(dev_dax))
 		rc =3D -EBUSY;
 	else {
 		/*
@@ -569,51 +585,86 @@ static int alloc_dev_dax_range(struct de
 	struct dax_region *dax_region =3D dev_dax->region;
 	struct resource *res =3D &dax_region->res;
 	struct device *dev =3D &dev_dax->dev;
+	struct dev_dax_range *ranges;
+	unsigned long pgoff =3D 0;
 	struct resource *alloc;
+	int i;
=20
 	device_lock_assert(dax_region->dev);
=20
 	/* handle the seed alloc special case */
 	if (!size) {
-		dev_dax->range =3D (struct range) {
-			.start =3D res->start,
-			.end =3D res->start - 1,
-		};
+		if (dev_WARN_ONCE(dev, dev_dax->nr_range,
+					"0-size allocation must be first\n"))
+			return -EBUSY;
+		/* nr_range =3D=3D 0 is elsewhere special cased as 0-size device */
 		return 0;
 	}
=20
+	ranges =3D krealloc(dev_dax->ranges, sizeof(*ranges)
+			* (dev_dax->nr_range + 1), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+
 	alloc =3D __request_region(res, start, size, dev_name(dev), 0);
-	if (!alloc)
+	if (!alloc) {
+		/*
+		 * If this was an empty set of ranges nothing else
+		 * will release @ranges, so do it now.
+		 */
+		if (!dev_dax->nr_range) {
+			kfree(ranges);
+			ranges =3D NULL;
+		}
+		dev_dax->ranges =3D ranges;
 		return -ENOMEM;
+	}
=20
-	dev_dax->range =3D (struct range) {
-		.start =3D alloc->start,
-		.end =3D alloc->end,
+	for (i =3D 0; i < dev_dax->nr_range; i++)
+		pgoff +=3D PHYS_PFN(range_len(&ranges[i].range));
+	dev_dax->ranges =3D ranges;
+	ranges[dev_dax->nr_range++] =3D (struct dev_dax_range) {
+		.pgoff =3D pgoff,
+		.range =3D {
+			.start =3D alloc->start,
+			.end =3D alloc->end,
+		},
 	};
=20
+	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
+			&alloc->start, &alloc->end);
+
 	return 0;
 }
=20
 static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *=
res, resource_size_t size)
 {
+	int last_range =3D dev_dax->nr_range - 1;
+	struct dev_dax_range *dax_range =3D &dev_dax->ranges[last_range];
 	struct dax_region *dax_region =3D dev_dax->region;
-	struct range *range =3D &dev_dax->range;
-	int rc =3D 0;
+	bool is_shrink =3D resource_size(res) > size;
+	struct range *range =3D &dax_range->range;
+	struct device *dev =3D &dev_dax->dev;
+	int rc;
=20
 	device_lock_assert(dax_region->dev);
=20
-	if (size)
-		rc =3D adjust_resource(res, range->start, size);
-	else
-		__release_region(&dax_region->res, range->start, range_len(range));
+	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
+		return -EINVAL;
+
+	rc =3D adjust_resource(res, range->start, size);
 	if (rc)
 		return rc;
=20
-	dev_dax->range =3D (struct range) {
+	*range =3D (struct range) {
 		.start =3D range->start,
 		.end =3D range->start + size - 1,
 	};
=20
+	dev_dbg(dev, "%s range[%d]: %#llx:%#llx\n", is_shrink ? "shrink" : "exten=
d",
+			last_range, (unsigned long long) range->start,
+			(unsigned long long) range->end);
+
 	return 0;
 }
=20
@@ -621,7 +672,11 @@ static ssize_t size_show(struct device *
 		struct device_attribute *attr, char *buf)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
-	unsigned long long size =3D range_len(&dev_dax->range);
+	unsigned long long size;
+
+	device_lock(dev);
+	size =3D dev_dax_size(dev_dax);
+	device_unlock(dev);
=20
 	return sprintf(buf, "%llu\n", size);
 }
@@ -639,32 +694,82 @@ static bool alloc_is_aligned(struct dax_
=20
 static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 {
+	resource_size_t to_shrink =3D dev_dax_size(dev_dax) - size;
 	struct dax_region *dax_region =3D dev_dax->region;
-	struct range *range =3D &dev_dax->range;
-	struct resource *res, *adjust =3D NULL;
 	struct device *dev =3D &dev_dax->dev;
+	int i;
=20
-	for_each_dax_region_resource(dax_region, res)
-		if (strcmp(res->name, dev_name(dev)) =3D=3D 0
-				&& res->start =3D=3D range->start) {
-			adjust =3D res;
-			break;
+	for (i =3D dev_dax->nr_range - 1; i >=3D 0; i--) {
+		struct range *range =3D &dev_dax->ranges[i].range;
+		struct resource *adjust =3D NULL, *res;
+		resource_size_t shrink;
+
+		shrink =3D min_t(u64, to_shrink, range_len(range));
+		if (shrink >=3D range_len(range)) {
+			__release_region(&dax_region->res, range->start,
+					range_len(range));
+			dev_dax->nr_range--;
+			dev_dbg(dev, "delete range[%d]: %#llx:%#llx\n", i,
+					(unsigned long long) range->start,
+					(unsigned long long) range->end);
+			to_shrink -=3D shrink;
+			if (!to_shrink)
+				break;
+			continue;
 		}
=20
-	if (dev_WARN_ONCE(dev, !adjust, "failed to find matching resource\n"))
-		return -ENXIO;
-	return adjust_dev_dax_range(dev_dax, adjust, size);
+		for_each_dax_region_resource(dax_region, res)
+			if (strcmp(res->name, dev_name(dev)) =3D=3D 0
+					&& res->start =3D=3D range->start) {
+				adjust =3D res;
+				break;
+			}
+
+		if (dev_WARN_ONCE(dev, !adjust || i !=3D dev_dax->nr_range - 1,
+					"failed to find matching resource\n"))
+			return -ENXIO;
+		return adjust_dev_dax_range(dev_dax, adjust, range_len(range)
+				- shrink);
+	}
+	return 0;
+}
+
+/*
+ * Only allow adjustments that preserve the relative pgoff of existing
+ * allocations. I.e. the dev_dax->ranges array is ordered by increasing pg=
off.
+ */
+static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
+{
+	struct dev_dax_range *last;
+	int i;
+
+	if (dev_dax->nr_range =3D=3D 0)
+		return false;
+	if (strcmp(res->name, dev_name(&dev_dax->dev)) !=3D 0)
+		return false;
+	last =3D &dev_dax->ranges[dev_dax->nr_range - 1];
+	if (last->range.start !=3D res->start || last->range.end !=3D res->end)
+		return false;
+	for (i =3D 0; i < dev_dax->nr_range - 1; i++) {
+		struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];
+
+		if (dax_range->pgoff > last->pgoff)
+			return false;
+	}
+
+	return true;
 }
=20
 static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		struct dev_dax *dev_dax, resource_size_t size)
 {
 	resource_size_t avail =3D dax_region_avail_size(dax_region), to_alloc;
-	resource_size_t dev_size =3D range_len(&dev_dax->range);
+	resource_size_t dev_size =3D dev_dax_size(dev_dax);
 	struct resource *region_res =3D &dax_region->res;
 	struct device *dev =3D &dev_dax->dev;
-	const char *name =3D dev_name(dev);
 	struct resource *res, *first;
+	resource_size_t alloc =3D 0;
+	int rc;
=20
 	if (dev->driver)
 		return -EBUSY;
@@ -685,35 +790,47 @@ static ssize_t dev_dax_resize(struct dax
 	 * may involve adjusting the end of an existing resource, or
 	 * allocating a new resource.
 	 */
+retry:
 	first =3D region_res->child;
 	if (!first)
 		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
-	for (res =3D first; to_alloc && res; res =3D res->sibling) {
+
+	rc =3D -ENOSPC;
+	for (res =3D first; res; res =3D res->sibling) {
 		struct resource *next =3D res->sibling;
-		resource_size_t free;
=20
 		/* space at the beginning of the region */
-		free =3D 0;
-		if (res =3D=3D first && res->start > dax_region->res.start)
-			free =3D res->start - dax_region->res.start;
-		if (free >=3D to_alloc && dev_size =3D=3D 0)
-			return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+		if (res =3D=3D first && res->start > dax_region->res.start) {
+			alloc =3D min(res->start - dax_region->res.start, to_alloc);
+			rc =3D alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
+			break;
+		}
=20
-		free =3D 0;
+		alloc =3D 0;
 		/* space between allocations */
 		if (next && next->start > res->end + 1)
-			free =3D next->start - res->end + 1;
+			alloc =3D min(next->start - (res->end + 1), to_alloc);
=20
 		/* space at the end of the region */
-		if (free < to_alloc && !next && res->end < region_res->end)
-			free =3D region_res->end - res->end;
+		if (!alloc && !next && res->end < region_res->end)
+			alloc =3D min(region_res->end - res->end, to_alloc);
=20
-		if (free >=3D to_alloc && strcmp(name, res->name) =3D=3D 0)
-			return adjust_dev_dax_range(dev_dax, res, resource_size(res) + to_alloc=
);
-		else if (free >=3D to_alloc && dev_size =3D=3D 0)
-			return alloc_dev_dax_range(dev_dax, res->end + 1, to_alloc);
+		if (!alloc)
+			continue;
+
+		if (adjust_ok(dev_dax, res)) {
+			rc =3D adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
+			break;
+		}
+		rc =3D alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
+		break;
 	}
-	return -ENOSPC;
+	if (rc)
+		return rc;
+	to_alloc -=3D alloc;
+	if (to_alloc)
+		goto retry;
+	return 0;
 }
=20
 static ssize_t size_store(struct device *dev, struct device_attribute *att=
r,
@@ -767,8 +884,15 @@ static ssize_t resource_show(struct devi
 		struct device_attribute *attr, char *buf)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+	unsigned long long start;
+
+	if (dev_dax->nr_range < 1)
+		start =3D dax_region->res.start;
+	else
+		start =3D dev_dax->ranges[0].range.start;
=20
-	return sprintf(buf, "%#llx\n", dev_dax->range.start);
+	return sprintf(buf, "%#llx\n", start);
 }
 static DEVICE_ATTR(resource, 0400, resource_show, NULL);
=20
@@ -833,6 +957,7 @@ static void dev_dax_release(struct devic
 	put_dax(dax_dev);
 	free_dev_dax_id(dev_dax);
 	dax_region_put(dax_region);
+	kfree(dev_dax->ranges);
 	kfree(dev_dax->pgmap);
 	kfree(dev_dax);
 }
@@ -941,7 +1066,7 @@ struct dev_dax *devm_create_dev_dax(stru
 err_alloc_dax:
 	kfree(dev_dax->pgmap);
 err_pgmap:
-	free_dev_dax_range(dev_dax);
+	free_dev_dax_ranges(dev_dax);
 err_range:
 	free_dev_dax_id(dev_dax);
 err_id:
--- a/drivers/dax/dax-private.h~device-dax-add-dis-contiguous-resource-supp=
ort
+++ a/drivers/dax/dax-private.h
@@ -49,7 +49,8 @@ struct dax_region {
  * @id: ida allocated id
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
- * @range: resource range for the instance
+ * @nr_range: size of @ranges
+ * @ranges: resource-span + pgoff tuples for the instance
  */
 struct dev_dax {
 	struct dax_region *region;
@@ -58,7 +59,11 @@ struct dev_dax {
 	int id;
 	struct device dev;
 	struct dev_pagemap *pgmap;
-	struct range range;
+	int nr_range;
+	struct dev_dax_range {
+		unsigned long pgoff;
+		struct range range;
+	} *ranges;
 };
=20
 static inline struct dev_dax *to_dev_dax(struct device *dev)
--- a/drivers/dax/device.c~device-dax-add-dis-contiguous-resource-support
+++ a/drivers/dax/device.c
@@ -55,15 +55,22 @@ static int check_vma(struct dev_dax *dev
 __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgof=
f,
 		unsigned long size)
 {
-	struct range *range =3D &dev_dax->range;
-	phys_addr_t phys;
+	int i;
=20
-	phys =3D pgoff * PAGE_SIZE + range->start;
-	if (phys >=3D range->start && phys <=3D range->end) {
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];
+		struct range *range =3D &dax_range->range;
+		unsigned long long pgoff_end;
+		phys_addr_t phys;
+
+		pgoff_end =3D dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
+		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
+			continue;
+		phys =3D PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
 		if (phys + size - 1 <=3D range->end)
 			return phys;
+		break;
 	}
-
 	return -1;
 }
=20
@@ -395,30 +402,40 @@ static void dev_dax_kill(void *dev_dax)
 int dev_dax_probe(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev =3D dev_dax->dax_dev;
-	struct range *range =3D &dev_dax->range;
 	struct device *dev =3D &dev_dax->dev;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
 	struct cdev *cdev;
 	void *addr;
-	int rc;
-
-	/* 1:1 map region resource range to device-dax instance range */
-	if (!devm_request_mem_region(dev, range->start, range_len(range),
-				dev_name(dev))) {
-		dev_warn(dev, "could not reserve range: %#llx - %#llx\n",
-				range->start, range->end);
-		return -EBUSY;
-	}
+	int rc, i;
=20
 	pgmap =3D dev_dax->pgmap;
+	if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
+			"static pgmap / multi-range device conflict\n"))
+		return -EINVAL;
+
 	if (!pgmap) {
-		pgmap =3D devm_kzalloc(dev, sizeof(*pgmap), GFP_KERNEL);
+		pgmap =3D devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
+				* (dev_dax->nr_range - 1), GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
-		pgmap->range =3D *range;
-		pgmap->nr_range =3D 1;
+		pgmap->nr_range =3D dev_dax->nr_range;
+	}
+
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct range *range =3D &dev_dax->ranges[i].range;
+
+		if (!devm_request_mem_region(dev, range->start,
+					range_len(range), dev_name(dev))) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
+					i, range->start, range->end);
+			return -EBUSY;
+		}
+		/* don't update the range for static pgmap */
+		if (!dev_dax->pgmap)
+			pgmap->ranges[i] =3D *range;
 	}
+
 	pgmap->type =3D MEMORY_DEVICE_GENERIC;
 	addr =3D devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
--- a/drivers/dax/kmem.c~device-dax-add-dis-contiguous-resource-support
+++ a/drivers/dax/kmem.c
@@ -19,24 +19,28 @@ static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
 static bool any_hotremove_failed;
=20
-static struct range dax_kmem_range(struct dev_dax *dev_dax)
+static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 {
-	struct range range;
+	struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];
+	struct range *range =3D &dax_range->range;
=20
 	/* memory-block align the hotplug range */
-	range.start =3D ALIGN(dev_dax->range.start, memory_block_size_bytes());
-	range.end =3D ALIGN_DOWN(dev_dax->range.end + 1, memory_block_size_bytes(=
)) - 1;
-	return range;
+	r->start =3D ALIGN(range->start, memory_block_size_bytes());
+	r->end =3D ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	if (r->start >=3D r->end) {
+		r->start =3D range->start;
+		r->end =3D range->end;
+		return -ENOSPC;
+	}
+	return 0;
 }
=20
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
-	struct range range =3D dax_kmem_range(dev_dax);
 	struct device *dev =3D &dev_dax->dev;
-	struct resource *res;
+	int i, mapped =3D 0;
 	char *res_name;
 	int numa_node;
-	int rc;
=20
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -55,31 +59,58 @@ static int dev_dax_kmem_probe(struct dev
 	if (!res_name)
 		return -ENOMEM;
=20
-	/* Region is permanently reserved if hotremove fails. */
-	res =3D request_mem_region(range.start, range_len(&range), res_name);
-	if (!res) {
-		dev_warn(dev, "could not reserve region [%#llx-%#llx]\n", range.start, r=
ange.end);
-		kfree(res_name);
-		return -EBUSY;
-	}
-
-	/*
-	 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
-	 * so that add_memory() can add a child resource.  Do not
-	 * inherit flags from the parent since it may set new flags
-	 * unknown to us that will break add_memory() below.
-	 */
-	res->flags =3D IORESOURCE_SYSTEM_RAM;
-
-	/*
-	 * Ensure that future kexec'd kernels will not treat this as RAM
-	 * automatically.
-	 */
-	rc =3D add_memory_driver_managed(numa_node, range.start, range_len(&range=
), kmem_name);
-	if (rc) {
-		release_mem_region(range.start, range_len(&range));
-		kfree(res_name);
-		return rc;
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct resource *res;
+		struct range range;
+		int rc;
+
+		rc =3D dax_kmem_range(dev_dax, i, &range);
+		if (rc) {
+			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
+					i, range.start, range.end);
+			continue;
+		}
+
+		/* Region is permanently reserved if hotremove fails. */
+		res =3D request_mem_region(range.start, range_len(&range), res_name);
+		if (!res) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
+					i, range.start, range.end);
+			/*
+			 * Once some memory has been onlined we can't
+			 * assume that it can be un-onlined safely.
+			 */
+			if (mapped)
+				continue;
+			kfree(res_name);
+			return -EBUSY;
+		}
+
+		/*
+		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
+		 * so that add_memory() can add a child resource.  Do not
+		 * inherit flags from the parent since it may set new flags
+		 * unknown to us that will break add_memory() below.
+		 */
+		res->flags =3D IORESOURCE_SYSTEM_RAM;
+
+		/*
+		 * Ensure that future kexec'd kernels will not treat
+		 * this as RAM automatically.
+		 */
+		rc =3D add_memory_driver_managed(numa_node, range.start,
+				range_len(&range), kmem_name);
+
+		if (rc) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
+					i, range.start, range.end);
+			release_mem_region(range.start, range_len(&range));
+			if (mapped)
+				continue;
+			kfree(res_name);
+			return rc;
+		}
+		mapped++;
 	}
=20
 	dev_set_drvdata(dev, res_name);
@@ -90,9 +121,8 @@ static int dev_dax_kmem_probe(struct dev
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static int dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int rc;
+	int i, success =3D 0;
 	struct device *dev =3D &dev_dax->dev;
-	struct range range =3D dax_kmem_range(dev_dax);
 	const char *res_name =3D dev_get_drvdata(dev);
=20
 	/*
@@ -101,17 +131,31 @@ static int dev_dax_kmem_remove(struct de
 	 * there is no way to hotremove this memory until reboot because device
 	 * unbind will succeed even if we return failure.
 	 */
-	rc =3D remove_memory(dev_dax->target_node, range.start, range_len(&range)=
);
-	if (rc) {
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+		int rc;
+
+		rc =3D dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		rc =3D remove_memory(dev_dax->target_node, range.start,
+				range_len(&range));
+		if (rc =3D=3D 0) {
+			release_mem_region(range.start, range_len(&range));
+			success++;
+			continue;
+		}
 		any_hotremove_failed =3D true;
-		dev_err(dev, "%#llx-%#llx cannot be hotremoved until the next reboot\n",
-				range.start, range.end);
-		return rc;
+		dev_err(dev,
+			"mapping%d: %#llx-%#llx cannot be hotremoved until the next reboot\n",
+				i, range.start, range.end);
 	}
=20
-	/* Release and free dax resources */
-	release_mem_region(range.start, range_len(&range));
-	kfree(res_name);
+	if (success >=3D dev_dax->nr_range) {
+		kfree(res_name);
+		dev_set_drvdata(dev, NULL);
+	}
=20
 	return 0;
 }
--- a/tools/testing/nvdimm/dax-dev.c~device-dax-add-dis-contiguous-resource=
-support
+++ a/tools/testing/nvdimm/dax-dev.c
@@ -9,11 +9,18 @@
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		unsigned long size)
 {
-	struct range *range =3D &dev_dax->range;
-	phys_addr_t addr;
+	int i;
=20
-	addr =3D pgoff * PAGE_SIZE + range->start;
-	if (addr >=3D range->start && addr <=3D range->end) {
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];
+		struct range *range =3D &dax_range->range;
+		unsigned long long pgoff_end;
+		phys_addr_t addr;
+
+		pgoff_end =3D dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
+		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
+			continue;
+		addr =3D PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
 		if (addr + size - 1 <=3D range->end) {
 			if (get_nfit_res(addr)) {
 				struct page *page;
@@ -23,9 +30,10 @@ phys_addr_t dax_pgoff_to_phys(struct dev
=20
 				page =3D vmalloc_to_page((void *)addr);
 				return PFN_PHYS(page_to_pfn(page));
-			} else
-				return addr;
+			}
+			return addr;
 		}
+		break;
 	}
 	return -1;
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

x86-numa-cleanup-configuration-dependent-command-line-options.patch
x86-numa-add-nohmat-option.patch
efi-fake_mem-arrange-for-a-resource-entry-per-efi_fake_mem-instance.patch
acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device.patch
resource-report-parent-to-walk_iomem_res_desc-callback.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch
device-dax-drop-the-dax_regionpfn_flags-attribute.patch
device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.patch
device-dax-make-pgmap-optional-for-instance-creation.patch
device-dax-kmem-introduce-dax_kmem_range.patch
device-dax-kmem-move-resource-name-tracking-to-drvdata.patch
device-dax-kmem-replace-release_resource-with-release_mem_region.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-struct-dev_dax-typed-driver-operations.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.pa=
tch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch
device-dax-add-an-align-attribute.patch

