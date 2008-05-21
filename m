From: akpm@linux-foundation.org
Subject: + zonelists-handle-a-node-zonelist-with-no-applicable-entries.patch added to -mm tree
Date: Wed, 21 May 2008 15:06:06 -0700
Message-ID: <200805212206.m4LM66mH003119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYEUWG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:06:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     zonelists: handle a node zonelist with no applicable entries
has been added to the -mm tree.  Its filename is
     zonelists-handle-a-node-zonelist-with-no-applicable-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zonelists: handle a node zonelist with no applicable entries
From: Andy Whitcroft <apw@shadowen.org>

When booting 2.6.26-rc3 on a multi-node x86_32 numa system we are seeing
panics when trying node local allocations:

 BUG: unable to handle kernel NULL pointer dereference at 0000034c
 IP: [<c1042507>] get_page_from_freelist+0x4a/0x18e
 *pdpt = 00000000013a7001 *pde = 0000000000000000
 Oops: 0000 [#1] SMP
 Modules linked in:

 Pid: 0, comm: swapper Not tainted (2.6.26-rc3-00003-g5abc28d #82)
 EIP: 0060:[<c1042507>] EFLAGS: 00010282 CPU: 0
 EIP is at get_page_from_freelist+0x4a/0x18e
 EAX: c1371ed8 EBX: 00000000 ECX: 00000000 EDX: 00000000
 ESI: f7801180 EDI: 00000000 EBP: 00000000 ESP: c1371ec0
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 Process swapper (pid: 0, ti=c1370000 task=c12f5b40 task.ti=c1370000)
 Stack: 00000000 00000000 00000000 00000000 000612d0 000412d0 00000000 000412d0
        f7801180 f7c0101c f7c01018 c10426e4 f7c01018 00000001 00000044 00000000
        00000001 c12f5b40 00000001 00000010 00000000 000412d0 00000286 000412d0
 Call Trace:
  [<c10426e4>] __alloc_pages_internal+0x99/0x378
  [<c10429ca>] __alloc_pages+0x7/0x9
  [<c105e0e8>] kmem_getpages+0x66/0xef
  [<c105ec55>] cache_grow+0x8f/0x123
  [<c105f117>] ____cache_alloc_node+0xb9/0xe4
  [<c105f427>] kmem_cache_alloc_node+0x92/0xd2
  [<c122118c>] setup_cpu_cache+0xaf/0x177
  [<c105e6ca>] kmem_cache_create+0x2c8/0x353
  [<c13853af>] kmem_cache_init+0x1ce/0x3ad
  [<c13755c5>] start_kernel+0x178/0x1ee

This occurs when we are scanning the zonelists looking for a ZONE_NORMAL
page.  In this system there is only ZONE_DMA and ZONE_NORMAL memory on
node 0, all other nodes are mapped above 4GB physical.  Here is a dump
of the zonelists from this system:

    zonelists pgdat=c1400000
     0: c14006c0:2 f7c006c0:2 f7e006c0:2 c1400360:1 c1400000:0
     1: c14006c0:2 c1400360:1 c1400000:0
    zonelists pgdat=f7c00000
     0: f7c006c0:2 f7e006c0:2 c14006c0:2 c1400360:1 c1400000:0
     1: f7c006c0:2
    zonelists pgdat=f7e00000
     0: f7e006c0:2 c14006c0:2 f7c006c0:2 c1400360:1 c1400000:0
     1: f7e006c0:2

When performing a node local allocation we call get_page_from_freelist()
looking for a page.  It in turn calls first_zones_zonelist() which returns
a preferred_zone.  Where there are no applicable zones this will be NULL.
However we use this unconditionally, leading to this panic.

Where there are no applicable zones there is no possibility of a successful
allocation, so simply fail the allocation.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~zonelists-handle-a-node-zonelist-with-no-applicable-entries mm/page_alloc.c
--- a/mm/page_alloc.c~zonelists-handle-a-node-zonelist-with-no-applicable-entries
+++ a/mm/page_alloc.c
@@ -1396,6 +1396,9 @@ get_page_from_freelist(gfp_t gfp_mask, n
 
 	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
+	if (!preferred_zone)
+		return NULL;
+
 	classzone_idx = zone_idx(preferred_zone);
 
 zonelist_scan:
_

Patches currently in -mm which might be from apw@shadowen.org are

linux-next.patch
zonelists-handle-a-node-zonelist-with-no-applicable-entries.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
page-owner-tracking-leak-detector.patch

