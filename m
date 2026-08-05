Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFE83BD638
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896595; cv=none; b=KKG4e+7f2gpnbPG0kLpKT0MMxxIlyYdjN2xCKlZ/bPhub7/Ypy3ZUtyuJ4JLOFzvpeamvvP/Hb3zQfKEhE+4RXQrJSTcJQg3Qk2YXhY1q7SzChjnYbQ1K/JusgqSDLL4SZi25VmKhXPU+IOLcvi1zvKEm8R9aFXVtySQP+7OB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896595; c=relaxed/simple;
	bh=v/9UCG4m+3poXlXpqNqCqBgHzz0KFj22Au8FBtSdKlA=;
	h=Date:To:From:Subject:Message-Id; b=lhX9XZ8fpNeWEpUSQ3zGuAgns5Fxdl8ac1JBfooKEGerXYakQPYao1NCbT1oAFKV4OHCdDhugfr9+vAFa750GN2Tb6qh3/BGK6gh0KAiCKIOO4f3Uf6ciAKTGDc3HlMnrgcmjbqlDOnyJxGUWdFbAApKPRAG9wxWnYqUAMszCA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkHJFz/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkHJFz/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ABC1F000E9;
	Wed,  5 Aug 2026 02:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896593;
	bh=8fZ7POUzacyFiFbl1OpgEfe62JZbqm/YP6LlgrwcgEs=;
	h=Date:To:From:Subject;
	b=xkHJFz/yyroF3XPT/uzjdWhqp17M7IQErlEzP5LFEuzcZZ/ykbQFGo5v+Izvhby8y
	 vNYtS59SajTsghPLozSzhhWs0mujdsZpTsNRwd5VJmzeAJ4ZcvZLgPsBYnmlKckNeU
	 QfC9zVCcTt6iSth2qiQXm1J/5wG2OAWJ6Kt0xHZA=
Date: Tue, 04 Aug 2026 19:23:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch removed from -mm tree
Message-Id: <20260805022313.A8ABC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
Date: Thu, 09 Jul 2026 14:06:04 -0400

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private
data can leak to new page user and cause unexpected issues.  Add a
bad_page() check at page free path for it.

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-4-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time
+++ a/mm/page_alloc.c
@@ -1377,15 +1377,23 @@ static __always_inline bool __free_pages
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *tail_page = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, tail_page);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(tail_page)) {
+					bad++;
+					continue;
+				}
+
+				if (tail_page->private) {
+					bad_page(tail_page, "nonzero private");
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (folio_test_anon(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch

