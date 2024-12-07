Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FC4B5AE
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545762; cv=none; b=mgXETFNrb4mmArOwIS3O/GxXaEH4sRyOrlwD7r9p37PiyL0gB62jZm9ZAiPZI8Rx4yE/G13NOVlg0+79BTRLsk/eSht3tEuGbgI79zzUqf1lK6tQVoSW0H4LucjEcMsYuwOav99Bhx0h3eLLhfuFXAb5PMw3wNjS89Qbcki1ao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545762; c=relaxed/simple;
	bh=8yGNuGkEhpV/24ihv046JnyMBn0c/MeVv+R1V3lbIeY=;
	h=Date:To:From:Subject:Message-Id; b=XGruQt2ORerwp/C4YfwEwM/6Nk96yupkeMIMUr8KR0bWbrJq4GwPYujuu9kpxCilGlpYnzi1J9KA0t8Quy3ntzcKQisWIJOXoxb4aKeDuSZZNtJh8pcGvpxffcGKKOCncfsg14rNJPA4MNOS8c6hNllfKtGQq9NnLxEkR0bNcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mbPTlKg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mbPTlKg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BBC4CECD;
	Sat,  7 Dec 2024 04:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545762;
	bh=8yGNuGkEhpV/24ihv046JnyMBn0c/MeVv+R1V3lbIeY=;
	h=Date:To:From:Subject:From;
	b=mbPTlKg1J73Ro8APWlLD1GrNije9liq/T4eQsOF+TP9HW9D+enibDh2+/RTtl+je+
	 tV6GfwpkyOMaCAqQMAWe/Hsigy7GW6CbdDf9CyuUXN7Yrnhpcgg18LdFBLPv1FxOBP
	 eNfF2uzjMGDSgNvZiRYkql8tXvt4f4ssP7griuq4=
Date: Fri, 06 Dec 2024 20:29:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-mmap_lock_speculate_try_beginretry.patch added to mm-unstable branch
Message-Id: <20241207042922.291BBC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce mmap_lock_speculate_{try_begin|retry}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-mmap_lock_speculate_try_beginretry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-mmap_lock_speculate_try_beginretry.patch

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
Subject: mm: introduce mmap_lock_speculate_{try_begin|retry}
Date: Fri, 22 Nov 2024 09:44:16 -0800

Add helper functions to speculatively perform operations without
read-locking mmap_lock, expecting that mmap_lock will not be
write-locked and mm is not modified from under us.

Link: https://lkml.kernel.org/r/20241122174416.1367052-3-surenb@google.com
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-introduce-mmap_lock_speculate_try_beginretry
+++ a/include/linux/mmap_lock.h
@@ -71,6 +71,7 @@ static inline void mmap_assert_write_loc
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
@@ -87,11 +88,39 @@ static inline void mm_lock_seqcount_end(
 	do_raw_write_seqcount_end(&mm->mm_lock_seq);
 }
 
-#else
+static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, unsigned int *seq)
+{
+	/*
+	 * Since mmap_lock is a sleeping lock, and waiting for it to become
+	 * unlocked is more or less equivalent with taking it ourselves, don't
+	 * bother with the speculative path if mmap_lock is already write-locked
+	 * and take the slow path, which takes the lock.
+	 */
+	return raw_seqcount_try_begin(&mm->mm_lock_seq, *seq);
+}
+
+static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
+{
+	return do_read_seqcount_retry(&mm->mm_lock_seq, seq);
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
 static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
 static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
-#endif
+
+static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, unsigned int *seq)
+{
+	return false;
+}
+
+static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
+{
+	return true;
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
 
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch
docs-mm-document-latest-changes-to-vm_lock.patch

