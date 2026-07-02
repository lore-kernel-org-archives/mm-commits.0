Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07691314B76
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008230; cv=none; b=rUD2U06pVPM4m0zcNWUb8uCoXuFLA5tTIWTbjmmL7pRn7sLQRU+JFoVwzNJ7f358xCuRH/54u3nJnc/79M80ZpcqRp1JPOYfcbAfT5zmMLjwjzVd4z25MiV+EY0LkWOSC7C/5fVzByDP+xg6PgGhXfhtOEZoE7wUyw5qz6vH2OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008230; c=relaxed/simple;
	bh=GVj4HhA18bve4OGVz7YTiOkGnpnMUY7Ln3pegDNgKKI=;
	h=Date:To:From:Subject:Message-Id; b=KOeDc2Aiv1wbnfRJ9/vGmdtf/+bAEyDNxTZibEoowU+2h1HdvQ9rFsl/Nr/J0KbaFFoPu2qTQP5R63+YHzE/ex5vlGyyWTAdLkP+7TZWvADs/JoJa21mPP+LPQAGIfrPQhQlk1LyE+oRyhqAejpjBbS96tUPp03tzOuVD86rcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtVALKF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtVALKF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B581F00A3D;
	Thu,  2 Jul 2026 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008228;
	bh=vckqEG/gYOTmj5rtOMsP8jhqQePUK4K5EIWn6NejiHk=;
	h=Date:To:From:Subject;
	b=wtVALKF6Ttw+k/5oikH/1UZoLoQY1xrzJDuqIwsay5qSzxX/q8zyLJQiywczJBiim
	 THoo1/0Io0FfXoe8uwfBVOBnjSOhBzbxJX262Zf9EpPz9AM/WM/DftGBM+x1NV3U9w
	 Ybynro46Qo0K4z4PLkEjU1DYvfmKztuoLZKUjUJg=
Date: Thu, 02 Jul 2026 09:03:48 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-stale-zone_device-refcount-comment.patch removed from -mm tree
Message-Id: <20260702160348.A9B581F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix stale ZONE_DEVICE refcount comment
has been removed from the -mm tree.  Its filename was
     mm-fix-stale-zone_device-refcount-comment.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: fix stale ZONE_DEVICE refcount comment
Date: Wed, 1 Jul 2026 17:05:46 +0800

Patch series "mm: optimize zone-device memmap initialization", v5.

memmap_init_zone_device() can take a noticeable amount of time when large
pmem namespaces are bound or rebound, because it initializes nearly
identical struct page descriptors one PFN at a time.  This series reduces
that ZONE_DEVICE memmap initialization overhead by reusing prepared struct
page templates and, on x86, using memcpy_nt() for the template copy path.

The main target is large fsdax/devdax pmem configurations, where the cost
of initializing the memmap shows up directly in nd_pmem/dax_pmem bind and
rebind latency.

Patches 1-3 are preparatory cleanups and helper extraction.  Patches 4-5
add the template-copy fast path for head pages and compound tails. 
Patches 6-8 introduce memcpy_nt()/memcpy_nt_drain(), extend the x86
fixed-size memcpy_flushcache() inline cases used by that helper, and
switch the template-copy path over to memcpy_nt().

The fast path remains disabled when the page_ref_set tracepoint is active,
and sanitized builds stay on the slow path so their instrumented stores
are preserved.  Architectures without a specialized memcpy_nt() backend
continue to fall back to memcpy().

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series applied:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average rebind time by about 60.4% for nd_pmem and 56.4%
for dax_pmem.

As an additional data point, I also ran a smaller set of measurements on
the same physical x86_64 host with a 100 GB PMEM region created via the
memmap= kernel command line, configured as fsdax and devdax namespaces
with map=dev and 2 MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series.  The physical-host numbers below are included only as supplemental
evidence that the same optimization also provides a similar benefit on a
non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
once, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.2-rc1):
  nd_pmem / fsdax: 179 ms
  dax_pmem / devdax: 264 ms

With this series applied:
  nd_pmem / fsdax: 82 ms
  dax_pmem / devdax: 113 ms

This reduces the measured rebind time by about 54.2% for nd_pmem and 57.2%
for dax_pmem on that setup, which is broadly consistent with the VM
results above.

As another supplemental data point, I also measured the test_hmm.ko module
on the same physical x86_64 host, using the test_hmm.ko setup from the
previous discussion that times ten 64 GB memremap_pages()/memunmap_pages()
iterations during module insertion[1].  By default, module insertion
initializes two DEVICE_PRIVATE dmirror devices, so two avg memremap values
are reported; each value is the average for one 64 GB chunk.

This is not the primary target workload of the series, but it exercises
the same large ZONE_DEVICE memmap initialization path and shows the same
direction of improvement.

Base (v7.2-rc1):
  avg memremap reported during module insertion: 116689362 ns, 116539263 ns

With this series applied:
  avg memremap reported during module insertion: 54607108 ns, 54458236 ns

This corresponds to about a 53.2% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.


This patch (of 8):

The comment in __init_zone_device_page() still uses the old MEMORY_TYPE_*
names and implies that FS_DAX pages regain a refcount of 1 in the free
path.  That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path, while
the remaining ZONE_DEVICE types start from 0 here and raise the count
again when the allocator or driver hands the page out.

No functional change intended.

Link: https://lore.kernel.org/20260701090553.62691-2-lizhe.67@bytedance.com
Link: https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/ [1]
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/mm_init.c~mm-fix-stale-zone_device-refcount-comment
+++ a/mm/mm_init.c
@@ -1020,13 +1020,9 @@ static void __ref __init_zone_device_pag
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

mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

