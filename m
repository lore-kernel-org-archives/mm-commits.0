Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2BF4C66
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 06:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733035476; cv=none; b=MO6ONBZx2XltGMya/J4qedWenYaBF4ACYysCHHBJ5muA6HqyZ1Z0tmSko3jNchPGFF6j6pCCmKxeW/rcQGjf+QSA3edkQVi0k0wFZa/XqTXzZoC2VpmitH6bsSDtnBi34C/Rif08iFCUCOodOtjUoUltr4wsksL/Hy1HvQxc6Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733035476; c=relaxed/simple;
	bh=+163rVKkZ/ZeeLUGCewa9yfq53Pu4z7IPBnvfnQ6qjI=;
	h=Date:To:From:Subject:Message-Id; b=iijCj5i3l4WzbQJfFfa58I6nw2S7HceiD6ii8Iy6hQMDhs/bpmfOT8WuSLgrLT9CXreiswinJ4gVvEhHs2p5gdXO3TtlpApdOM1nDHQrdnu5ok9lTwmisgLaNSZGqIp8/NZKtf+2HpC/41YEKk/k1Yf/PQ6QGJH4+7IutCskD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6/YgwWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6/YgwWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32DEC4CECF;
	Sun,  1 Dec 2024 06:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733035476;
	bh=+163rVKkZ/ZeeLUGCewa9yfq53Pu4z7IPBnvfnQ6qjI=;
	h=Date:To:From:Subject:From;
	b=b6/YgwWeEwhF8MGm3Z/ms59BGiuienS4lt1vtQEKxYiTlfEwfoMPSLCyN7IJeX1S0
	 +dy85DVGQAj0ZA0HUAulfJIDwhBb2RQ3QAISlWS4XuW662xOgbqHnZiLa0myPS/37U
	 Us8tUiD3ulNs9zhMdfLUuTtj6sfoLAxzXJGN81LA=
Date: Sat, 30 Nov 2024 22:44:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,oleg@redhat.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@Oracle.com,jannh@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,david@redhat.com,brauner@kernel.org,arnd@arndb.de,andrii@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-introduce-mmap_lock_speculation_beginend.patch removed from -mm tree
Message-Id: <20241201064435.F32DEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce mmap_lock_speculation_{begin|end}
has been removed from the -mm tree.  Its filename was
     mm-introduce-mmap_lock_speculation_beginend.patch

This patch was dropped because it is obsolete

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

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch

