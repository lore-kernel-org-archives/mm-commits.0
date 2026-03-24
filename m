Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF85C383C6A
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388670; cv=none; b=Hly8Q2QE4dw+5JEHggBbBFsYVj46WgF8z27nOHAucGFtZJnoZ1c5O0KRmjVzSahd///tJiQG8QP0FuiR3Kk6Bh8wGuV+X6CFMUYU9NRocQEnfzOvChwhFEHosCWG0xSUMa607FgjaliDBrZ+xG9wgn+CgHCiRL6JeyIasx9uEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388670; c=relaxed/simple;
	bh=8LwE+7y695dE0afV2Iz6HQ76k7ez0ymDFzcPjClksD0=;
	h=Date:To:From:Subject:Message-Id; b=cv9NxEDmDzl6UR82M5aggnrYy/JdAlQ4ACeXfQ7VxYk31lZgjg+H0SH+xFPPDqnuUyyg73c8jxK/Cqse07Z2mHc8UsITJGl9/+BVhPrvF2yBYIbEB9NcnvewHWo2HtEx+ZDjgiFBhII7lEA8DMIGb8yFmMiJNO2EjZP2p2y19M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWFdzBBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWFdzBBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EAEC2BC9E;
	Tue, 24 Mar 2026 21:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388670;
	bh=8LwE+7y695dE0afV2Iz6HQ76k7ez0ymDFzcPjClksD0=;
	h=Date:To:From:Subject:From;
	b=tWFdzBBlww/Q3LS0LZPBGQlzjoCn6xjhpFTSktakD3WLgeDxdf7/SuTskaj9/YvaJ
	 iNg2NQsFSWYaDDqkHYgVjFK6cR3QoxuECj9PqqbawVXmjY8auGJPRUeqxTM6Sn/aL7
	 b3hTmOGeMINmjANlp363GpfBUdjA406spvlcteOM=
Date: Tue, 24 Mar 2026 14:44:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-pcpu_spin_-wrappers.patch removed from -mm tree
Message-Id: <20260324214430.A7EAEC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove pcpu_spin_* wrappers
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-pcpu_spin_-wrappers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/page_alloc: remove pcpu_spin_* wrappers
Date: Fri, 27 Feb 2026 18:08:00 +0100

We only ever use pcpu_spin_trylock()/unlock() with struct per_cpu_pages so
refactor the helpers to remove the generic layer.

No functional change intended.

Link: https://lkml.kernel.org/r/20260227-b4-pcp-locking-cleanup-v1-3-f7e22e603447@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-pcpu_spin_-wrappers
+++ a/mm/page_alloc.c
@@ -111,35 +111,29 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 #endif
 
 /*
- * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
- * Return value should be used with equivalent unlock helper.
+ * A helper to lookup and trylock pcp with embedded spinlock.
+ * The return value should be used with the unlock helper.
+ * NULL return value means the trylock failed.
  */
-#define pcpu_spin_trylock(type, member, ptr)				\
+#ifdef CONFIG_SMP
+#define pcp_spin_trylock(ptr)						\
 ({									\
-	type *_ret;							\
+	struct per_cpu_pages *_ret;					\
 	pcpu_task_pin();						\
 	_ret = this_cpu_ptr(ptr);					\
-	if (!spin_trylock(&_ret->member)) {				\
+	if (!spin_trylock(&_ret->lock)) {				\
 		pcpu_task_unpin();					\
 		_ret = NULL;						\
 	}								\
 	_ret;								\
 })
 
-#define pcpu_spin_unlock(member, ptr)					\
+#define pcp_spin_unlock(ptr)						\
 ({									\
-	spin_unlock(&ptr->member);					\
+	spin_unlock(&ptr->lock);					\
 	pcpu_task_unpin();						\
 })
 
-/* struct per_cpu_pages specific helpers.*/
-#ifdef CONFIG_SMP
-#define pcp_spin_trylock(ptr)						\
-		pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
-
-#define pcp_spin_unlock(ptr)						\
-		pcpu_spin_unlock(lock, ptr)
-
 /*
  * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
  * is not compatible with our locking scheme. However we do not need pcp for
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-add-mm-related-procfs-files-to-mm-sections.patch

