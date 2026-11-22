Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367836;
	b=YA2XgXxME9IwyvMoB8zM/dT2H1Y0S+edPnUVfdGwgd8juY6SHGsoAlQ+xfWIFmYn5Oi6
	 4r0E4/yyYJTvxrsd6oEL1a6LJiV5EQZxvEwmZRfUmhoEkB0lhVhkggbtkp5Tt05nDWSfX
	 MRfGqMvcmxw3pN49x4jkHGtvg1oHsU5NEWQhPMSK5SqEi+6qajX/IqfhFz8EQfmti/tpm
	 IcacB/KN4RXcsB/9sjCNoiEgye+QKnC7W87OIBeBByBlvIR/hZZptLN4Niguptl7nU+n9
	 ZWOLW1XFnh5n/lxQSYp8BZaucLUCrDrlJEq/SWbCDjQnOxCIBnCPK6hIs8uN9q00AfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367836;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1hgHOd0/5EdC79ssNvf/PMLxpY3g3kFyZw+zSm4gHqg=;
	b=AyYlJo0+iQhQzzzHaZX1IWz9v7PFVecf0jha9dGUBOR2jfd3kFjwbT1axAml/wkfOGYw
	 elc8JUlSYOIwNEkXAj/ixAnl+70LtJWiR9VrDxPwNwybL1AENzA2ItF2kq402XHzBlwKU
	 nQB5He26KJtLWGovrbONkvAOGN+tzxEtEa+B0Bj0085wM3qN+VJS+Woyc1rN+ZHAvdrQM
	 52XGncmUMt3LGypD3C0sWomRpFLA4zuCDWbzWd/Addtgt6cuMGzVRtrkFME0vzCqPWCyD
	 0GJoA2rS5v9GztbKO4rYe0vp/qXewjrZoG8SamTi5NQUom4ucpGQU9/vYZ61ooBDEjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K5IZ0VdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C98606A320
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K5IZ0VdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6391F000C0;
	Sun, 22 Nov 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367835;
	bh=1hgHOd0/5EdC79ssNvf/PMLxpY3g3kFyZw+zSm4gHqg=;
	h=Date:To:From:Subject;
	b=K5IZ0VdSSWyn/U5wqV33yJoKXzFnfiBQw6WiIdT2h9elafM0wEkQKa3zPCL5hlqop
	 OeM4qkk0CwWeOdSa9EUgQ4f146hSGV0T5MTUoDs0RW73YrS7U1WbAzXa4ggDEzU+1Y
	 3XTpjVKBlakwS0xXnYepTOL4HRu52hg+T8tGss98=
Date: Sun, 22 Nov 2026 09:17:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhongyuan@hygon.cn,
	ying.huang@linux.alibaba.com,xhao@linux.alibaba.com,wujianyong@hygon.cn,
	wangfengyu@hygon.cn,qiuzhiteng@hygon.cn,matthew.brost@intel.com,
	liuyibin@hygon.cn,joshua.hahnjy@gmail.com,huangsj@hygon.cn,gourry@gourry.net,
	geshifei@hygon.cn,david@kernel.org,dave.hansen@linux.intel.com,
	byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch removed from -mm tree
Message-Id: <20261122171715.8E6391F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: don't batch the TLB flush when there is nothing to batch (fix)
has been removed from the -mm tree.  Its filename was
     mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch-fix.patch

This patch was dropped because it was folded into mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch

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
mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch
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

