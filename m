Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B13C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0728B20BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087103;
	bh=UBXycJnq9hY/TXJMb51B56aZyGrwItBk4ZUWXadNyy0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zd1+BGKgv01BmGJw/Cws90uIMZcgvn861oyN4BGksmeShZyxhgZHdakht/xDSimOt
	 YcPMcI5ws+jQ8/FUtOy81jhPNisenRE6qKGXb/DVMJDjW2TTYrcZ1OZYzzqQBR0mKU
	 j04rM3yWRPAFtsz1+pJYawk1pqOzoTzjIUdJsu5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgIZCZC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbgIZCZC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:02 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDED20866;
        Sat, 26 Sep 2020 02:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087101;
        bh=UBXycJnq9hY/TXJMb51B56aZyGrwItBk4ZUWXadNyy0=;
        h=Date:From:To:Subject:From;
        b=p+4+LZCUaDT7GDNLtyi8HocshdKW7KUFlfXJXLXPS+Quov2HmAT4iVhfkTRvysfgN
         J/f/VvjNt9QPlVPCJHIJkNeABy5iFn1F4Y3BmfErQQkWpwuAgKIteU/WEFWpTT9een
         fnd9mnuA18LC5Uwy/ACCcSadG5DVKhpaSaEWk8x0=
Date:   Fri, 25 Sep 2020 19:24:58 -0700
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
Subject:  + device-dax-introduce-seed-devices.patch added to -mm tree
Message-ID: <20200926022458.bnCoF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: introduce 'seed' devices
has been added to the -mm tree.  Its filename is
     device-dax-introduce-seed-devices.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-introduce-seed-dev=
ices.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-introduce-seed-dev=
ices.patch

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
Subject: device-dax: introduce 'seed' devices

Add a seed device concept for dynamic dax regions to be able to split the
region amongst multiple sub-instances.  The seed device, similar to
libnvdimm seed devices, is a device that starts with zero capacity
allocated and unbound to a driver.  In contrast to libnvdimm seed devices
explicit 'create' and 'delete' interfaces are added to the region to
trigger seeds to be created and unused devices to be reclaimed.  The
explicit create and delete replaces implicit create as a side effect of
probe and implicit delete when writing 0 to the size that libnvdimm
implements.

Delete can be performed on any 0-sized and idle device.  This avoids the
gymnastics of needing to move device_unregister() to its own async
context.  Specifically, it avoids the deadlock of deleting a device via
one of its own attributes.  It is also less surprising to userspace which
never sees an extra device it did not request.

For now just add the device creation, teardown, and ->probe() prevention.=
=20
A later patch will arrange for the 'dax/size' attribute to be writable to
allocate capacity from the region.

Link: https://lkml.kernel.org/r/159643101583.4062302.12255093902950754962.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106113873.30709.15168756050631539431.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
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
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |  301 +++++++++++++++++++++++++++++++-----
 drivers/dax/dax-private.h |    9 +
 drivers/dax/hmem/hmem.c   |    2=20
 3 files changed, 272 insertions(+), 40 deletions(-)

--- a/drivers/dax/bus.c~device-dax-introduce-seed-devices
+++ a/drivers/dax/bus.c
@@ -139,8 +139,26 @@ static int dax_bus_probe(struct device *
 {
 	struct dax_device_driver *dax_drv =3D to_dax_drv(dev->driver);
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+	int rc;
+
+	if (range_len(range) =3D=3D 0 || dev_dax->id < 0)
+		return -ENXIO;
+
+	rc =3D dax_drv->probe(dev_dax);
=20
-	return dax_drv->probe(dev_dax);
+	if (rc || is_static(dax_region))
+		return rc;
+
+	/*
+	 * Track new seed creation only after successful probe of the
+	 * previous seed.
+	 */
+	if (dax_region->seed =3D=3D dev)
+		dax_region->seed =3D NULL;
+
+	return 0;
 }
=20
 static int dax_bus_remove(struct device *dev)
@@ -237,14 +255,216 @@ static ssize_t available_size_show(struc
 }
 static DEVICE_ATTR_RO(available_size);
=20
+static ssize_t seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+	struct device *seed;
+	ssize_t rc;
+
+	if (is_static(dax_region))
+		return -EINVAL;
+
+	device_lock(dev);
+	seed =3D dax_region->seed;
+	rc =3D sprintf(buf, "%s\n", seed ? dev_name(seed) : "");
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(seed);
+
+static ssize_t create_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+	struct device *youngest;
+	ssize_t rc;
+
+	if (is_static(dax_region))
+		return -EINVAL;
+
+	device_lock(dev);
+	youngest =3D dax_region->youngest;
+	rc =3D sprintf(buf, "%s\n", youngest ? dev_name(youngest) : "");
+	device_unlock(dev);
+
+	return rc;
+}
+
+static ssize_t create_store(struct device *dev, struct device_attribute *a=
ttr,
+		const char *buf, size_t len)
+{
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+	unsigned long long avail;
+	ssize_t rc;
+	int val;
+
+	if (is_static(dax_region))
+		return -EINVAL;
+
+	rc =3D kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
+	if (val !=3D 1)
+		return -EINVAL;
+
+	device_lock(dev);
+	avail =3D dax_region_avail_size(dax_region);
+	if (avail =3D=3D 0)
+		rc =3D -ENOSPC;
+	else {
+		struct dev_dax_data data =3D {
+			.dax_region =3D dax_region,
+			.size =3D 0,
+			.id =3D -1,
+		};
+		struct dev_dax *dev_dax =3D devm_create_dev_dax(&data);
+
+		if (IS_ERR(dev_dax))
+			rc =3D PTR_ERR(dev_dax);
+		else {
+			/*
+			 * In support of crafting multiple new devices
+			 * simultaneously multiple seeds can be created,
+			 * but only the first one that has not been
+			 * successfully bound is tracked as the region
+			 * seed.
+			 */
+			if (!dax_region->seed)
+				dax_region->seed =3D &dev_dax->dev;
+			dax_region->youngest =3D &dev_dax->dev;
+			rc =3D len;
+		}
+	}
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(create);
+
+void kill_dev_dax(struct dev_dax *dev_dax)
+{
+	struct dax_device *dax_dev =3D dev_dax->dax_dev;
+	struct inode *inode =3D dax_inode(dax_dev);
+
+	kill_dax(dax_dev);
+	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+}
+EXPORT_SYMBOL_GPL(kill_dev_dax);
+
+static void free_dev_dax_range(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+
+	device_lock_assert(dax_region->dev);
+	if (range_len(range))
+		__release_region(&dax_region->res, range->start,
+				range_len(range));
+}
+
+static void unregister_dev_dax(void *dev)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	kill_dev_dax(dev_dax);
+	free_dev_dax_range(dev_dax);
+	device_del(dev);
+	put_device(dev);
+}
+
+/* a return value >=3D 0 indicates this invocation invalidated the id */
+static int __free_dev_dax_id(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct device *dev =3D &dev_dax->dev;
+	int rc =3D dev_dax->id;
+
+	device_lock_assert(dev);
+
+	if (is_static(dax_region) || dev_dax->id < 0)
+		return -1;
+	ida_free(&dax_region->ida, dev_dax->id);
+	dev_dax->id =3D -1;
+	return rc;
+}
+
+static int free_dev_dax_id(struct dev_dax *dev_dax)
+{
+	struct device *dev =3D &dev_dax->dev;
+	int rc;
+
+	device_lock(dev);
+	rc =3D __free_dev_dax_id(dev_dax);
+	device_unlock(dev);
+	return rc;
+}
+
+static ssize_t delete_store(struct device *dev, struct device_attribute *a=
ttr,
+		const char *buf, size_t len)
+{
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+	struct dev_dax *dev_dax;
+	struct device *victim;
+	bool do_del =3D false;
+	int rc;
+
+	if (is_static(dax_region))
+		return -EINVAL;
+
+	victim =3D device_find_child_by_name(dax_region->dev, buf);
+	if (!victim)
+		return -ENXIO;
+
+	device_lock(dev);
+	device_lock(victim);
+	dev_dax =3D to_dev_dax(victim);
+	if (victim->driver || range_len(&dev_dax->range))
+		rc =3D -EBUSY;
+	else {
+		/*
+		 * Invalidate the device so it does not become active
+		 * again, but always preserve device-id-0 so that
+		 * /sys/bus/dax/ is guaranteed to be populated while any
+		 * dax_region is registered.
+		 */
+		if (dev_dax->id > 0) {
+			do_del =3D __free_dev_dax_id(dev_dax) >=3D 0;
+			rc =3D len;
+			if (dax_region->seed =3D=3D victim)
+				dax_region->seed =3D NULL;
+			if (dax_region->youngest =3D=3D victim)
+				dax_region->youngest =3D NULL;
+		} else
+			rc =3D -EBUSY;
+	}
+	device_unlock(victim);
+
+	/* won the race to invalidate the device, clean it up */
+	if (do_del)
+		devm_release_action(dev, unregister_dev_dax, victim);
+	device_unlock(dev);
+	put_device(victim);
+
+	return rc;
+}
+static DEVICE_ATTR_WO(delete);
+
 static umode_t dax_region_visible(struct kobject *kobj, struct attribute *=
a,
 		int n)
 {
 	struct device *dev =3D container_of(kobj, struct device, kobj);
 	struct dax_region *dax_region =3D dev_get_drvdata(dev);
=20
-	if (is_static(dax_region) && a =3D=3D &dev_attr_available_size.attr)
-		return 0;
+	if (is_static(dax_region))
+		if (a =3D=3D &dev_attr_available_size.attr
+				|| a =3D=3D &dev_attr_create.attr
+				|| a =3D=3D &dev_attr_seed.attr
+				|| a =3D=3D &dev_attr_delete.attr)
+			return 0;
 	return a->mode;
 }
=20
@@ -252,6 +472,9 @@ static struct attribute *dax_region_attr
 	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
 	&dev_attr_align.attr,
+	&dev_attr_create.attr,
+	&dev_attr_seed.attr,
+	&dev_attr_delete.attr,
 	&dev_attr_id.attr,
 	NULL,
 };
@@ -320,6 +543,7 @@ struct dax_region *alloc_dax_region(stru
 	dax_region->align =3D align;
 	dax_region->dev =3D parent;
 	dax_region->target_node =3D target_node;
+	ida_init(&dax_region->ida);
 	dax_region->res =3D (struct resource) {
 		.start =3D res->start,
 		.end =3D res->end,
@@ -347,6 +571,15 @@ static int alloc_dev_dax_range(struct de
=20
 	device_lock_assert(dax_region->dev);
=20
+	/* handle the seed alloc special case */
+	if (!size) {
+		dev_dax->range =3D (struct range) {
+			.start =3D res->start,
+			.end =3D res->start - 1,
+		};
+		return 0;
+	}
+
 	/* TODO: handle multiple allocations per region */
 	if (res->child)
 		return -ENOMEM;
@@ -448,33 +681,15 @@ static const struct attribute_group *dax
 	NULL,
 };
=20
-void kill_dev_dax(struct dev_dax *dev_dax)
-{
-	struct dax_device *dax_dev =3D dev_dax->dax_dev;
-	struct inode *inode =3D dax_inode(dax_dev);
-
-	kill_dax(dax_dev);
-	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
-}
-EXPORT_SYMBOL_GPL(kill_dev_dax);
-
-static void free_dev_dax_range(struct dev_dax *dev_dax)
-{
-	struct dax_region *dax_region =3D dev_dax->region;
-	struct range *range =3D &dev_dax->range;
-
-	device_lock_assert(dax_region->dev);
-	__release_region(&dax_region->res, range->start, range_len(range));
-}
-
 static void dev_dax_release(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct dax_region *dax_region =3D dev_dax->region;
 	struct dax_device *dax_dev =3D dev_dax->dax_dev;
=20
-	dax_region_put(dax_region);
 	put_dax(dax_dev);
+	free_dev_dax_id(dev_dax);
+	dax_region_put(dax_region);
 	kfree(dev_dax->pgmap);
 	kfree(dev_dax);
 }
@@ -484,18 +699,6 @@ static const struct device_type dev_dax_
 	.groups =3D dax_attribute_groups,
 };
=20
-static void unregister_dev_dax(void *dev)
-{
-	struct dev_dax *dev_dax =3D to_dev_dax(dev);
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	kill_dev_dax(dev_dax);
-	free_dev_dax_range(dev_dax);
-	device_del(dev);
-	put_device(dev);
-}
-
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dax_region *dax_region =3D data->dax_region;
@@ -506,17 +709,35 @@ struct dev_dax *devm_create_dev_dax(stru
 	struct device *dev;
 	int rc;
=20
-	if (data->id < 0)
-		return ERR_PTR(-EINVAL);
-
 	dev_dax =3D kzalloc(sizeof(*dev_dax), GFP_KERNEL);
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
=20
+	if (is_static(dax_region)) {
+		if (dev_WARN_ONCE(parent, data->id < 0,
+				"dynamic id specified to static region\n")) {
+			rc =3D -EINVAL;
+			goto err_id;
+		}
+
+		dev_dax->id =3D data->id;
+	} else {
+		if (dev_WARN_ONCE(parent, data->id >=3D 0,
+				"static id specified to dynamic region\n")) {
+			rc =3D -EINVAL;
+			goto err_id;
+		}
+
+		rc =3D ida_alloc(&dax_region->ida, GFP_KERNEL);
+		if (rc < 0)
+			goto err_id;
+		dev_dax->id =3D rc;
+	}
+
 	dev_dax->region =3D dax_region;
 	dev =3D &dev_dax->dev;
 	device_initialize(dev);
-	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
=20
 	rc =3D alloc_dev_dax_range(dev_dax, data->size);
 	if (rc)
@@ -579,6 +800,8 @@ err_alloc_dax:
 err_pgmap:
 	free_dev_dax_range(dev_dax);
 err_range:
+	free_dev_dax_id(dev_dax);
+err_id:
 	kfree(dev_dax);
=20
 	return ERR_PTR(rc);
--- a/drivers/dax/dax-private.h~device-dax-introduce-seed-devices
+++ a/drivers/dax/dax-private.h
@@ -7,6 +7,7 @@
=20
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
=20
 /* private routines between core files */
 struct dax_device;
@@ -22,7 +23,10 @@ void dax_bus_exit(void);
  * @kref: to pin while other agents have a need to do lookups
  * @dev: parent device backing this region
  * @align: allocation and mapping alignment for child dax devices
+ * @ida: instance id allocator
  * @res: resource tree to track instance allocations
+ * @seed: allow userspace to find the first unbound seed device
+ * @youngest: allow userspace to find the most recently created device
  */
 struct dax_region {
 	int id;
@@ -30,7 +34,10 @@ struct dax_region {
 	struct kref kref;
 	struct device *dev;
 	unsigned int align;
+	struct ida ida;
 	struct resource res;
+	struct device *seed;
+	struct device *youngest;
 };
=20
 /**
@@ -39,6 +46,7 @@ struct dax_region {
  * @region - parent region
  * @dax_dev - core dax functionality
  * @target_node: effective numa node if dev_dax memory range is onlined
+ * @id: ida allocated id
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @range: resource range for the instance
@@ -47,6 +55,7 @@ struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
 	int target_node;
+	int id;
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	struct range range;
--- a/drivers/dax/hmem/hmem.c~device-dax-introduce-seed-devices
+++ a/drivers/dax/hmem/hmem.c
@@ -26,7 +26,7 @@ static int dax_hmem_probe(struct platfor
=20
 	data =3D (struct dev_dax_data) {
 		.dax_region =3D dax_region,
-		.id =3D 0,
+		.id =3D -1,
 		.size =3D resource_size(res),
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
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

