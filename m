Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6249D35F193
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 00:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496053; cv=none; b=kzkr+ue0QO5zIqFwcDOwDw2nWvp2zvQV/p9Hsa7DVn4Aoyn11Jw1SAC3z8+yUJHDIIkuBeI1fMhHT30RrS6pB8hYguYnyuVipw+wyYVTYi9t67hcTlfQwvwF6lolSkp8HVEguOc9w8XCKdGI3GetYLPVlrRTsnozxxTEzzqQDFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496053; c=relaxed/simple;
	bh=C29LqXr/UBFmzF2XvZW4PWufkxPjr7sbRF3/Gu8d+sY=;
	h=Date:To:From:Subject:Message-Id; b=qC6jB0ZwplcM0g7k9mX3IDngizfFQQHcTiBhy0P8xdIzgCqGVK5R8NF38+jC2BwwevpWEJkV0xjvrJfS3xN4yvg2PVFUMR/KnxI8Jo9Mvnwmf4CDINcNkKBlrXEO5qJza62S5D5Sb/0jg7fnvmX2DEfOicZ0HhfboZZlyINItfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLg2vaj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLg2vaj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A4AC19423;
	Tue,  3 Mar 2026 00:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772496052;
	bh=C29LqXr/UBFmzF2XvZW4PWufkxPjr7sbRF3/Gu8d+sY=;
	h=Date:To:From:Subject:From;
	b=RLg2vaj+xR3XN/rWcIuXOP7AswRPNPoahBEcRJLei1xN8gEuhwrkwRqMw/Xmm5BFQ
	 UAJzYwWOZNMXcJ/YdwckjP+jwYOzCjt6JuRnwf5wqdwDlo2juE+9WoB+7Mccd6a41H
	 2EKXC3x7CV61NTDv7zzRLYjDFHv1oO4A9GwB4Q2U=
Date: Mon, 02 Mar 2026 16:00:52 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,mpatocka@redhat.com,bhe@redhat.com,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-support-__gfp_retry_mayfail-and-__gfp_noretry.patch added to mm-new branch
Message-Id: <20260303000052.D5A4AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-support-__gfp_retry_mayfail-and-__gfp_noretry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-support-__gfp_retry_mayfail-and-__gfp_noretry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Date: Mon, 2 Mar 2026 12:47:40 +0100

__GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
because their semantic (i.e.  to not trigger OOM killer) is not possible
with the existing vmalloc page table allocation which is allowing for the
OOM killer.

Example: __vmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);

<snip>
 vmalloc_test/55 invoked oom-killer:
 gfp_mask=0x40dc0(
 GFP_KERNEL|__GFP_ZERO|__GFP_COMP), order=0, oom_score_adj=0
 active_anon:0 inactive_anon:0 isolated_anon:0
  active_file:0 inactive_file:0 isolated_file:0
  unevictable:0 dirty:0 writeback:0
  slab_reclaimable:700 slab_unreclaimable:33708
  mapped:0 shmem:0 pagetables:5174
  sec_pagetables:0 bounce:0
  kernel_misc_reclaimable:0
  free:850 free_pcp:319 free_cma:0
 CPU: 4 UID: 0 PID: 639 Comm: vmalloc_test/55 ...
 Hardware name: QEMU Standard PC (i440FX + PIIX, ...
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5d/0x80
  dump_header+0x43/0x1b3
  out_of_memory.cold+0x8/0x78
  __alloc_pages_slowpath.constprop.0+0xef5/0x1130
  __alloc_frozen_pages_noprof+0x312/0x330
  alloc_pages_mpol+0x7d/0x160
  alloc_pages_noprof+0x50/0xa0
  __pte_alloc_kernel+0x1e/0x1f0
  ...
<snip>

There are usecases for these modifiers when a large allocation request
should rather fail than trigger OOM killer which wouldn't be able to
handle the situation anyway [1].

While we cannot change existing page table allocation code easily we can
piggy back on scoped NOWAIT allocation for them that we already have in
place.  The rationale is that the bulk of the consumed memory is sitting
in pages backing the vmalloc allocation.  Page tables are only
participating a tiny fraction.  Moreover page tables for virtually
allocated areas are never reclaimed so the longer the system runs to less
likely they are.  It makes sense to allow an approximation of
__GFP_RETRY_MAYFAIL and __GFP_NORETRY even if the page table allocation
part is much weaker.  This doesn't break the failure mode while it allows
for the no OOM semantic.

[1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u

Link: https://lkml.kernel.org/r/20260302114740.2668450-2-urezki@gmail.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~vmalloc-support-__gfp_retry_mayfail-and-__gfp_noretry
+++ a/mm/vmalloc.c
@@ -3797,6 +3797,8 @@ static void defer_vm_area_cleanup(struct
  * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
  * GFP_NOFS - memalloc_nofs_save()
  * GFP_NOIO - memalloc_noio_save()
+ * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save()
+ * to prevent OOMs
  *
  * Returns a flag cookie to pair with restore.
  */
@@ -3805,7 +3807,8 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
 {
 	unsigned int flags = 0;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
+	if (!gfpflags_allow_blocking(gfp_mask) ||
+			(gfp_mask & (__GFP_RETRY_MAYFAIL | __GFP_NORETRY)))
 		flags = memalloc_noreclaim_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
@@ -3933,8 +3936,8 @@ fail:
  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
-				__GFP_RETRY_MAYFAIL |\
+				__GFP_NOFAIL | __GFP_ZERO |\
+				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
@@ -3965,12 +3968,15 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
  * virtual range with protection @prot.
  *
  * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
- * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
+ * Zone modifiers are not supported.
  * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
  * by __vmalloc().
  *
- * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
- * and %__GFP_RETRY_MAYFAIL are not supported.
+ * Retry modifiers: only %__GFP_NOFAIL is fully supported;
+ * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
+ * i.e. page tables are allocated with NOWAIT semantic so they might fail
+ * under moderate memory pressure.
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
_

Patches currently in -mm which might be from mhocko@suse.com are

vmalloc-support-__gfp_retry_mayfail-and-__gfp_noretry.patch

