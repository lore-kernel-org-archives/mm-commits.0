Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE8CC2D0A2
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D081322244
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633081;
	bh=HStqRkl+1fj8ljgcJMKcWMJT3uplVbdgxMf0jJdkD9s=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jrzc/wRoZ8C9b1Ep2qQbZSeOrkkryqH+djqJJxssZDHPb3SbSge3svu5C6IYTPb0g
	 JHZNwEqsenQcjHGgMUFwv2IsuocaurrJ+9aveoY4798Oi86O2RFh2dV+GySbIPHKpq
	 TiNNFI+RIY2CIyKJI6MnDX+b0dGEkqVptG5iFy+0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387954AbgJMXvV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgJMXu7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:50:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF81722227;
        Tue, 13 Oct 2020 23:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633058;
        bh=HStqRkl+1fj8ljgcJMKcWMJT3uplVbdgxMf0jJdkD9s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DTNwEx5f40AVekO3lWBIks45g/jvn435QCjtwTXX91K+YweiCQy81AX/f/a5HjgBI
         flU+RL8jSKeBC1hHct80dD2N3fer+ZpMOBKnU+4Gx4R4FlzZLxiRRGa17pXn/KpWf+
         vnWgCvPIW9bZ4IzlMM4qtH/oNo51HRs2744s/lJc=
Date:   Tue, 13 Oct 2020 16:50:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, linux-mm@kvack.org, lkp@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, pasha.tatashin@soleen.com, paulus@ozlabs.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rdunlap@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@linux.ibm.com, sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com, vishal.l.verma@intel.com, will@kernel.org,
        yanaijie@huawei.com
Subject:  [patch 049/181] device-dax: add an 'align' attribute
Message-ID: <20201013235055.LgOw_AyKM%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: add an 'align' attribute

Introduce a device align attribute.  While doing so, rename the region
align attribute to be more explicitly named as so, but keep it named as
@align to retain the API for tools like daxctl.

Changes on align may not always be valid, when say certain mappings were
created with 2M and then we switch to 1G.  So, we validate all ranges
against the new value being attempted, post resizing.

Link: https://lkml.kernel.org/r/159643105944.4062302.3131761052969132784.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-3-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106118486.30709.13012322227204800596.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/dax/bus.c         |   93 ++++++++++++++++++++++++++++++++----
 drivers/dax/dax-private.h |   18 ++++++
 2 files changed, 101 insertions(+), 10 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-an-align-attribute
+++ a/drivers/dax/bus.c
@@ -230,14 +230,15 @@ static ssize_t region_size_show(struct d
 static struct device_attribute dev_attr_region_size =3D __ATTR(size, 0444,
 		region_size_show, NULL);
=20
-static ssize_t align_show(struct device *dev,
+static ssize_t region_align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dax_region *dax_region =3D dev_get_drvdata(dev);
=20
 	return sprintf(buf, "%u\n", dax_region->align);
 }
-static DEVICE_ATTR_RO(align);
+static struct device_attribute dev_attr_region_align =3D
+		__ATTR(align, 0400, region_align_show, NULL);
=20
 #define for_each_dax_region_resource(dax_region, res) \
 	for (res =3D (dax_region)->res.child; res; res =3D res->sibling)
@@ -488,7 +489,7 @@ static umode_t dax_region_visible(struct
 static struct attribute *dax_region_attributes[] =3D {
 	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
-	&dev_attr_align.attr,
+	&dev_attr_region_align.attr,
 	&dev_attr_create.attr,
 	&dev_attr_seed.attr,
 	&dev_attr_delete.attr,
@@ -858,15 +859,13 @@ static ssize_t size_show(struct device *
 	return sprintf(buf, "%llu\n", size);
 }
=20
-static bool alloc_is_aligned(struct dax_region *dax_region,
-		resource_size_t size)
+static bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
 {
 	/*
 	 * The minimum mapping granularity for a device instance is a
 	 * single subsection, unless the arch says otherwise.
 	 */
-	return IS_ALIGNED(size, max_t(unsigned long, dax_region->align,
-				memremap_compat_align()));
+	return IS_ALIGNED(size, max_t(unsigned long, dev_dax->align, memremap_com=
pat_align()));
 }
=20
 static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
@@ -961,7 +960,7 @@ static ssize_t dev_dax_resize(struct dax
 		return dev_dax_shrink(dev_dax, size);
=20
 	to_alloc =3D size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dax_region, to_alloc),
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
 			"resize of %pa misaligned\n", &to_alloc))
 		return -ENXIO;
=20
@@ -1025,7 +1024,7 @@ static ssize_t size_store(struct device
 	if (rc)
 		return rc;
=20
-	if (!alloc_is_aligned(dax_region, val)) {
+	if (!alloc_is_aligned(dev_dax, val)) {
 		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
 		return -EINVAL;
 	}
@@ -1044,6 +1043,78 @@ static ssize_t size_store(struct device
 }
 static DEVICE_ATTR_RW(size);
=20
+static ssize_t align_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->align);
+}
+
+static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
+{
+	resource_size_t dev_size =3D dev_dax_size(dev_dax);
+	struct device *dev =3D &dev_dax->dev;
+	int i;
+
+	if (dev_size > 0 && !alloc_is_aligned(dev_dax, dev_size)) {
+		dev_dbg(dev, "%s: align %u invalid for size %pa\n",
+			__func__, dev_dax->align, &dev_size);
+		return -EINVAL;
+	}
+
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		size_t len =3D range_len(&dev_dax->ranges[i].range);
+
+		if (!alloc_is_aligned(dev_dax, len)) {
+			dev_dbg(dev, "%s: align %u invalid for range %d\n",
+				__func__, dev_dax->align, i);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t align_store(struct device *dev, struct device_attribute *at=
tr,
+		const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+	unsigned long val, align_save;
+	ssize_t rc;
+
+	rc =3D kstrtoul(buf, 0, &val);
+	if (rc)
+		return -ENXIO;
+
+	if (!dax_align_valid(val))
+		return -EINVAL;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	device_lock(dev);
+	if (dev->driver) {
+		rc =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	align_save =3D dev_dax->align;
+	dev_dax->align =3D val;
+	rc =3D dev_dax_validate_align(dev_dax);
+	if (rc)
+		dev_dax->align =3D align_save;
+out_unlock:
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+	return rc =3D=3D 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(align);
+
 static int dev_dax_target_node(struct dev_dax *dev_dax)
 {
 	struct dax_region *dax_region =3D dev_dax->region;
@@ -1104,7 +1175,8 @@ static umode_t dev_dax_visible(struct ko
 		return 0;
 	if (a =3D=3D &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
-	if (a =3D=3D &dev_attr_size.attr && is_static(dax_region))
+	if ((a =3D=3D &dev_attr_align.attr ||
+	     a =3D=3D &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
 	return a->mode;
 }
@@ -1113,6 +1185,7 @@ static struct attribute *dev_dax_attribu
 	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
+	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	NULL,
--- a/drivers/dax/dax-private.h~device-dax-add-an-align-attribute
+++ a/drivers/dax/dax-private.h
@@ -87,4 +87,22 @@ static inline struct dax_mapping *to_dax
 }
=20
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsi=
gned long size);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool dax_align_valid(unsigned long align)
+{
+	if (align =3D=3D PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGE=
PAGE_PUD))
+		return true;
+	if (align =3D=3D PMD_SIZE && has_transparent_hugepage())
+		return true;
+	if (align =3D=3D PAGE_SIZE)
+		return true;
+	return false;
+}
+#else
+static inline bool dax_align_valid(unsigned long align)
+{
+	return align =3D=3D PAGE_SIZE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
_
