Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A960130594F
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334293; cv=none; b=dWes8VFOe2M3sL7epXUUMytDnJYl5EG8mfdb3T/z/3zI0RsGv2z8L97SF3d2PIyazjshV6GccFy9gA5PTLHC7Bv1ovKu/9ZW2S49FPXT8ZFpYqnVhKBgONh6Y88ssXtmRUQsn0Ct4UztR8vLBjAgx/aVRQn0hIek0Hfa8vs78J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334293; c=relaxed/simple;
	bh=H/ZrqgFMjMCw+xedYmmnET0fRWcDGNrUyEYBzG3WXlg=;
	h=Date:To:From:Subject:Message-Id; b=cuYvTFs/iYhcoZG2j9m0HRWcrhoneWWtyW3bWTv73Lfnq01Pz1eUE4+TPis2/Bp+2ffWhdfZnyvjOuh7P4N7ZqF0d3pLWjQZRtgnjGe0oBqZ5LLavczb/C+N4jExrcYvx54rkyNI8jcFWNYX43O8QocNHl23Wq4IlWlfvpUbesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m0DXFFUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m0DXFFUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF671F0089B;
	Wed,  7 Oct 2026 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334291;
	bh=8PFg+EUU/ZXDIvemPeVB3tQ/JR4TK/0GVbxayEc/cc8=;
	h=Date:To:From:Subject;
	b=m0DXFFUcQdyL1ldZuxWcHI8l+jichQOzS0AuCOoGd9bKRQ0owgM24c8rNFPus+KVE
	 JXZeMLEjd15TKL6t2ZYp6swqxqk99nRmAyDWIVLIAAyd0qrxMrzL5IBmhFpJMX9ROq
	 oHMsyC+h0lxR4GdxFiYUybtpwC2D755CGe7gYhnc=
Date: Tue, 06 Oct 2026 17:51:31 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-stale-zone_device-refcount-comment.patch removed from -mm tree
Message-Id: <20261007005131.7FF671F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix stale ZONE_DEVICE refcount comment
has been removed from the -mm tree.  Its filename was
     mm-fix-stale-zone_device-refcount-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: fix stale ZONE_DEVICE refcount comment
Date: Mon, 31 Aug 2026 19:16:32 +0800

Patch series "mm: optimize zone-device memmap initialization", v11.

memmap_init_zone_device() can take a noticeable amount of time when large
pmem namespaces are bound or rebound, because it initializes nearly
identical struct page descriptors one PFN at a time.  This series reduces
that ZONE_DEVICE memmap initialization overhead by reusing prepared struct
page templates and, on x86, using memcpy_nontemporal() for the template
copy path.

The main target is large fsdax/devdax pmem configurations, where the cost
of initializing the memmap shows up directly in nd_pmem/dax_pmem bind and
rebind latency.  This matters because the cost is paid in the synchronous
probe/bind path for large DAX/PMEM ZONE_DEVICE mappings.  Userspace
workflows such as provisioning or reconfiguring nd_pmem/dax_pmem
namespaces, bringing hot-added PMEM-backed capacity online, and recovering
or rebinding a device after driver or device changes all wait for this
initialization to finish.  Reducing this cost will yield benefits as lower
user-visible provisioning, hot-add, recovery, and rebind latency for large
DAX/PMEM devices.

Patches 1-2 are preparatory cleanups and helper extraction.  Patches 3-4
add the template-copy path for head pages and compound tails.  Patch 5
introduces memcpy_nontemporal().  Patch 6 switches the ZONE_DEVICE
template-copy path over to memcpy_nontemporal().  Patch 7 extends the x86
fixed-size memcpy_flushcache() inline cases used by the x86
memcpy_nontemporal() backend for struct page sized copies.

Architectures without a specialized memcpy_nontemporal() backend fall back
to memcpy(), so the generic template-copy optimization remains available
without arch-specific support.  On x86, memcpy_nontemporal() maps to the
existing memcpy_flushcache() backend and can use the fixed-size MOVNTI
paths added by this series for struct page sized copies.

memcpy_nontemporal() is only a copy primitive.  It does not imply a drain
or a publication barrier.  Callers that use it before a producer-consumer
or device-visible handoff must provide the required ordering.  The
ZONE_DEVICE template-copy path uses it only while initializing struct page
metadata, so the copy primitive itself does not grow a separate drain
contract.

The numbers below measure the time spent in memmap_init_zone_device()
during driver bind/rebind.  They are not measurements of the full nd_pmem
or dax_pmem bind/rebind operation.

Tested in an x86_64 QEMU/KVM VM with a 100 GB fsdax namespace device
configured with map=dev and a 100 GB devdax namespace (align=2097152) on
Intel Ice Lake server.

Test procedure:
Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of nd_pmem rebinds: 221.07 ms
  Average of dax_pmem rebinds: 191.20 ms

With this series applied:
  Average of nd_pmem rebinds:  71.93 ms
  Average of dax_pmem rebinds:  87.37 ms

This reduces the average memmap initialization time measured during rebind
by about 67.5% for nd_pmem and 54.3% for dax_pmem.

As an additional x86_64 data point, I also ran measurements on the same
physical host with a 100 GB PMEM region created via the memmap= kernel
command line, configured as fsdax and devdax namespaces with map=dev and 2
MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series.  The physical-host numbers below are included only as supplemental
evidence that the same optimization also provides a similar benefit on a
non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
30 times, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.3-rc1):
  nd_pmem / fsdax: 205.90 ms
  dax_pmem / devdax: 225.43 ms

With this series applied:
  nd_pmem / fsdax: 69.13 ms
  dax_pmem / devdax: 90.67 ms

This reduces the measured memmap initialization time during rebind by
about 66.4% for nd_pmem and 59.8% for dax_pmem on that setup, which is
broadly consistent with the VM results above.

As another supplemental data point, I measured the test_hmm.ko module on
the same physical x86_64 host, using the test_hmm.ko setup from the
previous discussion that times ten 64 GB memremap_pages()/memunmap_pages()
iterations during module insertion[1].  By default, module insertion
initializes two DEVICE_PRIVATE dmirror devices, so two avg memremap values
are reported; each value is the average for one 64 GB chunk.

This is not the primary target workload of the series, but it exercises
the same large ZONE_DEVICE memmap initialization path and shows the same
direction of improvement.

Base (v7.3-rc1):
  avg memremap reported during module insertion: 116500596 ns, 116438028 ns

With this series applied:
  avg memremap reported during module insertion: 46953088 ns, 46428399 ns

This corresponds to about a 59.9% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.

I also include an arm64 data point for the generic template-copy part.  It
was measured on an arm64 QEMU virt VM with 64 KB pages and a 100 GB ACPI
NVDIMM sparse backend.  This setup does not use the x86 MOVNTI fast paths,
so it exercises the architecture-independent part of the optimization.

For devdax, 2 MiB alignment is rejected in this 64 KB page setup, so the
devdax namespace was tested with the supported default 512 MiB alignment.

Base (v7.3-rc1):
  Average of rebinds for nd_pmem driver: 27.93 ms
  Average of rebinds for dax_pmem driver: 27.87 ms

With this series applied:
  Average of rebinds for nd_pmem driver: 14.53 ms
  Average of rebinds for dax_pmem driver: 16.27 ms

This reduces the average memmap initialization time measured during rebind
by about 48.0% for nd_pmem and 41.6% for dax_pmem on that arm64 VM setup. 
Since this arm64 setup does not use the x86 MOVNTI fast paths, the result
also suggests that the generic template-copy optimization can benefit
architectures without an architecture-specific memcpy_nontemporal()
backend.


This patch (of 7):

The comment in __init_zone_device_page() still uses the old MEMORY_TYPE_*
names and implies that FS_DAX pages regain a refcount of 1 in the free
path.  That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path, while
the remaining ZONE_DEVICE types start from 0 here and raise the count
again when the allocator or driver hands the page out.

No functional change intended.

Link: https://lore.kernel.org/20260831111638.76012-1-lizhe.67@bytedance.com
Link: https://lore.kernel.org/20260831111638.76012-2-lizhe.67@bytedance.com
Link: https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/ [1]
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
---

 mm/mm_init.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/mm_init.c~mm-fix-stale-zone_device-refcount-comment
+++ a/mm/mm_init.c
@@ -1012,13 +1012,9 @@ static void __ref __init_zone_device_pag
 	page->zone_device_data = NULL;
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

