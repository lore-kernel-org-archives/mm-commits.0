Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCB93B895A
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068133; cv=none; b=YWYX9Sucmis/lKKWblOSkHSUiTRm5qokrAUfwqW7kWxnYtZ57fs5S/iMB5o9LCGVbb8GkXKXpEVSXBz5NgM+PY1+6uJx66p9dH2EvVcfPp+sIh/hzK4osglzaVZxpuy3nIR0ukal391MG/vOuY6o+EZv6ZK2OUXliCjJsP04yAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068133; c=relaxed/simple;
	bh=YnaG9zJkVRyuNCpUWtPkbvdt3DygX8XdI7xDCB8OfKA=;
	h=Date:To:From:Subject:Message-Id; b=hiq0CPLo9P9F3Rges0hiceQWe9MLfyDS1EMyakCPw1O7PnKAxUmWBi+TkSYYWtNjtvREXiq7UCJZYzpofRWKXRIs8t4o25usQnYDXsEplrqjPik+mbifLJOEAJ8M1GRMsgECoxv4ejYGQRPRkye3OW8yM0O6Fvg32rmoY+jU4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LZQs78vT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LZQs78vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FB31F000E9;
	Fri,  7 Aug 2026 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068130;
	bh=5JI6i/UnL4zz5z+nw6vesOwg0EMXqlcLLWRWqLAJZog=;
	h=Date:To:From:Subject;
	b=LZQs78vTicFZDeJN8Qq0xq0PUGG7QfVJfCANsadietfMuJCx/ZGPsPgUi+zap+3YN
	 W2SbondEpKSSdGGyBoMa/tr+DKA+5DLuztdLAP5Y0GGo9TADlrgr/x5zwpMyXhNnGC
	 oCwgZfL/I+Q2MQWcwta7dlPguDMOPTiqoCmMyTk0=
Date: Thu, 06 Aug 2026 19:02:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-stable_page_flags-use-folio_test_-helpers.patch removed from -mm tree
Message-Id: <20260807020210.D5FB31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: stable_page_flags(): use folio_test_*() helpers
has been removed from the -mm tree.  Its filename was
     fs-stable_page_flags-use-folio_test_-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


