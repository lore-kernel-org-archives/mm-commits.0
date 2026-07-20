Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956733B3BF7
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784589021; cv=none; b=UPzfvcb2M4j1VRcypH7xBLiliXTGQwvCBn91TEco7g6/7h8vYxg1U0g2UMTrV4cUnBX6ZigC0DIpOoy4euqdCaPGlsW8rHCEEk2hvG+CXng6DQjKiqoxGB2Aup9KvS9rcoSAIbIKR7Nm9dlfAXWzoA0C6ZAi/ovOnjMl6S2DPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784589021; c=relaxed/simple;
	bh=9KcLYdGBmwTDZyPabUGBg48/+do+70yZgY9IKcWdrGo=;
	h=Date:To:From:Subject:Message-Id; b=PBFLYBBHoz5UQFILzs7/cpBj0ldoinjgBzwex8L95TplqL/6o4t/4QaZ69HeAUGtbDkmkUMV7L/zPsv5udeuBzM4Xr5yhbkQx9uIuLYj5K8lmHh9l0pKQKo832Cc0Zf4GEGmM9UfCRneBTi0L2Gn2Jxqfix5UWhoZMaYlhLxg2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tU563PDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tU563PDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2555D1F000E9;
	Mon, 20 Jul 2026 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784589020;
	bh=WJGKyvxvOGBWq0iGNG0hBogiJBXCnNSCE/2j2PgfIVo=;
	h=Date:To:From:Subject;
	b=tU563PDnXhBV/ISsC40aj2Sth68cI29XW47nyfAZj6iQZLz2pr+wzRE3uY+8JD2A6
	 r5XRh05Abp4w5wT0VO68mcbMs4UfRyxSmnqlnK9i6k+X1QCCCvVq9ie26eZ1E4Ub9g
	 sgnU03/Eas02MiN+R/tmwEeUAoXQRIDyCkl9Q7Jo=
Date: Mon, 20 Jul 2026 16:10:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-stable_page_flags-use-folio_test_-helpers.patch added to mm-new branch
Message-Id: <20260720231020.2555D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: stable_page_flags(): use folio_test_*() helpers
has been added to the -mm mm-new branch.  Its filename is
     fs-stable_page_flags-use-folio_test_-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-stable_page_flags-use-folio_test_-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs: stable_page_flags(): use folio_test_*() helpers
Date: Mon, 20 Jul 2026 11:30:20 +0800

Since commit 304daa8132a9 ("maps4: add /proc/kpageflags interface"),
/proc/kpageflags directly operates on page->flags to determine page
status.  Later, commit 177975495914 ("proc: export more page flags in
/proc/kpageflags") started using page helper functions when exposing new
flags, leading to a mix of both approaches.

For tail pages, the original code did not return corresponding status. 
commit 0a71649cb724 ("/proc/kpageflags: return KPF_SLAB for slab tail
pages") and commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for
"tail" buddy pages") made tail slab/buddy pages also return corresponding
status.  Then commit dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
made all tail pages return the same status as their head page, except for
hwpoison and mapped flags.  It also cached the folio's flags and operate
on the flags directly to avoid concurrency issues if using folio_test_*()
helpers.

Since commit 476d87d6a061 ("fs: stable_page_flags(): use
snapshot_page()"), we can now safely switch to folio_test_*() helpers
instead of directly operating on flags, which is more readable and
consistent with the rest of the kernel.  Only convert cfolio-specific
flags (i.e., anon, ksm, swapcache) to folio_test_*() helpers, which
reduces redundant code.  Keep others unchanged due to they aren't
folio-specific flags or coverting them doesn't cleanup.

No functional change is intended.

Link: https://lore.kernel.org/20260720033021.4091944-3-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/proc/page.c~fs-stable_page_flags-use-folio_test_-helpers
+++ a/fs/proc/page.c
@@ -148,8 +148,6 @@ u64 stable_page_flags(const struct page
 	const struct folio *folio;
 	struct page_snapshot ps;
 	unsigned long k;
-	unsigned long mapping;
-	bool is_anon;
 	u64 u = 0;
 
 	/*
@@ -161,19 +159,16 @@ u64 stable_page_flags(const struct page
 
 	snapshot_page(&ps, page);
 	folio = &ps.folio_snapshot;
-
 	k = folio->flags.f;
-	mapping = (unsigned long)folio->mapping;
-	is_anon = mapping & FOLIO_MAPPING_ANON;
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
 	if (folio_mapped(folio))
 		u |= BIT_ULL(KPF_MMAP);
-	if (is_anon) {
+	if (folio_test_anon(folio)) {
 		u |= BIT_ULL(KPF_ANON);
-		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
+		if (folio_test_ksm(folio))
 			u |= BIT_ULL(KPF_KSM);
 	}
 
@@ -225,11 +220,10 @@ u64 stable_page_flags(const struct page
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
-#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
-	if ((k & SWAPCACHE) == SWAPCACHE)
+	if (folio_test_swapcache(folio))
 		u |= BIT_ULL(KPF_SWAPCACHE);
-	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
+	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

fs-stable_page_flags-use-bit_ull-for-kpf-flags.patch
fs-stable_page_flags-use-folio_test_-helpers.patch
fs-stable_page_flags-simplify-kpf_idle-handling.patch

