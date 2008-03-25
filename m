From: akpm@linux-foundation.org
Subject: + lmb-add-lmb_alloc_nid.patch added to -mm tree
Date: Tue, 25 Mar 2008 14:18:12 -0700
Message-ID: <200803252118.m2PLICOc013675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYCYVT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 17:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, tglx@linutronix.de


The patch titled
     lmb: add lmb_alloc_nid()
has been added to the -mm tree.  Its filename is
     lmb-add-lmb_alloc_nid.patch

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
Subject: lmb: add lmb_alloc_nid()
From: David Miller <davem@davemloft.net>

A variant of lmb_alloc() that tries to allocate memory on a specified NUMA
node 'nid' but falls back to normal lmb_alloc() if that fails.

The caller provides a 'nid_range' function pointer which assists the
allocator.  It is given args 'start', 'end', and pointer to integer
'this_nid'.

It places at 'this_nid' the NUMA node id that corresponds to 'start', and
returns the end address within 'start' to 'end' at which memory assosciated
with 'nid' ends.

This callback allows a platform to use lmb_alloc_nid() in just about any
context, even ones in which early_pfn_to_nid() might not be working yet.



This function will be used by the NUMA setup code on sparc64, and also it can
be used by powerpc, replacing it's hand crafted "careful_allocation()"
function in arch/powerpc/mm/numa.c

If x86 ever converts its NUMA support over to using the LMB helpers, it can
use this too as it has something entirely similar.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lmb.h |    2 
 lib/lmb.c           |   86 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 78 insertions(+), 10 deletions(-)

diff -puN include/linux/lmb.h~lmb-add-lmb_alloc_nid include/linux/lmb.h
--- a/include/linux/lmb.h~lmb-add-lmb_alloc_nid
+++ a/include/linux/lmb.h
@@ -42,6 +42,8 @@ extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
 extern long __init lmb_add(u64 base, u64 size);
 extern long __init lmb_reserve(u64 base, u64 size);
+extern u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
+				u64 (*nid_range)(u64, u64, int *));
 extern u64 __init lmb_alloc(u64 size, u64 align);
 extern u64 __init lmb_alloc_base(u64 size,
 		u64, u64 max_addr);
diff -puN lib/lmb.c~lmb-add-lmb_alloc_nid lib/lmb.c
--- a/lib/lmb.c~lmb-add-lmb_alloc_nid
+++ a/lib/lmb.c
@@ -232,6 +232,82 @@ long __init lmb_overlaps_region(struct l
 	return (i < rgn->cnt) ? i : -1;
 }
 
+static u64 lmb_align_down(u64 addr, u64 size)
+{
+	return addr & ~(size - 1);
+}
+
+static u64 lmb_align_up(u64 addr, u64 size)
+{
+	return (addr + (size - 1)) & ~(size - 1);
+}
+
+static u64 __init lmb_alloc_nid_unreserved(u64 start, u64 end,
+					   u64 size, u64 align)
+{
+	u64 base;
+	long j;
+
+	base = lmb_align_down((end - size), align);
+	while (start <= base &&
+	       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0))
+		base = lmb_align_down(lmb.reserved.region[j].base - size,
+				      align);
+
+	if (base != 0 && start <= base) {
+		if (lmb_add_region(&lmb.reserved, base,
+				   lmb_align_up(size, align)) < 0)
+			base = ~(u64)0;
+		return base;
+	}
+
+	return ~(u64)0;
+}
+
+static u64 __init lmb_alloc_nid_region(struct lmb_property *mp,
+				       u64 (*nid_range)(u64, u64, int *),
+				       u64 size, u64 align, int nid)
+{
+	u64 start, end;
+
+	start = mp->base;
+	end = start + mp->size;
+
+	start = lmb_align_up(start, align);
+	while (start < end) {
+		u64 this_end;
+		int this_nid;
+
+		this_end = nid_range(start, end, &this_nid);
+		if (this_nid == nid) {
+			u64 ret = lmb_alloc_nid_unreserved(start, this_end,
+							   size, align);
+			if (ret != ~(u64)0)
+				return ret;
+		}
+		start = this_end;
+	}
+
+	return ~(u64)0;
+}
+
+u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
+			 u64 (*nid_range)(u64 start, u64 end, int *nid))
+{
+	struct lmb_region *mem = &lmb.memory;
+	int i;
+
+	for (i = 0; i < mem->cnt; i++) {
+		u64 ret = lmb_alloc_nid_region(&mem->region[i],
+					       nid_range,
+					       size, align, nid);
+		if (ret != ~(u64)0)
+			return ret;
+	}
+
+	return lmb_alloc(size, align);
+}
+
 u64 __init lmb_alloc(u64 size, u64 align)
 {
 	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
@@ -250,16 +326,6 @@ u64 __init lmb_alloc_base(u64 size, u64 
 	return alloc;
 }
 
-static u64 lmb_align_down(u64 addr, u64 size)
-{
-	return addr & ~(size - 1);
-}
-
-static u64 lmb_align_up(u64 addr, u64 size)
-{
-	return (addr + (size - 1)) & ~(size - 1);
-}
-
 u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
x86-kmap_atomic-debugging-only-run-debug_kmap_atomic_prot-for-highmem-pages.patch
git-powerpc.patch
lmb-add-lmb_alloc_nid.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
git-nfsd.patch
git-security-testing.patch
git-s390.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-sparc64.patch
sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries.patch
sparc64-remove-unused-calc_npages-in-iommu_commonh.patch
git-cryptodev.patch
git-perfmon.patch
ehea-fix-ipv6-support.patch
skge-napi-poll-locking-bug.patch
drm-fix-for-non-coherent-dma-powerpc.patch
bonding-fix-sysfs-attribute-handling.patch
pageflags-get-rid-of-flags_reserved.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch
rename-div64_64-to-div64_u64.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch
dma-mapping-add-dma_map_attrs-interfaces.patch
dma-mapping-document-dma_map_attrs-interfaces.patch
dma-mapping-ia64-update-ia64-machvecs-swiotlbc.patch
dma-mapping-ib-expand-ib_umem_get-prototype.patch
dma-mapping-ib-expand-ib_umem_get-prototype-fix.patch

