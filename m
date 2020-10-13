Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20980C4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0AD22202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633080;
	bh=sokyfmEtwUI9+oH3PBobfQZhK0pyF3bNg5sSRsusGTU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2m758MGkFIgWIKs+ZU0gLu/8IRTXK+nT5JI14KKdOyn4l91VLQnFoRsJgHR8w3gjP
	 djWk2Te90lXxctvJqTqw9vubdzp0szAYs6iZ78BoE/J7UXbLsjplcBS06p6c+l728F
	 kmCsUUohFf1h0whGkT4SPQLNI2zgItZk+BVBK9m8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgJMXvU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbgJMXvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86F621D81;
        Tue, 13 Oct 2020 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633068;
        bh=sokyfmEtwUI9+oH3PBobfQZhK0pyF3bNg5sSRsusGTU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hpvg8JHO2Omls4zu3pFjKN303dM35vk1eDC+jknYwkZVuwNsn0d4jdjgRz9qzMwXP
         wOrxBfOYBFSrkTD8AaJdYa1vU2Hd1klyD94RhXZYZcN9oeSGtykw8IhthcSpllU7qf
         VxioBQz9X6sAVMVFd1KEZGpom/IZiKKPHvBizc8A=
Date:   Tue, 13 Oct 2020 16:51:06 -0700
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
Subject:  [patch 051/181] device-dax: add a range mapping
 allocation attribute
Message-ID: <20201013235106._mRXUNr8h%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Joao Martins <joao.m.martins@oracle.com>
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
