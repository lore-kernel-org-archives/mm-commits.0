From: akpm@linux-foundation.org
Subject: +
 mm-sparse-never-partially-remove-memmap-for-early-section.patch added to -mm
 tree
Date: Thu, 25 Jun 2020 15:50:40 -0700
Message-ID: <20200625225040.0frkm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403838AbgFYWum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 18:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com, dan.j.williams@intel.com, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/sparse: never partially remove memmap for early section
has been added to the -mm tree.  Its filename is
     mm-sparse-never-partially-remove-memmap-for-early-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-never-partially-remove-memmap-for-early-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-never-partially-remove-memmap-for-early-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/sparse: never partially remove memmap for early section

For early sections, its memmap is handled specially even sub-section is
enabled.  The memmap could only be populated as a whole.

Quoted from the comment of section_activate():

    * The early init code does not consider partially populated
    * initial sections, it simply assumes that memory will never be
    * referenced.  If we hot-add memory into such a section then we
    * do not need to populate the memmap and can simply reuse what
    * is already there.

While current section_deactivate() breaks this rule.  When hot-remove a
sub-section, section_deactivate() would depopulate its memmap.  The
consequence is if we hot-add this subsection again, its memmap never get
proper populated.

We can reproduce the case by following steps:

1. Hacking qemu to allow sub-section early section

:   diff --git a/hw/i386/pc.c b/hw/i386/pc.c
:   index 51b3050d01..c6a78d83c0 100644
:   --- a/hw/i386/pc.c
:   +++ b/hw/i386/pc.c
:   @@ -1010,7 +1010,7 @@ void pc_memory_init(PCMachineState *pcms,
:            }
:
:            machine->device_memory->base =
:   -            ROUND_UP(0x100000000ULL + x86ms->above_4g_mem_size, 1 * GiB);
:   +            0x100000000ULL + x86ms->above_4g_mem_size;
:
:            if (pcmc->enforce_aligned_dimm) {
:                /* size device region assuming 1G page max alignment per slot */

2. Bootup qemu with PSE disabled and a sub-section aligned memory size

   Part of the qemu command would look like this:

   sudo x86_64-softmmu/qemu-system-x86_64 \
       --enable-kvm -cpu host,pse=off \
       -m 4160M,maxmem=20G,slots=1 \
       -smp sockets=2,cores=16 \
       -numa node,nodeid=0,cpus=0-1 -numa node,nodeid=1,cpus=2-3 \
       -machine pc,nvdimm \
       -nographic \
       -object memory-backend-ram,id=mem0,size=8G \
       -device nvdimm,id=vm0,memdev=mem0,node=0,addr=0x144000000,label-size=128k

3. Re-config a pmem device with sub-section size in guest

   ndctl create-namespace --force --reconfig=namespace0.0 --mode=devdax --size=16M

Then you would see the following call trace:

   pmem0: detected capacity change from 0 to 16777216
   BUG: unable to handle page fault for address: ffffec73c51000b4
   #PF: supervisor write access in kernel mode
   #PF: error_code(0x0002) - not-present page
   PGD 81ff8067 P4D 81ff8067 PUD 81ff7067 PMD 1437cb067 PTE 0
   Oops: 0002 [#1] SMP NOPTI
   CPU: 16 PID: 1348 Comm: ndctl Kdump: loaded Tainted: G        W         5.8.0-rc2+ #24
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.4
   RIP: 0010:memmap_init_zone+0x154/0x1c2
   Code: 77 16 f6 40 10 02 74 10 48 03 48 08 48 89 cb 48 c1 eb 0c e9 3a ff ff ff 48 89 df 48 c1 e7 06 48f
   RSP: 0018:ffffbdc7011a39b0 EFLAGS: 00010282
   RAX: ffffec73c5100088 RBX: 0000000000144002 RCX: 0000000000144000
   RDX: 0000000000000004 RSI: 007ffe0000000000 RDI: ffffec73c5100080
   RBP: 027ffe0000000000 R08: 0000000000000001 R09: ffff9f8d38f6d708
   R10: ffffec73c0000000 R11: 0000000000000000 R12: 0000000000000004
   R13: 0000000000000001 R14: 0000000000144200 R15: 0000000000000000
   FS:  00007efe6b65d780(0000) GS:ffff9f8d3f780000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: ffffec73c51000b4 CR3: 000000007d718000 CR4: 0000000000340ee0
   Call Trace:
    move_pfn_range_to_zone+0x128/0x150
    memremap_pages+0x4e4/0x5a0
    devm_memremap_pages+0x1e/0x60
    dev_dax_probe+0x69/0x160 [device_dax]
    really_probe+0x298/0x3c0
    driver_probe_device+0xe1/0x150
    ? driver_allows_async_probing+0x50/0x50
    bus_for_each_drv+0x7e/0xc0
    __device_attach+0xdf/0x160
    bus_probe_device+0x8e/0xa0
    device_add+0x3b9/0x740
    __devm_create_dev_dax+0x127/0x1c0
    __dax_pmem_probe+0x1f2/0x219 [dax_pmem_core]
    dax_pmem_probe+0xc/0x1b [dax_pmem]
    nvdimm_bus_probe+0x69/0x1c0 [libnvdimm]
    really_probe+0x147/0x3c0
    driver_probe_device+0xe1/0x150
    device_driver_attach+0x53/0x60
    bind_store+0xd1/0x110
    kernfs_fop_write+0xce/0x1b0
    vfs_write+0xb6/0x1a0
    ksys_write+0x5f/0xe0
    do_syscall_64+0x4d/0x90
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20200625223534.18024-1-richard.weiyang@linux.alibaba.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/sparse.c~mm-sparse-never-partially-remove-memmap-for-early-section
+++ a/mm/sparse.c
@@ -825,10 +825,14 @@ static void section_deactivate(unsigned
 		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
-	if (section_is_early && memmap)
-		free_map_bootmem(memmap);
-	else
+	/*
+	 * The memmap of early sections is always fully populated. See
+	 * section_activate() and pfn_valid() .
+	 */
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
+	else if (memmap)
+		free_map_bootmem(memmap);
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
