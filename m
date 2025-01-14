Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5520F23C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837021; cv=none; b=tYH5eIvo3vb8zvRYRJAwbqw7cGzDYw0OZVfTIlap5l3CFo7VH24tu6ejhBDz/5Ly/m4AeOJEo8Hi/tSP/feJBxJt1gBI+HpiS/ZVFMZz/gV5zaesGqjV9uZKgFf5v8s1M/HUrGI/7ljAhfIikVR8oo3d9JrbZ04+WnWJp0dqMP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837021; c=relaxed/simple;
	bh=85lIWDK3nk9XZzBFsQqCpke/LAKjeSf54PAFQedk20w=;
	h=Date:To:From:Subject:Message-Id; b=YQuTok9LKW5TKIeCSygnupsVcuDGFhM4GLj4lppGgOZ9x4xvfB64ygvnN6jI7sB4zhK9uHL0fFITOaD9XFQ22YS5UcmI6Z0tt3peSwNYH7GWwRlHuQmo4w2GhKXAPUqlwJnXBFz01UXwHT+qpxcQHKI96dIAiU5lYi/We9SaAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/fd5MeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/fd5MeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ABDC4CEDD;
	Tue, 14 Jan 2025 06:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837021;
	bh=85lIWDK3nk9XZzBFsQqCpke/LAKjeSf54PAFQedk20w=;
	h=Date:To:From:Subject:From;
	b=Z/fd5MeAjoy5196V/vuAGx2LO5gigHblk1utSjd1lVJMhmvG1rmPzVjv+Uk5nquqk
	 Rqp1m/sx23RaSnozqJahYRjSnib5JUlC0wkCYUlbmRYITyOi7qyTriwuCoVk/rM7/k
	 BYF2uXNAnZjblANxz3LcJ/q8vzV+AaQKWtOaiR/M=
Date: Mon, 13 Jan 2025 22:43:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-mmap_lock_speculate_try_beginretry.patch removed from -mm tree
Message-Id: <20250114064341.23ABDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce mmap_lock_speculate_{try_begin|retry}
has been removed from the -mm tree.  Its filename was
     mm-introduce-mmap_lock_speculate_try_beginretry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce mmap_lock_speculate_{try_begin|retry}
Date: Fri, 22 Nov 2024 09:44:16 -0800

Add helper functions to speculatively perform operations without
read-locking mmap_lock, expecting that mmap_lock will not be
write-locked and mm is not modified from under us.

[akpm@linux-foundation.org: use read_seqcount_retry() in mmap_lock_speculate_retry(), per Wei Yang]
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
+	return read_seqcount_retry(&mm->mm_lock_seq, seq);
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

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

