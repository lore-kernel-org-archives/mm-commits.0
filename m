Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B64C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECF820B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817730;
	bh=g1gmOKcB2in1tpEoA+2x5wQGSUS1dmPFncyBHo0bigU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rMaTyRPTyd1m5X+Dr2x6ijMU/CAaegOluVLvDgcfbXUHl1/6vD0cYrIOU3V9SAPzm
	 KwxT+aOhN5rK9TscegzQ6doTMRRhIfU3sBOjkUKFeKEif5CMPpHxrilZHNpv6rjGqC
	 zEL415b+YqCJWQkieWYOjXjvG1jUZvN8Sqj4L018=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbgJPDIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222FD20878;
        Fri, 16 Oct 2020 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817726;
        bh=g1gmOKcB2in1tpEoA+2x5wQGSUS1dmPFncyBHo0bigU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mxeo1FHX8i+u6f7mBeA4MwUS8iTyPlETjLb2HAUYW4LQiNXq560j04aTN6O/WFDuQ
         YpPPP5bNY4SW2qGqUzx0vpwG0lzgPYyR+FvPEtHoTTsDOXNMJsbxuLRVDP9vkdEpcr
         yNNcm0vNLznty4IgU1FWa/8ZOX+PHrQuslkpaguQ=
Date:   Thu, 15 Oct 2020 20:08:44 -0700
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
        nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        wei.liu@kernel.org
Subject:  [patch 072/156] mm/memory_hotplug: prepare passing flags
 to add_memory() and friends
Message-ID: <20201016030844.80UyKi9n7%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: prepare passing flags to add_memory() and frien=
ds

We soon want to pass flags, e.g., to mark added System RAM resources.=20
mergeable.  Prepare for that.

This patch is based on a similar patch by Oscar Salvador:

https://lkml.kernel.org/r/20190625075227.15193-3-osalvador@suse.de

Link: https://lkml.kernel.org/r/20200911103459.10306-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com> # Xen related part
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Julien Grall <julien@xen.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/memtrace.c       |    2 -
 arch/powerpc/platforms/pseries/hotplug-memory.c |    2 -
 drivers/acpi/acpi_memhotplug.c                  |    3 +-
 drivers/base/memory.c                           |    3 +-
 drivers/dax/kmem.c                              |    2 -
 drivers/hv/hv_balloon.c                         |    2 -
 drivers/s390/char/sclp_cmd.c                    |    2 -
 drivers/virtio/virtio_mem.c                     |    2 -
 drivers/xen/balloon.c                           |    2 -
 include/linux/memory_hotplug.h                  |   16 ++++++++++----
 mm/memory_hotplug.c                             |   14 ++++++------
 11 files changed, 30 insertions(+), 20 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c~mm-memory_hotplug-prepare-p=
assing-flags-to-add_memory-and-friends
+++ a/arch/powerpc/platforms/powernv/memtrace.c
@@ -224,7 +224,7 @@ static int memtrace_online(void)
 			ent->mem =3D 0;
 		}
=20
-		if (add_memory(ent->nid, ent->start, ent->size)) {
+		if (add_memory(ent->nid, ent->start, ent->size, MHP_NONE)) {
 			pr_err("Failed to add trace memory to node %d\n",
 				ent->nid);
 			ret +=3D 1;
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-memory_hotplug-pre=
pare-passing-flags-to-add_memory-and-friends
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -606,7 +606,7 @@ static int dlpar_add_lmb(struct drmem_lm
 	block_sz =3D memory_block_size_bytes();
=20
 	/* Add the memory */
-	rc =3D __add_memory(lmb->nid, lmb->base_addr, block_sz);
+	rc =3D __add_memory(lmb->nid, lmb->base_addr, block_sz, MHP_NONE);
 	if (rc) {
 		invalidate_lmb_associativity_index(lmb);
 		return rc;
--- a/drivers/acpi/acpi_memhotplug.c~mm-memory_hotplug-prepare-passing-flag=
s-to-add_memory-and-friends
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -194,7 +194,8 @@ static int acpi_memory_enable_device(str
 		if (node < 0)
 			node =3D memory_add_physaddr_to_nid(info->start_addr);
=20
-		result =3D __add_memory(node, info->start_addr, info->length);
+		result =3D __add_memory(node, info->start_addr, info->length,
+				      MHP_NONE);
=20
 		/*
 		 * If the memory block has been used by the kernel, add_memory()
--- a/drivers/base/memory.c~mm-memory_hotplug-prepare-passing-flags-to-add_=
memory-and-friends
+++ a/drivers/base/memory.c
@@ -432,7 +432,8 @@ static ssize_t probe_store(struct device
=20
 	nid =3D memory_add_physaddr_to_nid(phys_addr);
 	ret =3D __add_memory(nid, phys_addr,
-			   MIN_MEMORY_BLOCK_SIZE * sections_per_block);
+			   MIN_MEMORY_BLOCK_SIZE * sections_per_block,
+			   MHP_NONE);
=20
 	if (ret)
 		goto out;
--- a/drivers/dax/kmem.c~mm-memory_hotplug-prepare-passing-flags-to-add_mem=
ory-and-friends
+++ a/drivers/dax/kmem.c
@@ -109,7 +109,7 @@ static int dev_dax_kmem_probe(struct dev
 		 * this as RAM automatically.
 		 */
 		rc =3D add_memory_driver_managed(numa_node, range.start,
-				range_len(&range), kmem_name);
+				range_len(&range), kmem_name, MHP_NONE);
=20
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
--- a/drivers/hv/hv_balloon.c~mm-memory_hotplug-prepare-passing-flags-to-ad=
d_memory-and-friends
+++ a/drivers/hv/hv_balloon.c
@@ -726,7 +726,7 @@ static void hv_mem_hot_add(unsigned long
=20
 		nid =3D memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret =3D add_memory(nid, PFN_PHYS((start_pfn)),
-				(HA_CHUNK << PAGE_SHIFT));
+				(HA_CHUNK << PAGE_SHIFT), MHP_NONE);
=20
 		if (ret) {
 			pr_err("hot_add memory failed error is %d\n", ret);
--- a/drivers/s390/char/sclp_cmd.c~mm-memory_hotplug-prepare-passing-flags-=
to-add_memory-and-friends
+++ a/drivers/s390/char/sclp_cmd.c
@@ -406,7 +406,7 @@ static void __init add_memory_merged(u16
 	if (!size)
 		goto skip_add;
 	for (addr =3D start; addr < start + size; addr +=3D block_size)
-		add_memory(0, addr, block_size);
+		add_memory(0, addr, block_size, MHP_NONE);
 skip_add:
 	first_rn =3D rn;
 	num =3D 1;
--- a/drivers/virtio/virtio_mem.c~mm-memory_hotplug-prepare-passing-flags-t=
o-add_memory-and-friends
+++ a/drivers/virtio/virtio_mem.c
@@ -424,7 +424,7 @@ static int virtio_mem_mb_add(struct virt
=20
 	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
 	return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
-					 vm->resource_name);
+					 vm->resource_name, MHP_NONE);
 }
=20
 /*
--- a/drivers/xen/balloon.c~mm-memory_hotplug-prepare-passing-flags-to-add_=
memory-and-friends
+++ a/drivers/xen/balloon.c
@@ -331,7 +331,7 @@ static enum bp_state reserve_additional_
 	mutex_unlock(&balloon_mutex);
 	/* add_memory_resource() requires the device_hotplug lock */
 	lock_device_hotplug();
-	rc =3D add_memory_resource(nid, resource);
+	rc =3D add_memory_resource(nid, resource, MHP_NONE);
 	unlock_device_hotplug();
 	mutex_lock(&balloon_mutex);
=20
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-prepare-passing-flag=
s-to-add_memory-and-friends
+++ a/include/linux/memory_hotplug.h
@@ -57,6 +57,12 @@ enum {
 	MMOP_ONLINE_MOVABLE,
 };
=20
+/* Flags for add_memory() and friends to specify memory hotplug details. */
+typedef int __bitwise mhp_t;
+
+/* No special request */
+#define MHP_NONE		((__force mhp_t)0)
+
 /*
  * Extended parameters for memory hotplug:
  * altmap: alternative allocator for memmap array (optional)
@@ -339,11 +345,13 @@ extern void clear_zone_contiguous(struct
=20
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void __ref free_area_init_core_hotplug(int nid);
-extern int __add_memory(int nid, u64 start, u64 size);
-extern int add_memory(int nid, u64 start, u64 size);
-extern int add_memory_resource(int nid, struct resource *resource);
+extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
+extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
+extern int add_memory_resource(int nid, struct resource *resource,
+			       mhp_t mhp_flags);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
-				     const char *resource_name);
+				     const char *resource_name,
+				     mhp_t mhp_flags);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_=
pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype);
--- a/mm/memory_hotplug.c~mm-memory_hotplug-prepare-passing-flags-to-add_me=
mory-and-friends
+++ a/mm/memory_hotplug.c
@@ -1039,7 +1039,7 @@ static int online_memory_block(struct me
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int __ref add_memory_resource(int nid, struct resource *res)
+int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_fla=
gs)
 {
 	struct mhp_params params =3D { .pgprot =3D PAGE_KERNEL };
 	u64 start, size;
@@ -1119,7 +1119,7 @@ error:
 }
=20
 /* requires device_hotplug_lock, see add_memory_resource() */
-int __ref __add_memory(int nid, u64 start, u64 size)
+int __ref __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
 	int ret;
@@ -1128,18 +1128,18 @@ int __ref __add_memory(int nid, u64 star
 	if (IS_ERR(res))
 		return PTR_ERR(res);
=20
-	ret =3D add_memory_resource(nid, res);
+	ret =3D add_memory_resource(nid, res, mhp_flags);
 	if (ret < 0)
 		release_memory_resource(res);
 	return ret;
 }
=20
-int add_memory(int nid, u64 start, u64 size)
+int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	int rc;
=20
 	lock_device_hotplug();
-	rc =3D __add_memory(nid, start, size);
+	rc =3D __add_memory(nid, start, size, mhp_flags);
 	unlock_device_hotplug();
=20
 	return rc;
@@ -1168,7 +1168,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  * "System RAM ($DRIVER)".
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name)
+			      const char *resource_name, mhp_t mhp_flags)
 {
 	struct resource *res;
 	int rc;
@@ -1186,7 +1186,7 @@ int add_memory_driver_managed(int nid, u
 		goto out_unlock;
 	}
=20
-	rc =3D add_memory_resource(nid, res);
+	rc =3D add_memory_resource(nid, res, mhp_flags);
 	if (rc < 0)
 		release_memory_resource(res);
=20
_
