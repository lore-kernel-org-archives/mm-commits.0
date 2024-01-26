Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E80524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235315; cv=none; b=jIyqNPvJeVAsaXxLiAoYf8O7p81RVDGSzi75aMcMv47qyZMYuXtOb4HKdHSsQPRMF9RgsCnu0JMhSy/sFDMS8KXJbI+pSbM2MeS05H9682woul3ZuP8UWWWRXRc+LmuGEd3z+Pw+pD7CEIyVcUyAmQeX/QW5x2SW9X5P87wVJbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235315; c=relaxed/simple;
	bh=a1obYz66uBl2adzqberv5lj7Xl2YW8fm+1jmkjCY6Zc=;
	h=Date:To:From:Subject:Message-Id; b=cH5I2ISml4dXKd4TFkfuDFr74eAdyiUjzHtnasM54Fm8KZl4Plp3TLeZLmx53bbV12jFJ89yCEjq5F7nfH6lbM0t0b7+BuBs/a4UaRaT9xNHttV7m+hCEUEu4n7k77QZV+l8kvYMUv9m5v/2WZPIchDjMmM5JcEiLiH70e1VuMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i52loKR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i52loKR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B34AC433F1;
	Fri, 26 Jan 2024 02:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235315;
	bh=a1obYz66uBl2adzqberv5lj7Xl2YW8fm+1jmkjCY6Zc=;
	h=Date:To:From:Subject:From;
	b=i52loKR/jGQbVGD84NvSmlTAuhjbJJbT+m8TrXZAOoDrShHdItZP8+zsF9N3y8+9T
	 gUq4mKw4JvTyttM1xIsNJjicdSoZNcYR0xFuOrItQerFe7xTKJEdyiEZDIPfy5cud9
	 GgLNouK4jvYBpELPIJEs+tskYRz52+iEIQ0Y67L4=
Date: Thu, 25 Jan 2024 18:15:12 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangxingui@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,usama.anjum@collabora.com,talumbau@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,mgorman@techsingularity.net,mathieu.desnoyers@efficios.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,dhowells@redhat.com,dchinner@redhat.com,david@redhat.com,casey@schaufler-ca.com,brauner@kernel.org,ben.wolsieffer@hefring.com,axelrasmussen@google.com,avagin@google.com,andriy.shevchenko@linux.intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-mm_struct-sequence-number-to-detect-write-locks.patch removed from -mm tree
Message-Id: <20240126021514.9B34AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add mm_struct sequence number to detect write locks
has been removed from the -mm tree.  Its filename was
     mm-add-mm_struct-sequence-number-to-detect-write-locks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: add mm_struct sequence number to detect write locks
Date: Tue, 23 Jan 2024 15:10:13 -0800

Provide a way for lockless mm_struct users to detect whether mm might have
been changed since some specific point in time.  The API provided allows
the user to record a counter when it starts using the mm and later use
that counter to check if anyone write-locked mmap_lock since the counter
was recorded.  Recording the counter value should be done while holding
mmap_lock at least for reading to prevent the counter from concurrent
changes.  Every time mmap_lock is write-locked mm_struct updates its
mm_wr_seq counter so that checks against counters recorded before that
would fail, indicating a possibility of mm being modified.

Link: https://lkml.kernel.org/r/20240123231014.3801041-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrei Vagin <avagin@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xingui Yang <yangxingui@huawei.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h  |    2 ++
 include/linux/mmap_lock.h |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/include/linux/mmap_lock.h~mm-add-mm_struct-sequence-number-to-detect-write-locks
+++ a/include/linux/mmap_lock.h
@@ -106,6 +106,8 @@ static inline void mmap_write_lock(struc
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write(&mm->mmap_lock);
+	/* Pairs with ACQUIRE semantics in mmap_write_seq_read */
+	smp_store_release(&mm->mm_wr_seq, mm->mm_wr_seq + 1);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -113,6 +115,8 @@ static inline void mmap_write_lock_neste
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write_nested(&mm->mmap_lock, subclass);
+	/* Pairs with ACQUIRE semantics in mmap_write_seq_read */
+	smp_store_release(&mm->mm_wr_seq, mm->mm_wr_seq + 1);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -122,6 +126,10 @@ static inline int mmap_write_lock_killab
 
 	__mmap_lock_trace_start_locking(mm, true);
 	ret = down_write_killable(&mm->mmap_lock);
+	if (!ret) {
+		/* Pairs with ACQUIRE semantics in mmap_write_seq_read */
+		smp_store_release(&mm->mm_wr_seq, mm->mm_wr_seq + 1);
+	}
 	__mmap_lock_trace_acquire_returned(mm, true, ret == 0);
 	return ret;
 }
@@ -140,6 +148,20 @@ static inline void mmap_write_downgrade(
 	downgrade_write(&mm->mmap_lock);
 }
 
+static inline unsigned long mmap_write_seq_read(struct mm_struct *mm)
+{
+	/* Pairs with RELEASE semantics in mmap_write_lock */
+	return smp_load_acquire(&mm->mm_wr_seq);
+}
+
+static inline void mmap_write_seq_record(struct mm_struct *mm,
+					 unsigned long *mm_wr_seq)
+{
+	mmap_assert_locked(mm);
+	/* Nobody can concurrently modify since we hold the mmap_lock */
+	*mm_wr_seq = mm->mm_wr_seq;
+}
+
 static inline void mmap_read_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, false);
--- a/include/linux/mm_types.h~mm-add-mm_struct-sequence-number-to-detect-write-locks
+++ a/include/linux/mm_types.h
@@ -846,6 +846,8 @@ struct mm_struct {
 		 */
 		int mm_lock_seq;
 #endif
+		/* Counter incremented each time mm gets write-locked */
+		unsigned long mm_wr_seq;
 
 
 		unsigned long hiwater_rss; /* High-watermark of RSS usage */
_

Patches currently in -mm which might be from surenb@google.com are

mm-maps-read-proc-pid-maps-under-rcu.patch

