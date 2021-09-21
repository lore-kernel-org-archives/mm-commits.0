Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EAEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C46C61242
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhIUBCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230220AbhIUBAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Sep 2021 21:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B294560F13;
        Tue, 21 Sep 2021 00:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632185953;
        bh=wCXMTVBil2D3Rb4nhfZciZPEn9QrB5m66pElztXJBSk=;
        h=Date:From:To:Subject:From;
        b=KMVeg+r1tJ85q5ERkOrzBq/ptT7mOT3l2i+4gfAt7OPzOOgDCVyAuIyH8NzRnp8Hg
         mUm9nuJj2H4jVPTxGRPeIvh0D1AOP+jEJJ67nx9OJGBxhxrQ6TS7g6HNvV858/BkDh
         vFmViXt7fFJkOQddmRieN/0ZF3gGTxsC6f3KAZYI=
Date:   Mon, 20 Sep 2021 17:59:12 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, arnd@arndb.de, dan.j.williams@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, guohanjun@huawei.com,
        jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        rafael.j.wysocki@intel.com
Subject:  +
 kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch added to -mm
 tree
Message-ID: <20210921005912.YzBQdPOM-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: clean up and optimize iomem_is_exclusive()
has been added to the -mm tree.  Its filename is
     kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

