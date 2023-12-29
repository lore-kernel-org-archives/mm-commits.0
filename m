Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D413FF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BRiGkMkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2E2C433C7;
	Fri, 29 Dec 2023 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880124;
	bh=TZncM+/9Tpo7iVUPBCgrvCgyxqvZgl3q3zSexWBG4dQ=;
	h=Date:To:From:Subject:From;
	b=BRiGkMkngD1yXsjd29KDih2OcMj8iDvmT3vQkQH6jsCkpykKl4pW1b+YO4JckDh42
	 7sz+PVgEQ0PnyLAwaRvXtQQ5RyD8YCn27HvO4UObQuK99XGA8VQpH4wwdnyFnDPvRq
	 qBPkt9mSNXEx8AowNnHz68C0xutHlvlxxClO7SS4=
Date: Fri, 29 Dec 2023 12:02:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-one-last-reference-to-page_add__rmap.patch removed from -mm tree
Message-Id: <20231229200204.7B2E2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove one last reference to page_add_*_rmap()
has been removed from the -mm tree.  Its filename was
     mm-remove-one-last-reference-to-page_add__rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove one last reference to page_add_*_rmap()
Date: Wed, 20 Dec 2023 23:45:04 +0100

Let's fixup one remaining comment.  Note that the only trace remaining of
the old rmap interface is in an example in Documentation/trace/ftrace.rst,
that we'll just leave alone.

Link: https://lkml.kernel.org/r/20231220224504.646757-41-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-remove-one-last-reference-to-page_add__rmap
+++ a/mm/internal.h
@@ -650,7 +650,7 @@ folio_within_vma(struct folio *folio, st
  * should be called with vma's mmap_lock held for read or write,
  * under page table lock for the pte/pmd being added or removed.
  *
- * mlock is usually called at the end of page_add_*_rmap(), munlock at
+ * mlock is usually called at the end of folio_add_*_rmap_*(), munlock at
  * the end of folio_remove_rmap_*(); but new anon folios are managed by
  * folio_add_lru_vma() calling mlock_new_folio().
  */
_

Patches currently in -mm which might be from david@redhat.com are


