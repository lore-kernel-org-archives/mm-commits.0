Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156A415DBBA;
	Tue, 17 Dec 2024 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734467832; cv=none; b=QdRWt8eEEfT8B+73YARLAJ/wQibV4Ig3P7bjZq4Mo5aukiuKA4HnC1Dz7yqKlx6NSQ7m47euBJUk7tfdVsGUAEFZLguPh6DN0DtbOkyKeLYQ8Wmb0gqBLjo3TKAnsLj0o6SkGiD+cTCiOW6pextIYAk1NS8xfGTeVZL0zMuVu+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734467832; c=relaxed/simple;
	bh=y1eeSKNn6kD196/09klKeNET65/9qzrZ8icfje31jJ4=;
	h=Date:To:From:Subject:Message-Id; b=AamxA1c/Y49lRPk9/nj41XgF4ErOzrYdSy3W6ZN9Ah7+BTCl344W9g2wX+47i81xKdB4SqDnKbWE/DyoJJoxse6Uhq+sR4lJJXBuavtT3OrCPK+KUPKf96sO13zlq6clptI00LUKBl0ggFys3PKd85E5AWB/PjrXEdq8HrZ6VRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVpqZAUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVpqZAUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786DCC4CED3;
	Tue, 17 Dec 2024 20:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734467831;
	bh=y1eeSKNn6kD196/09klKeNET65/9qzrZ8icfje31jJ4=;
	h=Date:To:From:Subject:From;
	b=xVpqZAUUNUmUKGNqtEt2W7AQme12X4oU6PYk0VkCXnU9h+/jzX0rXZWVwAPXnTug1
	 eXgnFUGegdc8G1bmaKnboAL7ieIWkVaIATpeVpG+XkNGPZNMozsvc2HOHBHUlrO8Ss
	 Tr8RK+kKKiOvoqC8ABHGwK3DqpcwbzAiqZEh5KNk=
Date: Tue, 17 Dec 2024 12:37:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217203711.786DCC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit
Date: Tue, 17 Dec 2024 20:50:00 +0100

Entries (including flags) are u64, even on 32bit.  So right now we are
cutting of the flags on 32bit.  This way, for example the cow selftest
complains about:

  # ./cow
  ...
  Bail Out! read and ioctl return unmatched results for populated: 0 1

Link: https://lkml.kernel.org/r/20241217195000.1734039-1-david@redhat.com
Fixes: 2c1f057e5be6 ("fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit
+++ a/fs/proc/task_mmu.c
@@ -1810,7 +1810,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		}
 
 		for (; addr != end; addr += PAGE_SIZE, idx++) {
-			unsigned long cur_flags = flags;
+			u64 cur_flags = flags;
 			pagemap_entry_t pme;
 
 			if (folio && (flags & PM_PRESENT) &&
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch
fs-proc-task_mmu-fix-pagemap-flags-with-pmd-thp-entries-on-32bit.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

