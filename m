Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367827;
	b=s0pIyrQcG4yfAda2gkC1+HXFE1Pq7qY4Aqi0LcZQzsmp/XgEX9oZn/XHlyXZRNsx3cME
	 TttBAX9ZR1O5eKDCs0AOYR0zJrLTULI7JrfEZQpi540ljHeRDzlUTbzKn9qvGdEZaWwff
	 nw/ICfwWjLWiM5bKQnZQR0vZrtgIRoPD9Sgj99VyLx6gnRQPGkQF1KD6nSmbF3Gcf1wmX
	 fHuNgUTareaS+Mg0DSBz8n6kJmisIczaJIb4RhbUEG+z4YDVxnBhc6OKCuOAf4f8g/ABN
	 zkKotiDakJLBtzmli5yr0FFSLUukK9Z0roE4NnlP2SnpurUhR7jZPI0DWrKzw7rxqYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367827;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ou9zmH3TstLn1bZIhOTU8Mp7OF6lBazdiiadMRKF5C4=;
	b=QtVPU7RMxgnT2JfXcgMNJ1c7exol0j5+t3K5CDqQlz++BIaE6tZUlUlHVBVm1hF+Gga3
	 PsmpRswi1C+sqQvnyh1EEH9hMNTH98YJPO6KSi2zZYTkExyfZzrq8wBJBwU1L2jpSPq4V
	 VcP6MiSaPoSK5UVD+4cCJesPYaHOVWyYg2arcEWSC434NzlzZYA1pjhTYT606WoPhNYhQ
	 +l9VqtPy93hmdo9sBK3Ibux2FsuRGhl41mSFetc468DMZnG/0/Obwx3I8HJQSivd6D3wM
	 TOFIVj0hykjHfqcDQnMu4+/CoJgvCGX2E7th9BZ7sy+5YStkzhmDHo6W8hcnxm8mY6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f2Zr3OM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8F606A331
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f2Zr3OM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376E1F000C4;
	Sun, 22 Nov 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367826;
	bh=ou9zmH3TstLn1bZIhOTU8Mp7OF6lBazdiiadMRKF5C4=;
	h=Date:To:From:Subject;
	b=f2Zr3OM0MYak4MlwMKsHCwecFeRXJe+gckZ/CqXa2Z+zctdlMAUthsfkOUeiq+ZVg
	 CL7K5ui7th45oW5uBpU0NLS9yYnWDjLsbAN7zBUZxYvFU4lujbJ8dnFhOxAUY/qVQg
	 L7Ou+Wx5cQRkRKDqxy7qU/5z+Uz/qM+TDTVZHNOo=
Date: Sun, 22 Nov 2026 09:17:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhongyuan@hygon.cn,
	ying.huang@linux.alibaba.com,xhao@linux.alibaba.com,wujianyong@hygon.cn,
	wangfengyu@hygon.cn,qiuzhiteng@hygon.cn,matthew.brost@intel.com,
	liuyibin@hygon.cn,joshua.hahnjy@gmail.com,huangsj@hygon.cn,gourry@gourry.net,
	geshifei@hygon.cn,david@kernel.org,dave.hansen@linux.intel.com,
	byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch added to mm-unstable branch
Message-Id: <20261122171706.9376E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: don't batch the TLB flush when there is nothing to batch (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/migrate: don't batch the TLB flush when there is nothing to batch (fix)
Date: Sat, 21 Nov 2026 19:10:53 -0800

Zhiteng Qiu's "[PATCH v4] mm/migrate: don't batch the TLB flush when there
is nothing to batch" avoids batched TLB flushes for an async migration of
one small folio that is not mapped shared [1].  David Hildenbrand asked
for the list to be passed to the flag helper, separate checks with
comments, and corrected indentation [2].

Pass the current from list to folio_migrate_ttu_flags() and split the
three cases that still require batching. The decision now uses the list
at the time each folio is processed instead of the list length saved
before the loop. Align the migrate_folio_unmap() arguments.

Link: https://lore.kernel.org/r/20261112010357.2739389-1-qiuzhiteng@hygon.cn [1]
Link: https://lore.kernel.org/r/011cd94f-1789-4909-83f9-4007776f1b05@kernel.org [2]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Yuan Zhong <zhongyuan@hygon.cn>
Cc: Shifei Ge <geshifei@hygon.cn>
Cc: Jianyong Wu <wujianyong@hygon.cn>
Cc: Shijie Huang <huangsj@hygon.cn>
Cc: Yibin Liu <liuyibin@hygon.cn>
Cc: Fengyu Wang <wangfengyu@hygon.cn>

 mm/migrate.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/mm/migrate.c~mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix
+++ a/mm/migrate.c
@@ -1229,21 +1229,25 @@ static void migrate_folio_done(struct fo
 		folio_put(src);
 }
 
-/*
- * Batching the TLB flush only helps when the rmap walk can clear more than
- * one PTE.  A single small folio mapped once has nothing to batch, and the
- * batched unmap would leave mm->tlb_flush_batched pending.
- */
-static enum ttu_flags migrate_ttu_flags(struct folio *folio,
-					enum migrate_mode mode,
-					bool single_folio)
+static enum ttu_flags folio_migrate_ttu_flags(struct folio *folio,
+		enum migrate_mode mode, struct list_head *from)
 {
 	if (mode != MIGRATE_ASYNC)
 		return 0;
-	if (single_folio && !folio_test_large(folio) &&
-	    !folio_maybe_mapped_shared(folio))
-		return 0;
-	return TTU_BATCH_FLUSH;
+
+	/* A batch with multiple folios can benefit from a batched flush. */
+	if (!list_is_singular(from))
+		return TTU_BATCH_FLUSH;
+
+	/* Keep the existing flush behavior for large folios. */
+	if (folio_test_large(folio))
+		return TTU_BATCH_FLUSH;
+
+	/* A shared mapping can have more than one PTE to flush. */
+	if (folio_maybe_mapped_shared(folio))
+		return TTU_BATCH_FLUSH;
+
+	return 0;
 }
 
 /* Obtain the lock on page, remove all ptes. */
@@ -1863,11 +1867,10 @@ static int migrate_pages_batch(struct li
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
-	bool single_folio = list_is_singular(from);
 	enum ttu_flags ttu;
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !single_folio);
+			!list_empty(from) && !list_is_singular(from));
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
@@ -1954,10 +1957,10 @@ static int migrate_pages_batch(struct li
 				continue;
 			}
 
-			ttu = migrate_ttu_flags(folio, mode, single_folio);
+			ttu = folio_migrate_ttu_flags(folio, mode, from);
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ttu,
-					ret_folios);
+						 private, folio, &dst, mode,
+						 ttu, ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch
mm-highmem-reject-previously-poisoned-pages-in-machine-check-copies.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

