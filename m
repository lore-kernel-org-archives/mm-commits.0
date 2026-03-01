Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7312244665
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 01:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327887; cv=none; b=OVxt9/VBAySD9uk42TYDexxIj9Ec5BfXdnCtkxYWAhf0ap9WxaybcwC+qSsKEYnoZ4X9/hpiLCSUZdFyYqxSkuucb++Sq0upsxH4VkHXhiLkanISk84uoWfGBSSJSXHxLGoPcF+IjRI3Z2hHCBcxMsLuO6xA90aStyaOOl2X/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327887; c=relaxed/simple;
	bh=DAnAdKUZWeN4sg/WPmpwuRntt8kFjfIZPqZBC+ZzsII=;
	h=Date:To:From:Subject:Message-Id; b=dmYlWLDQ2av0yL86JwFDg5VP5Vhw5n2UqtnlXtXwhEommytUYruefXZ2FTmUtJgutBH3k3QmWiZRe4Ox2ZH+D/ouqFD8DzNomSg5SZkgcJ1tj0xPYwWWkI+oDwp8AdvwfNXcgYBiuVWFXrQFVpI3+GKBRe7ah1W6o0cI5TlHxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMk59CbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMk59CbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B86C19425;
	Sun,  1 Mar 2026 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772327887;
	bh=DAnAdKUZWeN4sg/WPmpwuRntt8kFjfIZPqZBC+ZzsII=;
	h=Date:To:From:Subject:From;
	b=JMk59CbZ3HM/034dGAVqFY1QoRHj1iXTKCMkXgqveQl40oAWttFzLbVHr+sQFBvBJ
	 ZY39z4LdpHXb+iAc0FgHLfVr9vRXFmPDxto1uOZmPHt2benZklO2+XQKzWxcK0MOVn
	 FvAllnq1WAdq7t6aTJbXXhU50eG50fuIzivVlJ/0=
Date: Sat, 28 Feb 2026 17:18:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-pcpu_spin_-wrappers.patch added to mm-new branch
Message-Id: <20260301011807.68B86C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove pcpu_spin_* wrappers
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-pcpu_spin_-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-pcpu_spin_-wrappers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -112,35 +112,29 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
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

mm-page_alloc-effectively-disable-pcp-with-config_smp=n.patch
mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch
mm-page_alloc-remove-pcpu_spin_-wrappers.patch

