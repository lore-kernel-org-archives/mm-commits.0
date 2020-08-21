Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E04CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D13C0207DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052213;
	bh=oPqMg2xTSwEPziU1beOz2xEYrKFdcAjQkusuYnzZ5sk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m/DfuTFrXI6XTYlJqqjHIPcra+bbK0b9vJB1NSLGM0XWgqqnNaytyECsV9xqVeD8l
	 US+5Xvlo9PYVQdNDO0yrg12YJ3z9wpziu4SncM68ACSfNN1l4PTZqnzWRE3GJdiVmE
	 +KMogln5pGIbofhwCqo+yfQfKWgUmv4Oj2gvVUR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHUXXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHUXXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:23:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFB5207C3;
        Fri, 21 Aug 2020 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052211;
        bh=oPqMg2xTSwEPziU1beOz2xEYrKFdcAjQkusuYnzZ5sk=;
        h=Date:From:To:Subject:From;
        b=XcoKjPwosfJ3dh6D5jLSCJy7ysx9ap3+huddyWenAVxt2j7NYeTRH6KX2EkZItfJx
         xScR/k9zOnU93q9VxxP1WPJItmQUq4sTDYGorC2zpWhXeBDqEmN6hoL15UqJPdcq9Q
         gX6dTRofVYh4zymJJ9SJ6yDfMzGHAdW2jqlTEhi4=
Date:   Fri, 21 Aug 2020 16:23:28 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        ira.weiny@intel.com, jgg@mellanox.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  + device-dax-kill-dax_kmem_res.patch added to -mm tree
Message-ID: <20200821232328.W4mQ4Dns5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: kill dax_kmem_res
has been added to the -mm tree.  Its filename is
     device-dax-kill-dax_kmem_res.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-kill-dax_kmem_res.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-kill-dax_kmem_res.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: kill dax_kmem_res

Several related issues around this unneeded attribute:

- The dax_kmem_res property allows the kmem driver to stash the adjusted
  resource range that was used for the hotplug operation, but that can be
  recalculated from the original base range.

- kmem is using an open coded release_resource() + kfree() when an
  idiomatic release_mem_region() is sufficient.

- The driver managed resource need only manage the busy flag.  Other
  flags are of no concern to the kmem driver.  In fact if kmem inherits
  some memory range that add_memory_driver_managed() rejects that is a
  memory-hotplug-core policy that the driver is in no position to
  override.

- The implementation trusts that failed remove_memory() results in the
  entire resource range remaining pinned busy.  The driver need not make
  that layering violation assumption and just maintain the busy state in
  its local resource.

- The "Hot-remove not yet implemented." comment is stale since hotremove
  support is now included.

Link: https://lkml.kernel.org/r/159643100485.4062302.976628339798536960.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax-private.h |    3 
 drivers/dax/kmem.c        |  123 ++++++++++++++++--------------------
 2 files changed, 58 insertions(+), 68 deletions(-)

--- a/drivers/dax/dax-private.h~device-dax-kill-dax_kmem_res
+++ a/drivers/dax/dax-private.h
@@ -42,8 +42,6 @@ struct dax_region {
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @range: resource range for the instance
- * @dax_mem_res: physical address range of hotadded DAX memory
- * @dax_mem_name: name for hotadded DAX memory via add_memory_driver_managed()
  */
 struct dev_dax {
 	struct dax_region *region;
@@ -52,7 +50,6 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	struct range range;
-	struct resource *dax_kmem_res;
 };
 
 static inline u64 range_len(struct range *range)
--- a/drivers/dax/kmem.c~device-dax-kill-dax_kmem_res
+++ a/drivers/dax/kmem.c
@@ -19,16 +19,24 @@ static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
 static bool any_hotremove_failed;
 
+static struct range dax_kmem_range(struct dev_dax *dev_dax)
+{
+	struct range range;
+
+	/* memory-block align the hotplug range */
+	range.start = ALIGN(dev_dax->range.start, memory_block_size_bytes());
+	range.end = ALIGN_DOWN(dev_dax->range.end + 1,
+			memory_block_size_bytes()) - 1;
+	return range;
+}
+
 int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
-	struct range *range = &dev_dax->range;
-	resource_size_t kmem_start;
-	resource_size_t kmem_size;
-	resource_size_t kmem_end;
-	struct resource *new_res;
-	const char *new_res_name;
-	int numa_node;
+	struct range range = dax_kmem_range(dev_dax);
+	int numa_node = dev_dax->target_node;
+	struct resource *res;
+	char *res_name;
 	int rc;
 
 	/*
@@ -37,109 +45,94 @@ int dev_dax_kmem_probe(struct device *de
 	 * could be mixed in a node with faster memory, causing
 	 * unavoidable performance issues.
 	 */
-	numa_node = dev_dax->target_node;
 	if (numa_node < 0) {
 		dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
 				numa_node);
 		return -EINVAL;
 	}
 
-	/* Hotplug starting at the beginning of the next block: */
-	kmem_start = ALIGN(range->start, memory_block_size_bytes());
-
-	kmem_size = range_len(range);
-	/* Adjust the size down to compensate for moving up kmem_start: */
-	kmem_size -= kmem_start - range->start;
-	/* Align the size down to cover only complete blocks: */
-	kmem_size &= ~(memory_block_size_bytes() - 1);
-	kmem_end = kmem_start + kmem_size;
-
-	new_res_name = kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!new_res_name)
+	res_name = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!res_name)
 		return -ENOMEM;
 
-	/* Region is permanently reserved if hotremove fails. */
-	new_res = request_mem_region(kmem_start, kmem_size, new_res_name);
-	if (!new_res) {
-		dev_warn(dev, "could not reserve region [%pa-%pa]\n",
-			 &kmem_start, &kmem_end);
-		kfree(new_res_name);
+	res = request_mem_region(range.start, range_len(&range), res_name);
+	if (!res) {
+		dev_warn(dev, "could not reserve region [%#llx-%#llx]\n",
+				range.start, range.end);
+		kfree(res_name);
 		return -EBUSY;
 	}
 
 	/*
-	 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
-	 * so that add_memory() can add a child resource.  Do not
-	 * inherit flags from the parent since it may set new flags
-	 * unknown to us that will break add_memory() below.
+	 * Temporarily clear busy to allow add_memory_driver_managed()
+	 * to claim it.
 	 */
-	new_res->flags = IORESOURCE_SYSTEM_RAM;
+	res->flags &= ~IORESOURCE_BUSY;
 
 	/*
 	 * Ensure that future kexec'd kernels will not treat this as RAM
 	 * automatically.
 	 */
-	rc = add_memory_driver_managed(numa_node, new_res->start,
-				       resource_size(new_res), kmem_name);
+	rc = add_memory_driver_managed(numa_node, res->start,
+				       resource_size(res), kmem_name);
+
+	res->flags |= IORESOURCE_BUSY;
 	if (rc) {
-		release_resource(new_res);
-		kfree(new_res);
-		kfree(new_res_name);
+		release_mem_region(range.start, range_len(&range));
+		kfree(res_name);
 		return rc;
 	}
-	dev_dax->dax_kmem_res = new_res;
+
+	dev_set_drvdata(dev, res_name);
 
 	return 0;
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int dev_dax_kmem_remove(struct device *dev)
+static void dax_kmem_release(struct dev_dax *dev_dax)
 {
-	struct dev_dax *dev_dax = to_dev_dax(dev);
-	struct resource *res = dev_dax->dax_kmem_res;
-	resource_size_t kmem_start = res->start;
-	resource_size_t kmem_size = resource_size(res);
-	const char *res_name = res->name;
 	int rc;
+	struct device *dev = &dev_dax->dev;
+	const char *res_name = dev_get_drvdata(dev);
+	struct range range = dax_kmem_range(dev_dax);
 
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
 	 * offline prior to calling this function remove_memory() will fail, and
 	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * unbind will proceed regardless of the remove_memory result.
 	 */
-	rc = remove_memory(dev_dax->target_node, kmem_start, kmem_size);
-	if (rc) {
-		any_hotremove_failed = true;
-		dev_err(dev,
-			"DAX region %pR cannot be hotremoved until the next reboot\n",
-			res);
-		return rc;
+	rc = remove_memory(dev_dax->target_node, range.start, range_len(&range));
+	if (rc == 0) {
+		release_mem_region(range.start, range_len(&range));
+		dev_set_drvdata(dev, NULL);
+		kfree(res_name);
+		return;
 	}
 
-	/* Release and free dax resources */
-	release_resource(res);
-	kfree(res);
-	kfree(res_name);
-	dev_dax->dax_kmem_res = NULL;
-
-	return 0;
+	any_hotremove_failed = true;
+	dev_err(dev, "%#llx-%#llx cannot be hotremoved until the next reboot\n",
+			range.start, range.end);
 }
 #else
-static int dev_dax_kmem_remove(struct device *dev)
+static void dax_kmem_release(struct dev_dax *dev_dax)
 {
 	/*
-	 * Without hotremove purposely leak the request_mem_region() for the
-	 * device-dax range and return '0' to ->remove() attempts. The removal
-	 * of the device from the driver always succeeds, but the region is
-	 * permanently pinned as reserved by the unreleased
-	 * request_mem_region().
+	 * Without hotremove purposely leak the request_mem_region() for
+	 * the device-dax range attempts. The removal of the device from
+	 * the driver always succeeds, but the region is permanently
+	 * pinned as reserved by the unreleased request_mem_region().
 	 */
 	any_hotremove_failed = true;
-	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+static int dev_dax_kmem_remove(struct device *dev)
+{
+	dax_kmem_release(to_dev_dax(dev));
+	return 0;
+}
+
 static struct dax_device_driver device_dax_kmem_driver = {
 	.drv = {
 		.probe = dev_dax_kmem_probe,
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
device-dax-kill-dax_kmem_res.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.patch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch

