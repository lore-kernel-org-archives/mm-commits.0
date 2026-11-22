Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367815;
	b=TsDMxgdnVtHgnOE9voIS/hOI3Pj+DwFheyE8D0r9YwjnqZ+10TyNUEoERVH9mylIjVkM
	 7eOg9tbi3Y/6OtTrpoDQJHn1ORggOtFxBPR+Ro2xiWF2XiF2m2rRj7TNUePZyXURwdsy4
	 uprftHalwfeZuR1dPl9ENefvnmGGYKdUYw0fwmxdbPtBmqAtAarKuJ1oPO9iDZbLwIyEF
	 tsFt6y24b3JoJoPAzxb8yzDWod1D+Q20VyQzH0hx0LGJ5kwr/D6lsoHgKHDCu3FtePFVZ
	 AWW9/TvwQAQtFJkDydxjeo6Ribaq4qgij9MHHcSZysZconXHx+a+V+2IzkBzs8Akyng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367815;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=566THZGpQpjM58ddpx4z0caaTC/WpSy0h3FtbSsgpKM=;
	b=H6yDU74uENv6/PQwN1zcsZANMQG97vBNED3kcU+lm1e/HWHoPR2rTI7XILLH/6M5jeDd
	 mGfwO9piwDkSb8EWLcsa0y1evS2r0B0CwHFOh/jINxBlOrd3EmZdZua1Zg6NsXXCOpakH
	 UtXPpkK5a9AYH6Wk1NVflFWJP70JuIhcH6UGvupcNNjeHgAo5lLofmvCCUj5tr39BQK+b
	 WnA5w+LqW1ERTRRKTpsaIk1yKkyHFfUwq7tUPjKdnxY66QLzD/GM2Xgy1adWKVbFOmZRJ
	 KOWvHWOGvK+W7JJfOHMH3azk/QW63cNh43XBiLkkHAR/d4dV6emGsUFvGM66W3H9ZcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1YUCyvE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BB7606A6BA
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1YUCyvE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654BA1F00A3C;
	Sun, 22 Nov 2026 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367815;
	bh=566THZGpQpjM58ddpx4z0caaTC/WpSy0h3FtbSsgpKM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=1YUCyvE7Hp9H8ctxh8kfYRQdDRQMecL35s0i7/2kxzdhhMawsZLRntNho4hOVvuuA
	 b3h6TjeCFncrSdYPaVX/+D8BlScZ18RwnfxUSjNFrupYlxa77weAyv180rRF7WJnWK
	 bmn5li6Nl4LAGTjsQ0sbNxKaKwe7i+n03fgEb+ng=
Date: Sun, 22 Nov 2026 09:16:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhongyuan@hygon.cn,
	ying.huang@linux.alibaba.com,xhao@linux.alibaba.com,wujianyong@hygon.cn,
	wangfengyu@hygon.cn,matthew.brost@intel.com,liuyibin@hygon.cn,
	joshua.hahnjy@gmail.com,huangsj@hygon.cn,gourry@gourry.net,geshifei@hygon.cn,
	david@kernel.org,dave.hansen@linux.intel.com,byungchul@sk.com,
	apopple@nvidia.com,qiuzhiteng@hygon.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
References: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
Subject: + mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch added to mm-unstable branch
Message-Id: <20261122171655.654BA1F00A3C@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: don't batch the TLB flush when there is nothing to batch
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch

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
From: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Subject: mm/migrate: don't batch the TLB flush when there is nothing to batch
Date: Thu, 12 Nov 2026 09:03:57 +0800

NUMA balancing migrates one folio at a time, but since commit
7e12beb8ca2a ("migrate_pages: batch flushing TLB") it still unmaps
with TTU_BATCH_FLUSH like any other MIGRATE_ASYNC migration.  When the
batch contains one small folio mapped only once, there is nothing to
batch, and the batched unmap can leave mm->tlb_flush_batched pending,
so the NUMA scanner's next change_pte_range() can call flush_tlb_mm()
before changing the PTE table.  With migrations running concurrently,
that state keeps being refilled, and on this workload the scanner
often flushes the whole mm as it walks the PTE tables.

This slows scanning and keeps mm->tlb_flush_pending raised longer.  On
x86, a migration that unmaps a PROT_NONE PTE while
mm->tlb_flush_pending is set gets true from pte_accessible() and needs
a flush too; with batching, the resulting arch_tlbbatch_flush() is a
full flush.  The two feed each other.  In one run, 33% of the
migrations overlapped a scan pass, although passes covered only 9% of
the time.

On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
120 GiB anonymous working set on 4 KiB pages and 384 threads (three
balancing on/off pairs per kernel):

                                     v7.3          patched
  throughput loss from balancing     13.0-16.5%    0.5-6.3%
  TLB interrupts per migrated page   202-210       12.7-13.6
  average scanner mmu_gather time    ~90 ms        ~6.7 ms

The mmu_gather times were measured in separate instrumented runs.

So don't ask for a batched flush when the batch holds a single small
folio that is not mapped shared; try_to_migrate_one() then uses
ptep_clear_flush() for each PTE it encounters.  Large folios retain
their existing flush behavior.  migrate_pages_batch() computes the
flags, since it knows how many folios it is migrating.  PMD-mapped
THPs are not affected, since set_pmd_migration_entry() flushes them
regardless of TTU_BATCH_FLUSH.

Link: https://patch.msgid.link/20261112010357.2739389-1-qiuzhiteng@hygon.cn
Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Yuan Zhong <zhongyuan@hygon.cn>
Cc: Shifei Ge <geshifei@hygon.cn>
Cc: Jianyong Wu <wujianyong@hygon.cn>
Cc: Shijie Huang <huangsj@hygon.cn>
Cc: Yibin Liu <liuyibin@hygon.cn>
Cc: Fengyu Wang <wangfengyu@hygon.cn>
---
tl;dr: A patch-specific A/B test confirmed that this patch avoids a
deferred TLB flush for a single, privately mapped 4 KiB folio.

On A, asynchronous NUMA migration selected TTU_BATCH_FLUSH, deferred
the PTE clear, and left a pending flush that a scanner of the same mm
performed. With this patch alone, migration selected ttu=0, cleared
the PTE directly, and the scanner found no corresponding pending
flush. Migration completed with the page contents intact.

Additional tests with the complete patch set reached single-folio
migration through DAMON physical-address monitoring and direct
compaction; both changed from deferred to direct PTE clearing.
Multi-folio, intact THP, and shared-folio migrations retained batching,
as intended, and their checked contents remained intact.

A forced THP split exposed a limit of this patch alone: the final
single child still selected batching because the decision used the
original list size. The accompanying (fix) patch corrected that case.

One 30-second run per kernel recorded two scanner flushes on A and
none with the complete patch set. The runs are too small to establish
a throughput improvement.

 mm/migrate.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch
+++ a/mm/migrate.c
@@ -1229,11 +1229,28 @@ static void migrate_folio_done(struct fo
 		folio_put(src);
 }
 
+/*
+ * Batching the TLB flush only helps when the rmap walk can clear more than
+ * one PTE.  A single small folio mapped once has nothing to batch, and the
+ * batched unmap would leave mm->tlb_flush_batched pending.
+ */
+static enum ttu_flags migrate_ttu_flags(struct folio *folio,
+					enum migrate_mode mode,
+					bool single_folio)
+{
+	if (mode != MIGRATE_ASYNC)
+		return 0;
+	if (single_folio && !folio_test_large(folio) &&
+	    !folio_maybe_mapped_shared(folio))
+		return 0;
+	return TTU_BATCH_FLUSH;
+}
+
 /* Obtain the lock on page, remove all ptes. */
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		enum ttu_flags ttu, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1355,7 +1372,7 @@ static int migrate_folio_unmap(new_folio
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		try_to_migrate(src, ttu);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1846,9 +1863,11 @@ static int migrate_pages_batch(struct li
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool single_folio = list_is_singular(from);
+	enum ttu_flags ttu;
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !list_is_singular(from));
+			!list_empty(from) && !single_folio);
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
@@ -1935,8 +1954,10 @@ static int migrate_pages_batch(struct li
 				continue;
 			}
 
+			ttu = migrate_ttu_flags(folio, mode, single_folio);
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode, ttu,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
_

Patches currently in -mm which might be from qiuzhiteng@hygon.cn are

mm-migrate-dont-batch-the-tlb-flush-when-there-is-nothing-to-batch.patch

