Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E12451D8
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 01:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733879017; cv=none; b=gsb4EzByDCr8uRmj2QHOkVh3UFXtUmlzaK/d/g84vn8nvfh+tJc013d0hWS+GdnirahB+d8IQSxMmOAnUwiF1G7wqR7+QSsHqF/TR5Q3VdwiYV5P8X2tiBEOTNAbMOZ6oJEyYoaYZrskkobZO6hlWygoBGDb9pZpUhaQ98WTQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733879017; c=relaxed/simple;
	bh=ma8DjenJp3Ap3GhYzvQKkxXzxhXEWxS8W0+N/HPIljk=;
	h=Date:To:From:Subject:Message-Id; b=hpKef4G2qGB9gmT84PLCVdHG5sKO9x2PMnxclhek9aaags4AtCAfvpVbGQLJWryxzuVtmWrpPHh4x8+KX32/EJXgXXR0mVboBuvqzeaGdLNjdkm0UCSqsJAC36K8KPk2MZKU9KCoXEhFWENBA/BkVOeAxV13Yer5AYLsdsGdDWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUIwQZst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUIwQZst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF4C4CED6;
	Wed, 11 Dec 2024 01:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733879016;
	bh=ma8DjenJp3Ap3GhYzvQKkxXzxhXEWxS8W0+N/HPIljk=;
	h=Date:To:From:Subject:From;
	b=IUIwQZstWe8SZDhvNVziCZVm/ftS0CL5Iw6Hd/Ix6kgzD64S3iuAEJFtbsMyA+Tds
	 SwMN4AOrFa/DsHahz38bJEkJ0J6GXukKZUCFZJ0NAeSXrzB+gqaE1gEoWSIrzu0ZKe
	 S3t0NbFewP8gqZNSZlGuh0LKbZKXAjlEHvX9Zf1E=
Date: Tue, 10 Dec 2024 17:03:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch removed from -mm tree
Message-Id: <20241211010336.D5EF4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: fixup isolate_single_pageblock() comment regarding splitting free pages
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: fixup isolate_single_pageblock() comment regarding splitting free pages
Date: Fri, 6 Dec 2024 10:59:51 +0100

Let's fixup the comment, documenting how free_one_page_maybe_split()
comes into play.

Link: https://lkml.kernel.org/r/20241206095951.98007-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages
+++ a/mm/page_isolation.c
@@ -298,11 +298,10 @@ __first_valid_page(unsigned long pfn, un
  * pagelbocks.
  * [      MAX_PAGE_ORDER         ]
  * [  pageblock0  |  pageblock1  ]
- * When either pageblock is isolated, if it is a free page, the page is not
- * split into separate migratetype lists, which is supposed to; if it is an
- * in-use page and freed later, __free_one_page() does not split the free page
- * either. The function handles this by splitting the free page or migrating
- * the in-use page then splitting the free page.
+ * When either pageblock is isolated, if it is an in-use page and freed later,
+ * __free_one_page_maybe_split() will split the free page if required. If the
+ * page is already free, this function handles this by splitting the free page
+ * through move_freepages_block_isolate()->__free_one_page_maybe_split().
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
 		bool isolate_before, bool skip_isolation, int migratetype)
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch
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

