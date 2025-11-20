Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A4303A16
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675134; cv=none; b=B7eYPMfvL6oADBc7u+3zjMdmcpDeJqOsGNpIE3Qjai8OYsO2VoZrNtMIhteZaXjkHSC+gqf+OtJM3CBFO13u4xSsXcfoP0sN3/vs2iP2CXk4/0LeQu5coOLMY0rS91RH4CyTcnztzwme5+kIFSJLqESwUC8jliwFdwf92dQlmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675134; c=relaxed/simple;
	bh=EZezLDdF7Fi42oKT7pWi9xWGiBkePTgrBMCQwsZRPVY=;
	h=Date:To:From:Subject:Message-Id; b=mNAj9wwl+i/TY3S7jFayyjK/ENQyDbrMyLQv5fYaGElqbimCnxJqPk4ABerRwcPsWfFfjbv/Gzibw3q/YFjRlvqV9l9m2x7QzKwnRV0uDg/6fAJ+bIFLFGTcfsphEnP2G7j9D224c1WXLJjTvqHDguh/ccT/6eISRpdD4kgFwGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZCYnsmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZCYnsmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DBBC4CEF1;
	Thu, 20 Nov 2025 21:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675134;
	bh=EZezLDdF7Fi42oKT7pWi9xWGiBkePTgrBMCQwsZRPVY=;
	h=Date:To:From:Subject:From;
	b=vZCYnsmt/8bGqwt6PCfqvTCxh2floYPZtqdGU+1OG2teLcQ62qizIMzkamij+wCPU
	 paUq8ic+HoFLfM4LPAD8wU/d9wXs8g+NuD8UsDtX9N/l/94gLcnicuxZAKB5SRBJF4
	 Ci3dMQ54G3sGvAWk5dCMGu94usU2LfP3R149fuWo=
Date: Thu, 20 Nov 2025 13:45:34 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,riel@surriel.com,rakie.kim@sk.com,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,ojeda@kernel.org,nphamcs@gmail.com,npache@redhat.com,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,matthew.brost@intel.com,lkp@intel.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,gary@garyguo.net,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,bsegall@google.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-and-rename-mm-flags-function-for-clarity.patch removed from -mm tree
Message-Id: <20251120214534.93DBBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify and rename mm flags function for clarity
has been removed from the -mm tree.  Its filename was
     mm-simplify-and-rename-mm-flags-function-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: simplify and rename mm flags function for clarity
Date: Fri, 14 Nov 2025 13:26:09 +0000

The __mm_flags_set_word() function is slightly ambiguous - we use 'set' to
refer to setting individual bits (such as in mm_flags_set()) but here we
use it to refer to overwriting the value altogether.

Rename it to __mm_flags_overwrite_word() to eliminate this ambiguity.

We additionally simplify the functions, eliminating unnecessary
bitmap_xxx() operations (the compiler would have optimised these out but
it's worth being as clear as we can be here).

Link: https://lkml.kernel.org/r/a319a71d57a2af3930051c46dad954d03d55857d.1763126447.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   14 +++++---------
 kernel/fork.c            |    4 ++--
 2 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/mm_types.h~mm-simplify-and-rename-mm-flags-function-for-clarity
+++ a/include/linux/mm_types.h
@@ -1289,15 +1289,13 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-/* Set the first system word of mm flags, non-atomically. */
-static inline void __mm_flags_set_word(struct mm_struct *mm, unsigned long value)
+/* Copy value to the first system word of mm flags, non-atomically. */
+static inline void __mm_flags_overwrite_word(struct mm_struct *mm, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
-
-	bitmap_copy(bitmap, &value, BITS_PER_LONG);
+	*ACCESS_PRIVATE(&mm->flags, __mm_flags) = value;
 }
 
-/* Obtain a read-only view of the bitmap. */
+/* Obtain a read-only view of the mm flags bitmap. */
 static inline const unsigned long *__mm_flags_get_bitmap(const struct mm_struct *mm)
 {
 	return (const unsigned long *)ACCESS_PRIVATE(&mm->flags, __mm_flags);
@@ -1306,9 +1304,7 @@ static inline const unsigned long *__mm_
 /* Read the first system word of mm flags, non-atomically. */
 static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
 {
-	const unsigned long *bitmap = __mm_flags_get_bitmap(mm);
-
-	return bitmap_read(bitmap, 0, BITS_PER_LONG);
+	return *__mm_flags_get_bitmap(mm);
 }
 
 /*
--- a/kernel/fork.c~mm-simplify-and-rename-mm-flags-function-for-clarity
+++ a/kernel/fork.c
@@ -1061,10 +1061,10 @@ static struct mm_struct *mm_init(struct
 	if (current->mm) {
 		unsigned long flags = __mm_flags_get_word(current->mm);
 
-		__mm_flags_set_word(mm, mmf_init_legacy_flags(flags));
+		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
-		__mm_flags_set_word(mm, default_dump_filter);
+		__mm_flags_overwrite_word(mm, default_dump_filter);
 		mm->def_flags = 0;
 	}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch

