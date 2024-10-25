Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50D1D1E75
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729897137; cv=none; b=mkOQLaFu+1333h0ROWQliMzZVmN9HAswDbZiUDRxL77AcM26uQmez1N44o/5eDOBeFDlnhnQWStqw9OM8GGpk1yfTcoyW8AOxphcjzOJZckwrug1xtm80mmHPXM5MQ7TjI6IVjkMrWVm4vgvgPKEGNqiQgFEPB+tpS4i6WdCZwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729897137; c=relaxed/simple;
	bh=x7nRMtjoBWVUyt6o48kyWSGz5Mqc2/cXujnnEDFfhKQ=;
	h=Date:To:From:Subject:Message-Id; b=n0bShNI46hPEzFLebmM96YrBSuaFfX9iLXwMx7qOrkP+z3z4RnJ+tDIuz5m21VRsG+G/86QTxCRpRHulMwZRnf1go0Rll1JKHzwX5UzusN/AMEAni+sYhLMBuC3Li9vH7kIhHBC6F6KNccvNlwFb29uwnh/h1PW6hhhwZ1LxWDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6JY+lHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6JY+lHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3112DC4CEC3;
	Fri, 25 Oct 2024 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729897137;
	bh=x7nRMtjoBWVUyt6o48kyWSGz5Mqc2/cXujnnEDFfhKQ=;
	h=Date:To:From:Subject:From;
	b=g6JY+lHlY03jsDrbLfsC/YAV/gc6vtc84TB5CyuSz1cUAQXubCdMd+e5Ygh93jnVt
	 tklGiIXCKyc583ETEP/4Ly+FbvIT1z1iYMPhLIXpwOgoIkLem+Zb+wU83PcqlUQg5t
	 6B6fbJprXbVdNYv3e17DQ7BPkXU+Fq4FeLfOfziE=
Date: Fri, 25 Oct 2024 15:58:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,oleg@redhat.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@Oracle.com,jannh@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,david@redhat.com,brauner@kernel.org,arnd@arndb.de,andrii@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-mmap_lock_speculation_beginend.patch added to mm-unstable branch
Message-Id: <20241025225857.3112DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce mmap_lock_speculation_{begin|end}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-mmap_lock_speculation_beginend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-mmap_lock_speculation_beginend.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce mmap_lock_speculation_{begin|end}
Date: Thu, 24 Oct 2024 13:52:31 -0700

Add helper functions to speculatively perform operations without
read-locking mmap_lock, expecting that mmap_lock will not be write-locked
and mm is not modified from under us.

Link: https://lkml.kernel.org/r/20241024205231.1944747-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <hca@linux.ibm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-introduce-mmap_lock_speculation_beginend
+++ a/include/linux/mmap_lock.h
@@ -71,6 +71,7 @@ static inline void mmap_assert_write_loc
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
@@ -86,11 +87,35 @@ static inline void mm_lock_seqcount_end(
 	do_raw_write_seqcount_end(&mm->mm_lock_seq);
 }
 
-#else
+static inline bool mmap_lock_speculation_begin(struct mm_struct *mm, unsigned int *seq)
+{
+	*seq = raw_read_seqcount(&mm->mm_lock_seq);
+	/* Allow speculation if mmap_lock is not write-locked */
+	return (*seq & 1) == 0;
+}
+
+static inline bool mmap_lock_speculation_end(struct mm_struct *mm, unsigned int seq)
+{
+	return !do_read_seqcount_retry(&mm->mm_lock_seq, seq);
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
 static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
 static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
-#endif
+
+static inline bool mmap_lock_speculation_begin(struct mm_struct *mm, unsigned int *seq)
+{
+	return false;
+}
+
+static inline bool mmap_lock_speculation_end(struct mm_struct *mm, unsigned int seq)
+{
+	return false;
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
 
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

