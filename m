Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD97775809
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545759; cv=none; b=JYALVT8VNWxRXtmwXYRcyTHG/Hl0r9jwArTDH+gtBtPX9kfRi9xpmOfNJE+qaWuW3zGgvXV3n3fyQbyeUQjibt3Q2PsdlXxMkNj+dEWzpfGaTKwQDpNV6KtwyHzM/UOp5s7E69syksQq3BKEZnpDUyUNfi+PshNbcJFlCOVV+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545759; c=relaxed/simple;
	bh=yF33xD3T4TDYeqiMgPSwNPCDAJ/seILn3aRgCpPIL7c=;
	h=Date:To:From:Subject:Message-Id; b=Wsotq2HE1ogJj1NjfRhlTuRYVXnnDSCDLQulCDqeY15qIGfJcqCHygFaHZsYOu59Og9RawN8ORWH/iOLtmGz0YGhMxYmaKjpcTKll3YML96u5gycgMdvX6GQ9rB0zbk/sIHU1ItmyFiKu94gPjNfu7yfgfQ4/IGYjzVk+mQ1+mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4wSlWk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4wSlWk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFCC4CECD;
	Sat,  7 Dec 2024 04:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545758;
	bh=yF33xD3T4TDYeqiMgPSwNPCDAJ/seILn3aRgCpPIL7c=;
	h=Date:To:From:Subject:From;
	b=E4wSlWk4ABAaiTjYnQqiB2jl+KM9LBQPGBihK4wX6x3BsbjehNeOrbSKVERSKAk6k
	 iXOvOSG2+nfyKheZeMObfZWSt/6Qp//tKXIeLkFStW3ZN5RgRNLcfB/HTFftOakfCq
	 yMDFvchk6njvZuPCrM243UXYwc7ihDpleM9Jer08=
Date: Fri, 06 Dec 2024 20:29:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + seqlock-add-raw_seqcount_try_begin.patch added to mm-unstable branch
Message-Id: <20241207042918.1EAFCC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: seqlock: add raw_seqcount_try_begin
has been added to the -mm mm-unstable branch.  Its filename is
     seqlock-add-raw_seqcount_try_begin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seqlock-add-raw_seqcount_try_begin.patch

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
Subject: seqlock: add raw_seqcount_try_begin
Date: Fri, 22 Nov 2024 09:44:14 -0800

Add raw_seqcount_try_begin() to opens a read critical section of the given
seqcount_t if the counter is even. This enables eliding the critical
section entirely if the counter is odd, instead of doing the speculation
knowing it will fail.

Link: https://lkml.kernel.org/r/20241122174416.1367052-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
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

 include/linux/seqlock.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/seqlock.h~seqlock-add-raw_seqcount_try_begin
+++ a/include/linux/seqlock.h
@@ -319,6 +319,28 @@ SEQCOUNT_LOCKNAME(mutex,        struct m
 })
 
 /**
+ * raw_seqcount_try_begin() - begin a seqcount_t read critical section
+ *                            w/o lockdep and w/o counter stabilization
+ * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
+ *
+ * Similar to raw_seqcount_begin(), except it enables eliding the critical
+ * section entirely if odd, instead of doing the speculation knowing it will
+ * fail.
+ *
+ * Useful when counter stabilization is more or less equivalent to taking
+ * the lock and there is a slowpath that does that.
+ *
+ * If true, start will be set to the (even) sequence count read.
+ *
+ * Return: true when a read critical section is started.
+ */
+#define raw_seqcount_try_begin(s, start)				\
+({									\
+	start = raw_read_seqcount(s);					\
+	!(start & 1);							\
+})
+
+/**
  * raw_seqcount_begin() - begin a seqcount_t read critical section w/o
  *                        lockdep and w/o counter stabilization
  * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
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

