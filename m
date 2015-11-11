From: akpm@linux-foundation.org
Subject: +
 mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch added to -mm tree
Date: Wed, 11 Nov 2015 15:22:21 -0800
Message-ID: <5643cdad.i51wb/w71qs/LsaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbbKKXWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 18:22:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix
has been added to the -mm tree.  Its filename is
     mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix

further simplification, per Naoya Horiguchi

Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix
+++ a/mm/mmap.c
@@ -2988,9 +2988,7 @@ out:
  */
 int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 {
-	if (mm->total_vm + npages> (rlimit(RLIMIT_AS)>> PAGE_SHIFT))
-		return 0;
-	return 1;
+	return mm->total_vm + npages <= rlimit(RLIMIT_AS) >> PAGE_SHIFT;
 }
 
 static int special_mapping_fault(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

