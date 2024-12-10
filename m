Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4FD28E37
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733795271; cv=none; b=OARmr4kihcIuHuWzAP0w+JZ+2MtE40+YnWY1MAlNZ8a+QqoYcBgbmdcPCjJLfhvY8ILyiP8nkzm+Q+Fyr3F6+hnQ3rUpSAtCQeaAWIFqyJJ79e2N0FUtAwEE8hv9k24UYNCPbM6qCRVu7zhGy0STO2zdHc6NBi7PBNbnE23+MXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733795271; c=relaxed/simple;
	bh=3QwNZMqUF7Q2U0JZLSynuu+5sA+LW8yXoNh0GtSpXq8=;
	h=Date:To:From:Subject:Message-Id; b=H7RID3s4EKe6ef35EmiDQsYsUO+Ym+k8alU67BYunETRu1JwLJsJcnhWAEwLUFwcORyybd394Am+Xn+V1GWMKsqZCSC8kXwFvnoVB4+tegF0VXrG0vwEBQQDX1G5bf6NX6fRHclzWc61aUkVcqFqPpu/z70G/l9khbW7lwUZDFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fRD1UQfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRD1UQfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875ECC4CED1;
	Tue, 10 Dec 2024 01:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733795270;
	bh=3QwNZMqUF7Q2U0JZLSynuu+5sA+LW8yXoNh0GtSpXq8=;
	h=Date:To:From:Subject:From;
	b=fRD1UQfooGFcQnZfAZI02jU3UZ8NI9p2yEPd60qgL0k/g1qFERsu1eZ9Bo9BxZxUq
	 Uzta8ifd/rXQfowIT2CgMb6n286Cd5vv5IUMUWfXDaeZ3cDpFWoO8dKjzVCo184x3g
	 91mszfRlg3sZXdaIoc9BsXzyhTI/bne4intEBfAk=
Date: Mon, 09 Dec 2024 17:47:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch added to mm-unstable branch
Message-Id: <20241210014750.875ECC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: don't use __GFP_HARDWALL when migrating pages via memory offlining
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/memory_hotplug: don't use __GFP_HARDWALL when migrating pages via memory offlining
Date: Thu, 5 Dec 2024 10:05:08 +0100

We'll migrate pages allocated by other context; respecting the cpuset of
the memory offlining context when allocating a migration target does not
make sense.

Drop the __GFP_HARDWALL by using GFP_KERNEL.

Note that in an ideal world, migration code could figure out the cpuset
of the original context and take that into consideration.

Link: https://lkml.kernel.org/r/20241205090508.2095225-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining
+++ a/mm/memory_hotplug.c
@@ -1838,7 +1838,7 @@ put_folio:
 		nodemask_t nmask = node_states[N_MEMORY];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
-			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 			.reason = MR_MEMORY_HOTPLUG,
 		};
 		int ret;
_

Patches currently in -mm which might be from david@redhat.com are

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
mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch
mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

