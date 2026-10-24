Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832340;
	b=T7DLeYMYYorsR6S0y/qqgXVTboydjQo02NR7JAy9qDaNJSKzh0g9knpl2UwYHlonCMt5
	 MuEUwd8+JGc/NKKAIELAHBbtG34eq8xt3Uf8u4u9Qdsj8ukdoPMd1lTaRIUBEOb9W419U
	 q+0E/p7GPUokkEhDWayWCCCnqOlX/NfIDQsthwQZg+gu6PAcY8XyuU/x0UzapVUTbCGAg
	 rTJKTwZI+8BAKc3nWZ/iE4oVEttuPysLT6mlPViElXnnnoC6hbP/meK6kQbbmjfG5mJnH
	 o4NALXM7QKV4DcO0wbFmv9FpVu3HjvP7Bu+w8wkgYeg4r4E6761Up7KYZlKrxbv8i2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832340;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PMbtj34xy8NpN/UtbrgGyz6vtkAi/IFWDTTXYLLR0iU=;
	b=HXkUGq/HAsLiiCoeO7B1GJnqQ/gt9CAL6e6Fn1egPwbNxNYIGrgDaCQC/YMe4WtU4Vlf
	 wOwGOMTQXbJbonzfUc+i4llFWMMhIGjANqGj7EpBU7H/4pjWyhvc/fIyqXYoWzFtWKeA9
	 SEyOkaNIp348PPVl5kJzeaAHSjiKiOLrwVtYxzLNHcPbbAbHMl32ucvoLN1QnqHK6SmIl
	 mDPjpdvWkUTUhmc/I+oWPsmln2dCDEeXu3Uut9BZBPcjV3fq1o21P1qhLSC2EKDtN60Br
	 ofbylvN+rUHjBfESOeuSJ3YPoAfmDCTb+d0g9t93yhErN7NzfxgjFubRUnU8K8H9BMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EH1bNTtg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9296E606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EH1bNTtg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AB01F01828;
	Sat, 24 Oct 2026 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832340;
	bh=PMbtj34xy8NpN/UtbrgGyz6vtkAi/IFWDTTXYLLR0iU=;
	h=Date:To:From:Subject;
	b=EH1bNTtgcyz40toGNWFwL77kKemaZODwYT0RESdq2LH2zZjB8BPv5x0LHdpY0XK4D
	 KPg/LeWzZukelH2uE+VdMoWYq6Uh1i/Mpm7pULOC6b3XBU7b2StGQh5bEslaqXHXkR
	 qkMvQGkz+mKonSQZhhOXuEld1H1GN891+cp4R5ZE=
Date: Sat, 24 Oct 2026 01:59:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch removed from -mm tree
Message-Id: <20261024085900.61AB01F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
has been removed from the -mm tree.  Its filename was
     mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
Date: Mon, 21 Sep 2026 21:58:58 +0200

In preparation for getting rid of SECTION_MARKED_PRESENT, rename
__highest_present_section_nr and clarify the comment.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-6-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 include/linux/mmzone.h |    6 +++---
 mm/compaction.c        |    2 +-
 mm/sparse.c            |   12 ++++--------
 mm/sparse.h            |    4 ++--
 4 files changed, 10 insertions(+), 14 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/include/linux/mmzone.h
@@ -2155,7 +2155,7 @@ static inline struct mem_section *__pfn_
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
-extern unsigned long __highest_present_section_nr;
+extern unsigned long __highest_used_section_nr;
 
 static inline int subsection_map_index(unsigned long pfn)
 {
@@ -2254,7 +2254,7 @@ static inline unsigned long first_valid_
 
 	rcu_read_lock_sched();
 
-	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
+	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
 		struct mem_section *ms = __pfn_to_section(pfn);
 
 		if (valid_section(ms) &&
@@ -2309,7 +2309,7 @@ static inline int pfn_in_present_section
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
-	while (++section_nr <= __highest_present_section_nr) {
+	while (++section_nr <= __highest_used_section_nr) {
 		if (present_section_nr(section_nr))
 			return section_nr;
 	}
--- a/mm/compaction.c~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/compaction.c
@@ -216,7 +216,7 @@ static unsigned long skip_offline_sectio
 	if (online_section_nr(start_nr))
 		return 0;
 
-	while (++start_nr <= __highest_present_section_nr) {
+	while (++start_nr <= __highest_used_section_nr) {
 		if (online_section_nr(start_nr))
 			return section_nr_to_pfn(start_nr);
 	}
--- a/mm/sparse.c~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/sparse.c
@@ -164,15 +164,11 @@ static void __init mminit_validate_memmo
 }
 
 /*
- * There are a number of times that we loop over NR_MEM_SECTIONS,
- * looking for section_present() on each.  But, when we have very
- * large physical address spaces, NR_MEM_SECTIONS can also be
- * very large which makes the loops quite long.
- *
- * Keeping track of this gives us an easy way to break out of
- * those loops early.
+ * Looping over all possible memory sections is expensive, especially if
+ * NR_MEM_SECTIONS is large but only a fraction is actually used. Keep track of
+ * the highest section number we ever used.
  */
-unsigned long __highest_present_section_nr;
+unsigned long __highest_used_section_nr;
 
 static inline unsigned long first_present_section_nr(void)
 {
--- a/mm/sparse.h~mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr
+++ a/mm/sparse.h
@@ -44,8 +44,8 @@ static inline void sparse_init_one_secti
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
+	if (section_nr > __highest_used_section_nr)
+		__highest_used_section_nr = section_nr;
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

