Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2105128E37
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733795269; cv=none; b=Pv9mjXYSpoyVRTJB4YfFIHEkdSk6xRJrdetOsYywYAp+p+TZ43lRPYQb3KwajNjYjjRDmLxZVmHFSt8KrH6WzzOtTVpVIKeTgtWC+m623y0kavhFNHZpBU8OvFkUsrK30OgwTBD645P/J8wjOKWASeS8FjmM2s5o/TrojXqdz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733795269; c=relaxed/simple;
	bh=LdtOlI/Jbp+6E8x4ICyEWXlg+07t6ra7pai5DmEDO+M=;
	h=Date:To:From:Subject:Message-Id; b=YBCo+TpHo7poptPOfsPH8TrXX/3UwGvjJHn32MvnBGyVBNQPGKEgVibyi61wIeRxKjpEAA7UoC9kdkN+hPg8Iq4Jo17cp95eIa0WPwJr/LJE13c9nIJajaE/geUhdy/L9UlcCpsbydqFXbit1RHuShpGb6oxRdUik8w7sGGDcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bzsgK5hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bzsgK5hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16A2C4CED1;
	Tue, 10 Dec 2024 01:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733795268;
	bh=LdtOlI/Jbp+6E8x4ICyEWXlg+07t6ra7pai5DmEDO+M=;
	h=Date:To:From:Subject:From;
	b=bzsgK5hl2X1edNjdYmvpoaEdtMqS30Pj1EDzIB3YUuaLk4duE0S1eNgEBQ++cwKlD
	 Vrq7G7hwL1OhYOFDp5cXJzXXTCtViW9NfKaAB4jwBtSEtzgQvmslyn3zM1+Hhq61i/
	 mecIEfZgGIjxDoBQUlkuD4qkBVcRgNA1eCyyPFzo=
Date: Mon, 09 Dec 2024 17:47:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch added to mm-unstable branch
Message-Id: <20241210014748.A16A2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't use __GFP_HARDWALL when migrating pages via alloc_contig*()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch

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
Subject: mm/page_alloc: don't use __GFP_HARDWALL when migrating pages via alloc_contig*()
Date: Thu, 5 Dec 2024 10:05:07 +0100

Patch series "mm: don't use __GFP_HARDWALL when migrating remote pages".

__GFP_HARDWALL means that we will be respecting the cpuset of the caller
when allocating a page.  However, when we are migrating remote allocations
(pages allocated from other context), the cpuset of the current context is
irrelevant.

For memory offlining + alloc_contig_*(), this is rather obvious.  There
might be other such page migration users, let's start with the obvious
ones.


This patch (of 2):

We'll migrate pages allocated by other contexts; respecting the cpuset of
the alloc_contig*() caller when allocating a migration target does not
make sense.

Drop the __GFP_HARDWALL.

Note that in an ideal world, migration code could figure out the cpuset
of the original context and take that into consideration.

Link: https://lkml.kernel.org/r/20241205090508.2095225-1-david@redhat.com
Link: https://lkml.kernel.org/r/20241205090508.2095225-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig
+++ a/mm/page_alloc.c
@@ -6453,11 +6453,11 @@ static int __alloc_contig_verify_gfp_mas
 	 * page range. Migratable pages are movable, __GFP_MOVABLE is implied
 	 * for them.
 	 *
-	 * Traditionally we always had __GFP_HARDWALL|__GFP_RETRY_MAYFAIL set,
-	 * keep doing that to not degrade callers.
+	 * Traditionally we always had __GFP_RETRY_MAYFAIL set, keep doing that
+	 * to not degrade callers.
 	 */
 	*gfp_cc_mask = (gfp_mask & (reclaim_mask | cc_action_mask)) |
-			__GFP_HARDWALL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+			__GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
 	return 0;
 }
 
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

