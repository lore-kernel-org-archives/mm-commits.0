Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842ACC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 485FC2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633014;
	bh=b2riYjwzS+givoVBdqMhZW4XZjjVzZvYgtfyuUM1dVU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wr8fhqGk8fZjjvjNFCd7lmJgphmKv8Dch+WUYEfcc6h8cYD1n5MCpzxNSehK/cjcV
	 fPueeR+La3BAUwOXomTXye50H0j6mJ3yrOAvNccl//JK8JoiP2A2h+RQ2c6Sy3B2a+
	 WW3fzyDcij8gaFtEa/6cYhHfvy2R7VioD4cMzg60=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgJMXuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730274AbgJMXtv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D1021D7A;
        Tue, 13 Oct 2020 23:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632990;
        bh=b2riYjwzS+givoVBdqMhZW4XZjjVzZvYgtfyuUM1dVU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f0HebLJQeWWHEkti0UjHMsgUC8hUfHCVTJJjG4m4G/PG7ecEBKFblylOmToIPrQ0m
         iTP3zSRGC5llE2klEEHbTcdHXSvvpWP7PsSgmBshSK1gImxeOocvVzUXIXX+0j8ysd
         FIZvwSsshvDrVjipHbNZmdgq4GhDAF4d2ElSTaxA=
Date:   Tue, 13 Oct 2020 16:49:48 -0700
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
Subject:  [patch 036/181] device-dax/kmem: introduce
 dax_kmem_range()
Message-ID: <20201013234948.0n0HXOPDK%akpm@linux-foundation.org>
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
Subject: device-dax/kmem: introduce dax_kmem_range()

Towards removing the mode specific @dax_kmem_res attribute from the
generic 'struct dev_dax', and preparing for multi-range support, teach the
driver to calculate the hotplug range from the device range.  The hotplug
range is the trivially calculated memory-block-size aligned version of the
device range.

Link: https://lkml.kernel.org/r/160106111109.30709.3173462396758431559.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
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

 drivers/dax/kmem.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- a/drivers/dax/kmem.c~device-dax-kmem-introduce-dax_kmem_range
+++ a/drivers/dax/kmem.c
@@ -19,13 +19,20 @@ static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
 static bool any_hotremove_failed;
=20
+static struct range dax_kmem_range(struct dev_dax *dev_dax)
+{
+	struct range range;
+
+	/* memory-block align the hotplug range */
+	range.start =3D ALIGN(dev_dax->range.start, memory_block_size_bytes());
+	range.end =3D ALIGN_DOWN(dev_dax->range.end + 1, memory_block_size_bytes(=
)) - 1;
+	return range;
+}
+
 int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
-	struct range *range =3D &dev_dax->range;
-	resource_size_t kmem_start;
-	resource_size_t kmem_size;
-	resource_size_t kmem_end;
+	struct range range =3D dax_kmem_range(dev_dax);
 	struct resource *new_res;
 	const char *new_res_name;
 	int numa_node;
@@ -44,25 +51,14 @@ int dev_dax_kmem_probe(struct device *de
 		return -EINVAL;
 	}
=20
-	/* Hotplug starting at the beginning of the next block: */
-	kmem_start =3D ALIGN(range->start, memory_block_size_bytes());
-
-	kmem_size =3D range_len(range);
-	/* Adjust the size down to compensate for moving up kmem_start: */
-	kmem_size -=3D kmem_start - range->start;
-	/* Align the size down to cover only complete blocks: */
-	kmem_size &=3D ~(memory_block_size_bytes() - 1);
-	kmem_end =3D kmem_start + kmem_size;
-
 	new_res_name =3D kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!new_res_name)
 		return -ENOMEM;
=20
 	/* Region is permanently reserved if hotremove fails. */
-	new_res =3D request_mem_region(kmem_start, kmem_size, new_res_name);
+	new_res =3D request_mem_region(range.start, range_len(&range), new_res_na=
me);
 	if (!new_res) {
-		dev_warn(dev, "could not reserve region [%pa-%pa]\n",
-			 &kmem_start, &kmem_end);
+		dev_warn(dev, "could not reserve region [%#llx-%#llx]\n", range.start, r=
ange.end);
 		kfree(new_res_name);
 		return -EBUSY;
 	}
@@ -96,9 +92,8 @@ int dev_dax_kmem_probe(struct device *de
 static int dev_dax_kmem_remove(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct range range =3D dax_kmem_range(dev_dax);
 	struct resource *res =3D dev_dax->dax_kmem_res;
-	resource_size_t kmem_start =3D res->start;
-	resource_size_t kmem_size =3D resource_size(res);
 	const char *res_name =3D res->name;
 	int rc;
=20
@@ -108,12 +103,11 @@ static int dev_dax_kmem_remove(struct de
 	 * there is no way to hotremove this memory until reboot because device
 	 * unbind will succeed even if we return failure.
 	 */
-	rc =3D remove_memory(dev_dax->target_node, kmem_start, kmem_size);
+	rc =3D remove_memory(dev_dax->target_node, range.start, range_len(&range)=
);
 	if (rc) {
 		any_hotremove_failed =3D true;
-		dev_err(dev,
-			"DAX region %pR cannot be hotremoved until the next reboot\n",
-			res);
+		dev_err(dev, "%#llx-%#llx cannot be hotremoved until the next reboot\n",
+				range.start, range.end);
 		return rc;
 	}
=20
_
