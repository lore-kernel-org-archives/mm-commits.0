Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C01AC12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E86C610A7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhGNXrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 19:47:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD7261106;
        Wed, 14 Jul 2021 23:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626306291;
        bh=3weiNhW1In8liMLkdriQuc5ai6UaMTTU42CFQVA36B4=;
        h=Date:From:To:Subject:From;
        b=zQfI6MwKarRk+LruWi+lhMPtitV9vH21tvFUswOMSFYLdOYx7om9hkYi2GNRTctQS
         u0jWXWzn+5fmHL14F7zCtAkdjjJZEHCl0bBMAYcebNq8fw2bdvfM54URiwlO0vghF3
         d+D9rPlRNyHHvNKeWVSNe99a+hBOVIxJfYh7cHmE=
Date:   Wed, 14 Jul 2021 16:44:49 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        anton@ozlabs.org, ardb@kernel.org, bauerman@linux.ibm.com,
        benh@kernel.crashing.org, bhe@redhat.com, borntraeger@de.ibm.com,
        bp@alien8.de, catalin.marinas@arm.com, cheloha@linux.ibm.com,
        christophe.leroy@c-s.fr, dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, jasowang@redhat.com, joe@perches.com,
        justin.he@arm.com, ldufour@linux.ibm.com, lenb@kernel.org,
        luto@kernel.org, mhocko@kernel.org, michel@lespinasse.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, nathanl@linux.ibm.com, npiggin@gmail.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@ionos.com, pasha.tatashin@soleen.com,
        paulus@samba.org, peterz@infradead.org, pmorel@linux.ibm.com,
        rafael.j.wysocki@intel.com, richard.weiyang@linux.alibaba.com,
        rjw@rjwysocki.net, rppt@kernel.org, slyfox@gentoo.org,
        tglx@linutronix.de, vbabka@suse.cz, vishal.l.verma@intel.com,
        vkuznets@redhat.com, wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  +
 mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
 added to -mm tree
Message-ID: <20210714234449.P1ZXNTyuO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove nid parameter from remove_memory() and friends
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch

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
Subject: mm/memory_hotplug: remove nid parameter from remove_memory() and friends

There is only a single user remaining.  We can simply lookup the nid only
used for node offlining purposes when walking our memory blocks.  We don't
expect to remove multi-nid ranges; and if we'd ever do, we most probably
don't care about removing multi-nid ranges that actually result in empty
nodes.

If ever required, we can detect the "multi-nid" scenario and simply try
offlining all online nodes.

Link: https://lkml.kernel.org/r/20210712124052.26491-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    9 ++--
 drivers/acpi/acpi_memhotplug.c                  |    7 ---
 drivers/dax/kmem.c                              |    3 -
 drivers/virtio/virtio_mem.c                     |    4 +-
 include/linux/memory_hotplug.h                  |   10 ++---
 mm/memory_hotplug.c                             |   28 ++++++++------
 6 files changed, 30 insertions(+), 31 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -284,7 +284,7 @@ static int pseries_remove_memblock(unsig
 {
 	unsigned long block_sz, start_pfn;
 	int sections_per_block;
-	int i, nid;
+	int i;
 
 	start_pfn = base >> PAGE_SHIFT;
 
@@ -295,10 +295,9 @@ static int pseries_remove_memblock(unsig
 
 	block_sz = pseries_memory_block_size();
 	sections_per_block = block_sz / MIN_MEMORY_BLOCK_SIZE;
-	nid = memory_add_physaddr_to_nid(base);
 
 	for (i = 0; i < sections_per_block; i++) {
-		__remove_memory(nid, base, MIN_MEMORY_BLOCK_SIZE);
+		__remove_memory(base, MIN_MEMORY_BLOCK_SIZE);
 		base += MIN_MEMORY_BLOCK_SIZE;
 	}
 
@@ -385,7 +384,7 @@ static int dlpar_remove_lmb(struct drmem
 
 	block_sz = pseries_memory_block_size();
 
-	__remove_memory(mem_block->nid, lmb->base_addr, block_sz);
+	__remove_memory(lmb->base_addr, block_sz);
 	put_device(&mem_block->dev);
 
 	/* Update memory regions for memory remove */
@@ -658,7 +657,7 @@ static int dlpar_add_lmb(struct drmem_lm
 
 	rc = dlpar_online_lmb(lmb);
 	if (rc) {
-		__remove_memory(nid, lmb->base_addr, block_sz);
+		__remove_memory(lmb->base_addr, block_sz);
 		invalidate_lmb_associativity_index(lmb);
 	} else {
 		lmb->flags |= DRCONF_MEM_ASSIGNED;
--- a/drivers/acpi/acpi_memhotplug.c~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -239,19 +239,14 @@ static int acpi_memory_enable_device(str
 
 static void acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
-	acpi_handle handle = mem_device->device->handle;
 	struct acpi_memory_info *info, *n;
-	int nid = acpi_get_node(handle);
 
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (!info->enabled)
 			continue;
 
-		if (nid == NUMA_NO_NODE)
-			nid = memory_add_physaddr_to_nid(info->start_addr);
-
 		acpi_unbind_memory_blocks(info);
-		__remove_memory(nid, info->start_addr, info->length);
+		__remove_memory(info->start_addr, info->length);
 		list_del(&info->list);
 		kfree(info);
 	}
--- a/drivers/dax/kmem.c~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/drivers/dax/kmem.c
@@ -156,8 +156,7 @@ static void dev_dax_kmem_remove(struct d
 		if (rc)
 			continue;
 
-		rc = remove_memory(dev_dax->target_node, range.start,
-				range_len(&range));
+		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			release_resource(data->res[i]);
 			kfree(data->res[i]);
--- a/drivers/virtio/virtio_mem.c~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/drivers/virtio/virtio_mem.c
@@ -677,7 +677,7 @@ static int virtio_mem_remove_memory(stru
 
 	dev_dbg(&vm->vdev->dev, "removing memory: 0x%llx - 0x%llx\n", addr,
 		addr + size - 1);
-	rc = remove_memory(vm->nid, addr, size);
+	rc = remove_memory(addr, size);
 	if (!rc) {
 		atomic64_sub(size, &vm->offline_size);
 		/*
@@ -720,7 +720,7 @@ static int virtio_mem_offline_and_remove
 		"offlining and removing memory: 0x%llx - 0x%llx\n", addr,
 		addr + size - 1);
 
-	rc = offline_and_remove_memory(vm->nid, addr, size);
+	rc = offline_and_remove_memory(addr, size);
 	if (!rc) {
 		atomic64_sub(size, &vm->offline_size);
 		/*
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/include/linux/memory_hotplug.h
@@ -292,9 +292,9 @@ static inline void pgdat_resize_init(str
 
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
-extern int remove_memory(int nid, u64 start, u64 size);
-extern void __remove_memory(int nid, u64 start, u64 size);
-extern int offline_and_remove_memory(int nid, u64 start, u64 size);
+extern int remove_memory(u64 start, u64 size);
+extern void __remove_memory(u64 start, u64 size);
+extern int offline_and_remove_memory(u64 start, u64 size);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -304,12 +304,12 @@ static inline int offline_pages(unsigned
 	return -EINVAL;
 }
 
-static inline int remove_memory(int nid, u64 start, u64 size)
+static inline int remove_memory(u64 start, u64 size)
 {
 	return -EBUSY;
 }
 
-static inline void __remove_memory(int nid, u64 start, u64 size) {}
+static inline void __remove_memory(u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern void set_zone_contiguous(struct zone *zone);
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends
+++ a/mm/memory_hotplug.c
@@ -1738,7 +1738,9 @@ failed_removal:
 static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int ret = !is_memblock_offlined(mem);
+	int *nid = arg;
 
+	*nid = mem->nid;
 	if (unlikely(ret)) {
 		phys_addr_t beginpa, endpa;
 
@@ -1831,12 +1833,12 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
-static int __ref try_remove_memory(int nid, u64 start, u64 size)
+static int __ref try_remove_memory(u64 start, u64 size)
 {
-	int rc = 0;
 	struct vmem_altmap mhp_altmap = {};
 	struct vmem_altmap *altmap = NULL;
 	unsigned long nr_vmemmap_pages;
+	int rc = 0, nid = NUMA_NO_NODE;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -1844,8 +1846,12 @@ static int __ref try_remove_memory(int n
 	 * All memory blocks must be offlined before removing memory.  Check
 	 * whether all memory blocks in question are offline and return error
 	 * if this is not the case.
+	 *
+	 * While at it, determine the nid. Note that if we'd have mixed nodes,
+	 * we'd only try to offline the last determined one -- which is good
+	 * enough for the cases we care about.
 	 */
-	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
+	rc = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
 	if (rc)
 		return rc;
 
@@ -1894,7 +1900,8 @@ static int __ref try_remove_memory(int n
 
 	release_mem_region_adjustable(start, size);
 
-	try_offline_node(nid);
+	if (nid != NUMA_NO_NODE)
+		try_offline_node(nid);
 
 	mem_hotplug_done();
 	return 0;
@@ -1902,7 +1909,6 @@ static int __ref try_remove_memory(int n
 
 /**
  * __remove_memory - Remove memory if every memory block is offline
- * @nid: the node ID
  * @start: physical address of the region to remove
  * @size: size of the region to remove
  *
@@ -1910,14 +1916,14 @@ static int __ref try_remove_memory(int n
  * and online/offline operations before this call, as required by
  * try_offline_node().
  */
-void __remove_memory(int nid, u64 start, u64 size)
+void __remove_memory(u64 start, u64 size)
 {
 
 	/*
 	 * trigger BUG() if some memory is not offlined prior to calling this
 	 * function
 	 */
-	if (try_remove_memory(nid, start, size))
+	if (try_remove_memory(start, size))
 		BUG();
 }
 
@@ -1925,12 +1931,12 @@ void __remove_memory(int nid, u64 start,
  * Remove memory if every memory block is offline, otherwise return -EBUSY is
  * some memory is not offline
  */
-int remove_memory(int nid, u64 start, u64 size)
+int remove_memory(u64 start, u64 size)
 {
 	int rc;
 
 	lock_device_hotplug();
-	rc  = try_remove_memory(nid, start, size);
+	rc = try_remove_memory(start, size);
 	unlock_device_hotplug();
 
 	return rc;
@@ -1990,7 +1996,7 @@ static int try_reonline_memory_block(str
  * unplugged all memory (so it's no longer in use) and want to offline + remove
  * that memory.
  */
-int offline_and_remove_memory(int nid, u64 start, u64 size)
+int offline_and_remove_memory(u64 start, u64 size)
 {
 	const unsigned long mb_count = size / memory_block_size_bytes();
 	uint8_t *online_types, *tmp;
@@ -2026,7 +2032,7 @@ int offline_and_remove_memory(int nid, u
 	 * This cannot fail as it cannot get onlined in the meantime.
 	 */
 	if (!rc) {
-		rc = try_remove_memory(nid, start, size);
+		rc = try_remove_memory(start, size);
 		if (rc)
 			pr_err("%s: Failed to remove memory: %d", __func__, rc);
 	}
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch

