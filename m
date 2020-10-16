Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C8EC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A1620897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817714;
	bh=6p3odBtEO/kPAfAlb2nZGcApF1Fira7pnCiac+FlSCE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iOspQDteCTFizpnTYow2Bk4NQMYMVbkv98UaIirB0HVp5753NyqUxvK8Ff1TsTe36
	 5gtd1bYQbrtsmDQwr4Rn82IZRtu1dIeLSl9lmTb15aCQpzjn/z0NpBFuVWC9WEmpI+
	 ZLyhJy8JKxUGCTKpiWQO2uiHIciVV1kUmDZJBsJc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgJPDId (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDId (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA93020789;
        Fri, 16 Oct 2020 03:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817710;
        bh=6p3odBtEO/kPAfAlb2nZGcApF1Fira7pnCiac+FlSCE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QHR1gGcpGG0RaSqv1spDone/xSnFyOuWDuNUZkJh2vOzkTtMWyWQzY4Q/GenIIe4X
         9aymn25PQQZNcYkUighXLO2rCyHd7v3in0gSJU4WIpFQiiMv124ZfMLfdIrgQ2jylz
         Y3S/lxJsrur4Pt86WIkrMkXpYBJEGRWhF1jFZ14I=
Date:   Thu, 15 Oct 2020 20:08:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, borntraeger@de.ibm.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, david@redhat.com,
        ebiederm@xmission.com, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        hca@linux.ibm.com, jasowang@redhat.com, jgg@ziepe.ca,
        jgross@suse.com, julien@xen.org, keescook@chromium.org,
        kernelfans@gmail.com, kys@microsoft.com, lenb@kernel.org,
        leobras.c@gmail.com, lpechacek@suse.cz, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        natechancellor@gmail.com, nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        wei.liu@kernel.org
Subject:  [patch 069/156] kernel/resource: make
 release_mem_region_adjustable() never fail
Message-ID: <20201016030828.pUiOiY-At%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: make release_mem_region_adjustable() never fail

Patch series "selective merging of system ram resources", v4.

Some add_memory*() users add memory in small, contiguous memory blocks. 
Examples include virtio-mem, hyper-v balloon, and the XEN balloon.

This can quickly result in a lot of memory resources, whereby the actual
resource boundaries are not of interest (e.g., it might be relevant for
DIMMs, exposed via /proc/iomem to user space).  We really want to merge
added resources in this scenario where possible.

Resources are effectively stored in a list-based tree.  Having a lot of
resources not only wastes memory, it also makes traversing that tree more
expensive, and makes /proc/iomem explode in size (e.g., requiring
kexec-tools to manually merge resources when creating a kdump header.  The
current kexec-tools resource count limit does not allow for more than
~100GB of memory with a memory block size of 128MB on x86-64).

Let's allow to selectively merge system ram resources by specifying a new
flag for add_memory*().  Patch #5 contains a /proc/iomem example.  Only
tested with virtio-mem.


This patch (of 8):

Let's make sure splitting a resource on memory hotunplug will never fail. 
This will become more relevant once we merge selected System RAM resources
- then, we'll trigger that case more often on memory hotunplug.

In general, this function is already unlikely to fail.  When we remove
memory, we free up quite a lot of metadata (memmap, page tables, memory
block device, etc.).  The only reason it could really fail would be when
injecting allocation errors.

All other error cases inside release_mem_region_adjustable() seem to be
sanity checks if the function would be abused in different context - let's
add WARN_ON_ONCE() in these cases so we can catch them.

[natechancellor@gmail.com: fix use of ternary condition in release_mem_region_adjustable]
  Link: https://lkml.kernel.org/r/20200922060748.2452056-1-natechancellor@gmail.com
  Link: https://github.com/ClangBuiltLinux/linux/issues/1159
Link: https://lkml.kernel.org/r/20200911103459.10306-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Roger Pau Monn <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 +--
 kernel/resource.c      |   49 ++++++++++++++++++++++-----------------
 mm/memory_hotplug.c    |   22 -----------------
 3 files changed, 31 insertions(+), 44 deletions(-)

--- a/include/linux/ioport.h~kernel-resource-make-release_mem_region_adjustable-never-fail
+++ a/include/linux/ioport.h
@@ -248,8 +248,8 @@ extern struct resource * __request_regio
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int release_mem_region_adjustable(struct resource *, resource_size_t,
-				resource_size_t);
+extern void release_mem_region_adjustable(struct resource *, resource_size_t,
+					  resource_size_t);
 #endif
 
 /* Wrappers for managed devices */
--- a/kernel/resource.c~kernel-resource-make-release_mem_region_adjustable-never-fail
+++ a/kernel/resource.c
@@ -1258,21 +1258,28 @@ EXPORT_SYMBOL(__release_region);
  *   assumes that all children remain in the lower address entry for
  *   simplicity.  Enhance this logic when necessary.
  */
-int release_mem_region_adjustable(struct resource *parent,
-				  resource_size_t start, resource_size_t size)
+void release_mem_region_adjustable(struct resource *parent,
+				   resource_size_t start, resource_size_t size)
 {
+	struct resource *new_res = NULL;
+	bool alloc_nofail = false;
 	struct resource **p;
 	struct resource *res;
-	struct resource *new_res;
 	resource_size_t end;
-	int ret = -EINVAL;
 
 	end = start + size - 1;
-	if ((start < parent->start) || (end > parent->end))
-		return ret;
+	if (WARN_ON_ONCE((start < parent->start) || (end > parent->end)))
+		return;
 
-	/* The alloc_resource() result gets checked later */
-	new_res = alloc_resource(GFP_KERNEL);
+	/*
+	 * We free up quite a lot of memory on memory hotunplug (esp., memap),
+	 * just before releasing the region. This is highly unlikely to
+	 * fail - let's play save and make it never fail as the caller cannot
+	 * perform any error handling (e.g., trying to re-add memory will fail
+	 * similarly).
+	 */
+retry:
+	new_res = alloc_resource(GFP_KERNEL | (alloc_nofail ? __GFP_NOFAIL : 0));
 
 	p = &parent->child;
 	write_lock(&resource_lock);
@@ -1298,7 +1305,6 @@ int release_mem_region_adjustable(struct
 		 * so if we are dealing with them, let us just back off here.
 		 */
 		if (!(res->flags & IORESOURCE_SYSRAM)) {
-			ret = 0;
 			break;
 		}
 
@@ -1315,20 +1321,23 @@ int release_mem_region_adjustable(struct
 			/* free the whole entry */
 			*p = res->sibling;
 			free_resource(res);
-			ret = 0;
 		} else if (res->start == start && res->end != end) {
 			/* adjust the start */
-			ret = __adjust_resource(res, end + 1,
-						res->end - end);
+			WARN_ON_ONCE(__adjust_resource(res, end + 1,
+						       res->end - end));
 		} else if (res->start != start && res->end == end) {
 			/* adjust the end */
-			ret = __adjust_resource(res, res->start,
-						start - res->start);
+			WARN_ON_ONCE(__adjust_resource(res, res->start,
+						       start - res->start));
 		} else {
-			/* split into two entries */
+			/* split into two entries - we need a new resource */
 			if (!new_res) {
-				ret = -ENOMEM;
-				break;
+				new_res = alloc_resource(GFP_ATOMIC);
+				if (!new_res) {
+					alloc_nofail = true;
+					write_unlock(&resource_lock);
+					goto retry;
+				}
 			}
 			new_res->name = res->name;
 			new_res->start = end + 1;
@@ -1339,9 +1348,8 @@ int release_mem_region_adjustable(struct
 			new_res->sibling = res->sibling;
 			new_res->child = NULL;
 
-			ret = __adjust_resource(res, res->start,
-						start - res->start);
-			if (ret)
+			if (WARN_ON_ONCE(__adjust_resource(res, res->start,
+							   start - res->start)))
 				break;
 			res->sibling = new_res;
 			new_res = NULL;
@@ -1352,7 +1360,6 @@ int release_mem_region_adjustable(struct
 
 	write_unlock(&resource_lock);
 	free_resource(new_res);
-	return ret;
 }
 #endif	/* CONFIG_MEMORY_HOTREMOVE */
 
--- a/mm/memory_hotplug.c~kernel-resource-make-release_mem_region_adjustable-never-fail
+++ a/mm/memory_hotplug.c
@@ -1727,26 +1727,6 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
-static void __release_memory_resource(resource_size_t start,
-				      resource_size_t size)
-{
-	int ret;
-
-	/*
-	 * When removing memory in the same granularity as it was added,
-	 * this function never fails. It might only fail if resources
-	 * have to be adjusted or split. We'll ignore the error, as
-	 * removing of memory cannot fail.
-	 */
-	ret = release_mem_region_adjustable(&iomem_resource, start, size);
-	if (ret) {
-		resource_size_t endres = start + size - 1;
-
-		pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
-			&start, &endres, ret);
-	}
-}
-
 static int __ref try_remove_memory(int nid, u64 start, u64 size)
 {
 	int rc = 0;
@@ -1780,7 +1760,7 @@ static int __ref try_remove_memory(int n
 		memblock_remove(start, size);
 	}
 
-	__release_memory_resource(start, size);
+	release_mem_region_adjustable(&iomem_resource, start, size);
 
 	try_offline_node(nid);
 
_
