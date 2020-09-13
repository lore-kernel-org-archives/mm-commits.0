Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71F9C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9B421974
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599955279;
	bh=pcK4QyiAmY6N3Fk3xeStAIEre91oVs2tkF+qOVl35UM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ze6fZr3Y+xf7H+qU02YUhUlGo9tzygVsk62Luonqwi+hyl1vfudsO2oSe8enpyqtt
	 iPOBg9/C+NwOer9LStPU9VrWfxv3NGgCQ1pVh6ZRAWeRRndr1OJJU6A7PzxT4LobVz
	 JfLgK7EmI7XPCDiBPlI/GUiNwfEw+gDCnps0NcuM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgIMABS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgIMAAv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:00:51 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DAA21655;
        Sun, 13 Sep 2020 00:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599955250;
        bh=pcK4QyiAmY6N3Fk3xeStAIEre91oVs2tkF+qOVl35UM=;
        h=Date:From:To:Subject:From;
        b=bb03xfgxbw3NFZTxBReHxZ01bXBtWeudrpazgHxAJtwtyKEJYiLFLjUtXu/TUWVLg
         OKzkZY8g5V6Ffe1LNAQ0IxA+gCB8nsaUk/5Ui9ebG+t3Pd57zuaL4WbIf97WXupW5I
         sz1EOz57I2li/uH4fuj+sCGu6XfbaA0ZFEwiHCks=
Date:   Sat, 12 Sep 2020 17:00:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wei.liu@kernel.org,
        vishal.l.verma@intel.com, tglx@linutronix.de,
        sthemmin@microsoft.com, sstabellini@kernel.org,
        roger.pau@citrix.com, rjw@rjwysocki.net,
        richardw.yang@linux.intel.com, paulus@samba.org,
        pankaj.gupta.linux@gmail.com, oohall@gmail.com,
        nathanl@linux.ibm.com, mst@redhat.com, mpe@ellerman.id.au,
        mhocko@suse.com, lpechacek@suse.cz, leobras.c@gmail.com,
        lenb@kernel.org, kys@microsoft.com, kernelfans@gmail.com,
        keescook@chromium.org, julien@xen.org, jgross@suse.com,
        jgg@ziepe.ca, jasowang@redhat.com, hca@linux.ibm.com,
        haiyangz@microsoft.com, gregkh@linuxfoundation.org,
        gor@linux.ibm.com, ebiederm@xmission.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, borntraeger@de.ibm.com,
        boris.ostrovsky@oracle.com, bhe@redhat.com,
        benh@kernel.crashing.org, ardb@kernel.org, anton@ozlabs.org,
        david@redhat.com
Subject:  +
 mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch added
 to -mm tree
Message-ID: <20200913000048.mQdV-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: prepare passing flags to add_memory() and =
friends
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-prepare-pas=
sing-flags-to-add_memory-and-friends.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-prepare-pas=
sing-flags-to-add_memory-and-friends.patch

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
From: David Hildenbrand <david@redhat.com>
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
@@ -207,7 +207,8 @@ static int acpi_memory_enable_device(str
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
@@ -95,7 +95,7 @@ int dev_dax_kmem_probe(struct dev_dax *d
 		 * this as RAM automatically.
 		 */
 		rc =3D add_memory_driver_managed(numa_node, range.start,
-				range_len(&range), kmem_name);
+				range_len(&range), kmem_name, MHP_NONE);
=20
 		res->flags |=3D IORESOURCE_BUSY;
 		if (rc) {
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
@@ -1118,7 +1118,7 @@ error:
 }
=20
 /* requires device_hotplug_lock, see add_memory_resource() */
-int __ref __add_memory(int nid, u64 start, u64 size)
+int __ref __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
 	int ret;
@@ -1127,18 +1127,18 @@ int __ref __add_memory(int nid, u64 star
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
@@ -1167,7 +1167,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  * "System RAM ($DRIVER)".
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name)
+			      const char *resource_name, mhp_t mhp_flags)
 {
 	struct resource *res;
 	int rc;
@@ -1185,7 +1185,7 @@ int add_memory_driver_managed(int nid, u
 		goto out_unlock;
 	}
=20
-	rc =3D add_memory_resource(nid, res);
+	rc =3D add_memory_resource(nid, res, mhp_flags);
 	if (rc < 0)
 		release_memory_resource(res);
=20
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_=
isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.pat=
ch
kernel-resource-make-release_mem_region_adjustable-never-fail.patch
kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch
mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch
mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ram-res=
ources.patch
virtio-mem-try-to-merge-system-ram-resources.patch
xen-balloon-try-to-merge-system-ram-resources.patch
hv_balloon-try-to-merge-system-ram-resources.patch

