From: akpm@linux-foundation.org
Subject: [merged]
 tmpfs-zero_range-and-collapse_range-not-currently-supported.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:15 -0700
Message-ID: <53a9cb37.bzu/iIcyZGgzuaP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFXTCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, lczerner@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported
has been removed from the -mm tree.  Its filename was
     tmpfs-zero_range-and-collapse_range-not-currently-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported

I was well aware of FALLOC_FL_ZERO_RANGE and FALLOC_FL_COLLAPSE_RANGE
support being added to fallocate(); but didn't realize until now that I
had been too stupid to future-proof shmem_fallocate() against new
additions.  -EOPNOTSUPP instead of going on to ordinary fallocation.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Cc: <stable@vger.kernel.org>	[3.15]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/shmem.c~tmpfs-zero_range-and-collapse_range-not-currently-supported mm/shmem.c
--- a/mm/shmem.c~tmpfs-zero_range-and-collapse_range-not-currently-supported
+++ a/mm/shmem.c
@@ -1724,6 +1724,9 @@ static long shmem_fallocate(struct file
 	pgoff_t start, index, end;
 	int error;
 
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

