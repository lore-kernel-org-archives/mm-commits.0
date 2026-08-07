Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4037F3B6363
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068133; cv=none; b=c9PxbeI/DbYGE04s1/m38q/c1TMzZOWgZEWCAYL04xQb6pVJdV7yQBZeifcJMnxDbjy18VMb+E/xFJKy4a2yAxSwdNp/U6zQQqQvmgCNUdiDKy2skGkUwRRji4rciI43wdDYsG9gmd8jyxc5NjSX5HiObdFUSoH670F2PtdVhk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068133; c=relaxed/simple;
	bh=+/N1Aa3zDiR8Ag2boGLqBk5WkNLJxtOK6NPWZq4NRvA=;
	h=Date:To:From:Subject:Message-Id; b=NTQ5VxUSj0/DdFHEZD3eN0tdMI6+HpenNVMqGJEg46QW5E2XCx1WjCT18a/crjJdnknxobzNJwcl0bIKUNFZRnylzNw2bsJbtg3P5DGw9cLivzlgJM243HhMWDOghNrTDnF7dlbRYwgKEH+45ODjq7mvHpErD4qY/iUdzWecR/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEKZgeWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEKZgeWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B6F1F00A3A;
	Fri,  7 Aug 2026 02:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068132;
	bh=36chbgCdwVzwn94bXan9TLUOE9IAUHD5IodZuIn60Dk=;
	h=Date:To:From:Subject;
	b=TEKZgeWZGExbEs/dO3De0Cl62VLaKlvFXs81FSfXXrYb0koqNWooV3PWhQQsUXCuy
	 fzkDnnPQS9/EVE7UGhBkvElVrOSIIj8uglQqHLbIU14IEAqQt8dktTCBnf40zre9/k
	 zozhF+vLJwf858XIxzvDFwwvFprFUl0WlkRhLxBQ=
Date: Thu, 06 Aug 2026 19:02:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-stable_page_flags-simplify-kpf_idle-handling.patch removed from -mm tree
Message-Id: <20260807020212.13B6F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: stable_page_flags(): simplify KPF_IDLE handling
has been removed from the -mm tree.  Its filename was
     fs-stable_page_flags-simplify-kpf_idle-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs: stable_page_flags(): simplify KPF_IDLE handling
Date: Mon, 20 Jul 2026 11:30:21 +0800

For KPF_IDLE, folio_test_idle() check in set_ps_flags() already handles
all config cases, so remove the duplicate code in stable_page_flags() that
deals with CONFIG_PAGE_IDLE_FLAG for the 64‑bit case.

No functional change is intended.

Link: https://lore.kernel.org/20260720033021.4091944-4-tujinjiang@huawei.com
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

 fs/proc/page.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/proc/page.c~fs-stable_page_flags-simplify-kpf_idle-handling
+++ a/fs/proc/page.c
@@ -196,6 +196,9 @@ u64 stable_page_flags(const struct page
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
 		u |= BIT_ULL(KPF_BUDDY);
 
+	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
+		u |= BIT_ULL(KPF_IDLE);
+
 	if (folio_test_offline(folio))
 		u |= BIT_ULL(KPF_OFFLINE);
 	if (folio_test_pgtable(folio))
@@ -203,13 +206,6 @@ u64 stable_page_flags(const struct page
 	if (folio_test_slab(folio))
 		u |= BIT_ULL(KPF_SLAB);
 
-#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
-#else
-	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
-		u |= BIT_ULL(KPF_IDLE);
-#endif
-
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


