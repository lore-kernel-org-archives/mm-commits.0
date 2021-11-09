Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD91C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C36619E4
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhKICid (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 373A4619BB;
        Tue,  9 Nov 2021 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425347;
        bh=inCnQFb/IvDUavgi+SPn/so5P2/PqppuY4xydxA1TEE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pk21O7XU6/bA2uUpVd4l60rlI4ohnECtlHA2h4UHbpta6py/YP3s0TJKEvttm92vr
         v9AhPc1cDWJf6UKEqcgaibCdLOMS9ZuGdYTZ/yWa31Sx1Ge5AACZkvbarq91Z1jGuD
         5eSGXOmh+pkPqefDkGyDV3cJMFSfu0Iq4PgtvykI=
Date:   Mon, 08 Nov 2021 18:35:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andy.shevchenko@gmail.com,
        arnd@arndb.de, dan.j.williams@intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com, torvalds@linux-foundation.org
Subject:  [patch 82/87] kernel/resource: clean up and optimize
 iomem_is_exclusive()
Message-ID: <20211109023546.m0vUcAn2C%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: clean up and optimize iomem_is_exclusive()

Patch series "virtio-mem: disallow mapping virtio-mem memory via /dev/mem", v5.

Let's add the basic infrastructure to exclude some physical memory regions
marked as "IORESOURCE_SYSTEM_RAM" completely from /dev/mem access, even
though they are not marked IORESOURCE_BUSY and even though "iomem=relaxed"
is set.  Resource IORESOURCE_EXCLUSIVE for that purpose instead of adding
new flags to express something similar to "soft-busy" or "not busy yet,
but already prepared by a driver and not to be mapped by user space".

Use it for virtio-mem, to disallow mapping any virtio-mem memory via
/dev/mem to user space after the virtio-mem driver was loaded.


This patch (of 3):

We end up traversing subtrees of ranges we are not interested in; let's
optimize this case, skipping such subtrees, cleaning up the function a
bit.

For example, in the following configuration (/proc/iomem):

00000000-00000fff : Reserved
00001000-00057fff : System RAM
00058000-00058fff : Reserved
00059000-0009cfff : System RAM
0009d000-000fffff : Reserved
   000a0000-000bffff : PCI Bus 0000:00
   000c0000-000c3fff : PCI Bus 0000:00
   000c4000-000c7fff : PCI Bus 0000:00
   000c8000-000cbfff : PCI Bus 0000:00
   000cc000-000cffff : PCI Bus 0000:00
   000d0000-000d3fff : PCI Bus 0000:00
   000d4000-000d7fff : PCI Bus 0000:00
   000d8000-000dbfff : PCI Bus 0000:00
   000dc000-000dffff : PCI Bus 0000:00
   000e0000-000e3fff : PCI Bus 0000:00
   000e4000-000e7fff : PCI Bus 0000:00
   000e8000-000ebfff : PCI Bus 0000:00
   000ec000-000effff : PCI Bus 0000:00
   000f0000-000fffff : PCI Bus 0000:00
     000f0000-000fffff : System ROM
00100000-3fffffff : System RAM
40000000-403fffff : Reserved
   40000000-403fffff : pnp 00:00
40400000-80a79fff : System RAM
...

We don't have to look at any children of "0009d000-000fffff : Reserved" if
we can just skip these 15 items directly because the parent range is not
of interest.

Link: https://lkml.kernel.org/r/20210920142856.17758-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210920142856.17758-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/kernel/resource.c~kernel-resource-clean-up-and-optimize-iomem_is_exclusive
+++ a/kernel/resource.c
@@ -73,6 +73,18 @@ static struct resource *next_resource(st
 	return p->sibling;
 }
 
+static struct resource *next_resource_skip_children(struct resource *p)
+{
+	while (!p->sibling && p->parent)
+		p = p->parent;
+	return p->sibling;
+}
+
+#define for_each_resource(_root, _p, _skip_children) \
+	for ((_p) = (_root)->child; (_p); \
+	     (_p) = (_skip_children) ? next_resource_skip_children(_p) : \
+				       next_resource(_p))
+
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -1712,10 +1724,9 @@ static int strict_iomem_checks;
  */
 bool iomem_is_exclusive(u64 addr)
 {
-	struct resource *p = &iomem_resource;
-	bool err = false;
-	loff_t l;
+	bool skip_children = false, err = false;
 	int size = PAGE_SIZE;
+	struct resource *p;
 
 	if (!strict_iomem_checks)
 		return false;
@@ -1723,15 +1734,19 @@ bool iomem_is_exclusive(u64 addr)
 	addr = addr & PAGE_MASK;
 
 	read_lock(&resource_lock);
-	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/*
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
 		 */
 		if (p->start >= addr + size)
 			break;
-		if (p->end < addr)
+		if (p->end < addr) {
+			skip_children = true;
 			continue;
+		}
+		skip_children = false;
+
 		/*
 		 * A resource is exclusive if IORESOURCE_EXCLUSIVE is set
 		 * or CONFIG_IO_STRICT_DEVMEM is enabled and the
_
