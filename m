Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755641EA90;
	Thu, 19 Dec 2024 03:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577541; cv=none; b=jly/SlyHAPusPaahoznhb4E4ULI1keezUtfRF14UwbMYnafsfpY/QvqzJxJCfh0tpD7pkoUxXtNhV9xJ7SKAn1M1Cou/WSQkr263FXJPnYEJdXMnNooN/iNnWSi7oyc9LleAIqsNsOPD20AtBFnNJOq6MQ9PR1c4a7XikX/gIGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577541; c=relaxed/simple;
	bh=tGl/B/HwA0uQzsA4M1JN0mIeQyoYo023gz9n/0NmB8w=;
	h=Date:To:From:Subject:Message-Id; b=Yz9m5rVbVngUmNLTokyKrV9Cs0hVqtBNnZtau2/uq1jJ/FH9Q2bx4/RNr/KMRZC3fFpvUUYym/leb73QohHP5/pOJjo7BvEVssZuEJlPHg5EtPGj5MKBUFEV9tqPS16tEqTarIqui1ID8c//RL5wyO5llFNp9MiGPoOa25Tf50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zcpiLCe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcpiLCe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD72C4CECD;
	Thu, 19 Dec 2024 03:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577541;
	bh=tGl/B/HwA0uQzsA4M1JN0mIeQyoYo023gz9n/0NmB8w=;
	h=Date:To:From:Subject:From;
	b=zcpiLCe1/HPAuZQMBKUwHhQB1ubMlhYSaOfqcd36eA3MS24de+HaX9quUZitCYEML
	 SXYGnZgpTPHsg26DpFEuUyvTqHyImWahecgkUdcRHY+As+ucLkE5Xzc2j0a8ZDsovC
	 moVqHisiVjWCsnrl5Pq6LeeiAwRJS1tpiWPkMYfQ=
Date: Wed, 18 Dec 2024 19:05:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,stable@vger.kernel.org,oliver.sang@intel.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-codetag-clear-tags-before-swap.patch removed from -mm tree
Message-Id: <20241219030540.ECD72C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/codetag: clear tags before swap
has been removed from the -mm tree.  Its filename was
     mm-codetag-clear-tags-before-swap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Wang <00107082@163.com>
Subject: mm/codetag: clear tags before swap
Date: Fri, 13 Dec 2024 09:33:32 +0800

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is set, kernel WARN would be
triggered when calling __alloc_tag_ref_set() during swap:

	alloc_tag was not cleared (got tag for mm/filemap.c:1951)
	WARNING: CPU: 0 PID: 816 at ./include/linux/alloc_tag.h...

Clear code tags before swap can fix the warning. And this patch also fix
a potential invalid address dereference in alloc_tag_add_check() when
CONFIG_MEM_ALLOC_PROFILING_DEBUG is set and ref->ct is CODETAG_EMPTY,
which is defined as ((void *)1).

Link: https://lkml.kernel.org/r/20241213013332.89910-1-00107082@163.com
Fixes: 51f43d5d82ed ("mm/codetag: swap tags when migrate pages")
Signed-off-by: David Wang <00107082@163.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412112227.df61ebb-lkp@intel.com
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 lib/alloc_tag.c           |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~mm-codetag-clear-tags-before-swap
+++ a/include/linux/alloc_tag.h
@@ -135,7 +135,7 @@ static inline struct alloc_tag_counters
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag)
 {
-	WARN_ONCE(ref && ref->ct,
+	WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
 		  "alloc_tag was not cleared (got tag for %s:%u)\n",
 		  ref->ct->filename, ref->ct->lineno);
 
--- a/lib/alloc_tag.c~mm-codetag-clear-tags-before-swap
+++ a/lib/alloc_tag.c
@@ -209,6 +209,13 @@ void pgalloc_tag_swap(struct folio *new,
 		return;
 	}
 
+	/*
+	 * Clear tag references to avoid debug warning when using
+	 * __alloc_tag_ref_set() with non-empty reference.
+	 */
+	set_codetag_empty(&ref_old);
+	set_codetag_empty(&ref_new);
+
 	/* swap tags */
 	__alloc_tag_ref_set(&ref_old, tag_new);
 	update_page_tag_ref(handle_old, &ref_old);
_

Patches currently in -mm which might be from 00107082@163.com are


