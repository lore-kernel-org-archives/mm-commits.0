Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B14C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BB821741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087155;
	bh=EESpEC7qiaOCM4yrBj6sRVczpsl/0GbcJ5jsdTBs8is=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LqLbmE7+H+PiZpTkQgJ58zxCmA3ZH/HTKlNJ7FINactom2+xTPP3B+Vb+4KA0KIob
	 LIY9ijo1O8Hgk9ySlIn4DPaSQ92w6EF8outxNyriK08/bngGM/xlxTZn9SRn+eL0V3
	 rZPjTAjxMZ/2V5HJZZ9qOGx/DyG/7TN2HhA2WM74=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIZCZz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZCZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:55 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159162087D;
        Sat, 26 Sep 2020 02:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087154;
        bh=EESpEC7qiaOCM4yrBj6sRVczpsl/0GbcJ5jsdTBs8is=;
        h=Date:From:To:Subject:From;
        b=zvuF4VWqjsJILA46aIpsE1dgmIP3TxgOrV2XDBos/fg7IHNCt+Hz+SYxkYXfJnAVc
         HvKqKyYDZgdmJyRHh+6LMIgMHmJ7eLj8V1G8+fkR7Osg7EonFaz8SFk/xU6eo9/05M
         s66cUOH/zQaobymIXM6jnzNHkn0Rr2ua8OdsrS1w=
Date:   Fri, 25 Sep 2020 19:25:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanaijie@huawei.com, will@kernel.org,
        vishal.l.verma@intel.com, vgoyal@redhat.com,
        thomas.lendacky@amd.com, tglx@linutronix.de,
        sstabellini@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@linux.alibaba.com, rdunlap@infradead.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        paulus@ozlabs.org, pasha.tatashin@soleen.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, lkp@intel.com,
        justin.he@arm.com, Jonathan.Cameron@huawei.com, jmoyer@redhat.com,
        jgross@suse.com, jglisse@redhat.com, jgg@mellanox.com,
        ira.weiny@intel.com, hulkci@huawei.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        daniel@ffwll.ch, catalin.marinas@arm.com, bskeggs@redhat.com,
        Brice.Goglin@inria.fr, bp@alien8.de, boris.ostrovsky@oracle.com,
        bhelgaas@google.com, benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        joao.m.martins@oracle.com
Subject:  + device-dax-add-a-range-mapping-allocation-attribute.patch
 added to -mm tree
Message-ID: <20200926022551.9VDiO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add a range mapping allocation attribute
has been added to the -mm tree.  Its filename is
     device-dax-add-a-range-mapping-allocation-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-a-range-mappin=
g-allocation-attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-a-range-mappin=
g-allocation-attribute.patch

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
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: add a range mapping allocation attribute

Add a sysfs attribute which denotes a range from the dax region to be
allocated.  It's an write only @mapping sysfs attribute in the format of
'<start>-<end>' to allocate a range.  @start and @end use hexadecimal
values and the @pgoff is implicitly ordered wrt to previous writes to
@mapping sysfs e.g.  a write of a range of length 1G the pgoff is
0..1G(-4K), a second write will use @pgoff for 1G+4K..<size>.

This range mapping interface is useful for:

 1) Application which want to implement its own allocation logic, and
    thus pick the desired ranges from dax_region.

 2) For use cases like VMM fast restart[0] where after kexec we want
    to the same gpa<->phys mappings (as originally created before kexec).

[0] https://static.sched.com/hosted_files/kvmforum2019/66/VMM-fast-restart_=
kvmforum2019.pdf

Link: https://lkml.kernel.org/r/159643106970.4062302.10402616567780784722.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-5-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106119570.30709.4548889722645210610.stgi=
t@dwillia2-desk3.amr.corp.intel.com
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

 drivers/dax/bus.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/dax/bus.c~device-dax-add-a-range-mapping-allocation-attribute
+++ a/drivers/dax/bus.c
@@ -1043,6 +1043,67 @@ static ssize_t size_store(struct device
 }
 static DEVICE_ATTR_RW(size);
=20
+static ssize_t range_parse(const char *opt, size_t len, struct range *rang=
e)
+{
+	unsigned long long addr =3D 0;
+	char *start, *end, *str;
+	ssize_t rc =3D EINVAL;
+
+	str =3D kstrdup(opt, GFP_KERNEL);
+	if (!str)
+		return rc;
+
+	end =3D str;
+	start =3D strsep(&end, "-");
+	if (!start || !end)
+		goto err;
+
+	rc =3D kstrtoull(start, 16, &addr);
+	if (rc)
+		goto err;
+	range->start =3D addr;
+
+	rc =3D kstrtoull(end, 16, &addr);
+	if (rc)
+		goto err;
+	range->end =3D addr;
+
+err:
+	kfree(str);
+	return rc;
+}
+
+static ssize_t mapping_store(struct device *dev, struct device_attribute *=
attr,
+		const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+	size_t to_alloc;
+	struct range r;
+	ssize_t rc;
+
+	rc =3D range_parse(buf, len, &r);
+	if (rc)
+		return rc;
+
+	rc =3D -ENXIO;
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return rc;
+	}
+	device_lock(dev);
+
+	to_alloc =3D range_len(&r);
+	if (alloc_is_aligned(dev_dax, to_alloc))
+		rc =3D alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+
+	return rc =3D=3D 0 ? len : rc;
+}
+static DEVICE_ATTR_WO(mapping);
+
 static ssize_t align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1175,6 +1236,8 @@ static umode_t dev_dax_visible(struct ko
 		return 0;
 	if (a =3D=3D &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
+	if (a =3D=3D &dev_attr_mapping.attr && is_static(dax_region))
+		return 0;
 	if ((a =3D=3D &dev_attr_align.attr ||
 	     a =3D=3D &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
@@ -1184,6 +1247,7 @@ static umode_t dev_dax_visible(struct ko
 static struct attribute *dev_dax_attributes[] =3D {
 	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
+	&dev_attr_mapping.attr,
 	&dev_attr_target_node.attr,
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.=
patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

