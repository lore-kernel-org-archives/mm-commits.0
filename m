Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02F18C08
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091433; cv=none; b=KhMW7lGDV6M+B7LXMo2dqHiwfFmNzl3orhkWULd5Uoce+4+2fJy33UTiuJmPY/zAk2MhnBCtRr31eSBdMAqRSrsN1p22AqhS83m+hKDe98wK6czRY/ZrronHruXFIkHlLxSu+8tr5XwAvpZ7pFketygWunPjzTTlP3IRNeT4FJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091433; c=relaxed/simple;
	bh=tA+/BZvZ3Ex2Jwh0v5ixu/l9WAzNXe06pwEa/dxUUAU=;
	h=Date:To:From:Subject:Message-Id; b=T7d+GEaZ7vSng8Myf1EsYt0qIXdLm57yW7VHD5dKQICFwQi7KvmRcffzeO1tZF2U2ND6KCInioFcGB9ZzoA+rvvvg/rLw0ZUeNPSKL16cgeFDKenMNQq2vDhNtkj/EaXEqlP/EkfP9Aq+vgAmvf8CTKsVOPrKs3pvKn3Tgfd3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCFOTgC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCFOTgC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AA3C433F1;
	Wed, 24 Jan 2024 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091433;
	bh=tA+/BZvZ3Ex2Jwh0v5ixu/l9WAzNXe06pwEa/dxUUAU=;
	h=Date:To:From:Subject:From;
	b=cCFOTgC5Pus1a6zjCqYIZteOWrimUwryZcuOO40+r6f58wUEIC06JIxYbpaBQLUYO
	 TRAm/1fqLZitcIDjvwIOm4orYqeJkxb8AQIwTlAFkmgVN840lIKhPj5UkbLBmPBa0H
	 n/ctuzpeJj/Ji+u5QI5ieHS09Z6xyTw9+eJZJphk=
Date: Wed, 24 Jan 2024 02:17:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangxingui@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,usama.anjum@collabora.com,talumbau@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,mgorman@techsingularity.net,mathieu.desnoyers@efficios.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,dhowells@redhat.com,dchinner@redhat.com,david@redhat.com,casey@schaufler-ca.com,brauner@kernel.org,ben.wolsieffer@hefring.com,axelrasmussen@google.com,avagin@google.com,andriy.shevchenko@linux.intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mm_struct-sequence-number-to-detect-write-locks.patch added to mm-unstable branch
Message-Id: <20240124101712.46AA3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add mm_struct sequence number to detect write locks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-mm_struct-sequence-number-to-detect-write-locks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mm_struct-sequence-number-to-detect-write-locks.patch

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

mm-make-vm_area_struct-anon_name-field-rcu-safe.patch
mm-add-mm_struct-sequence-number-to-detect-write-locks.patch
mm-maps-read-proc-pid-maps-under-rcu.patch

