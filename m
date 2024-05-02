Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3901534EE
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663269; cv=none; b=QqWwL26/8LVfFeDnCVvsKSmSnMLr4Oj/XdXTHsuyKFCn6ACJOY4EX7TG6MX7KORcfipWng49JZb7YP53vRrYRqK2a7pmwx7K51HD3enCsdzbJRYgEsRhlbqVWo6VzGpupexJbdoj5D/SsO7tEcKZg3VQKTqT/rQG+3TxCsUUmU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663269; c=relaxed/simple;
	bh=U9mWftd2RU3Ucp0RsbJrW58S2MQkyqic7qolTzm8xjg=;
	h=Date:To:From:Subject:Message-Id; b=EfI5UyBdh08PGrJLSXs/Gcmow9hPIN1OPMlYfj01bgE5bnVyhxZP0a25weAAdkY7X5/Piwl6fhAyVNQcC6dPnmgBL3NZCLvSO3mUTScduDjqyuka0YaUvfulOti22AC7Uph4sVMFfllmeFTfmaqwnNfIp6qFQhWYIv2+fR8iMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ruv8fOQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ruv8fOQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA12C4AF1A;
	Thu,  2 May 2024 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663269;
	bh=U9mWftd2RU3Ucp0RsbJrW58S2MQkyqic7qolTzm8xjg=;
	h=Date:To:From:Subject:From;
	b=Ruv8fOQyck26lSmB8saWbVYs3nPa9dcrOcVA0S3ViwkuknnHc75LiLqN/Mg1HGc4X
	 H3Z+cFUf0sCFLkLYZdXVkG4PDP93XmHMRS7rpdHjsIXKmgZGgj2xrqg2ydjl29irFw
	 b9s5XC6S3/R1DJs5f7H4f0uyL7H0+gsIta2V6GFM=
Date: Thu, 02 May 2024 08:21:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch added to mm-unstable branch
Message-Id: <20240502152108.DBA12C4AF1A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: document why hugetlb uses folio_mapcount() for COW reuse decisions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch

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
Subject: mm/hugetlb: document why hugetlb uses folio_mapcount() for COW reuse decisions
Date: Thu, 2 May 2024 10:52:59 +0200

Let's document why hugetlb still uses folio_mapcount() and is prone to
leaking memory between processes, for example using vmsplice() that still
uses FOLL_GET.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/

Link: https://lkml.kernel.org/r/20240502085259.103784-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions
+++ a/mm/hugetlb.c
@@ -5963,6 +5963,13 @@ retry_avoidcopy:
 	/*
 	 * If no-one else is actually using this page, we're the exclusive
 	 * owner and can reuse this page.
+	 *
+	 * Note that we don't rely on the (safer) folio refcount here, because
+	 * copying the hugetlb folio when there are unexpected (temporary)
+	 * folio references could harm simple fork()+exit() users when
+	 * we run out of free hugetlb folios: we would have to kill processes
+	 * in scenarios that used to work. As a side effect, there can still
+	 * be leaks between processes, for example, with FOLL_GET users.
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
 		if (!PageAnonExclusive(&old_folio->page)) {
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch
mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch

