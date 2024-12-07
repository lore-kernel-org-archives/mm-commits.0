Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462804B5AE
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545764; cv=none; b=W4GqVz1SMPsp0Fo/lWY7jvu572YJliiTAjd6BTME9CYxnl73PQCh6oVqjF901/QE1EB9nmbkJhq4huSW7vWYBJ+9lOjZtllkOYBBartLHb/LYZx4GIQlNlbufTE2228xor7mssAWdiS4R8w7BK6EoRzPuAljc3JmRqiM/ALEcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545764; c=relaxed/simple;
	bh=MXpjGgs7J91YoIY2384QuaI6rpzx8c8mwwHsAwslpSA=;
	h=Date:To:From:Subject:Message-Id; b=MB/zpkD+dv4m4p6XkV9HWSVbrx0KDWMKSD5CDZGiPcb5wvORxCrXr6SHqw60Rqnsgf4dtP2X0PXTeKwIkBF23LuMS6IQIWtbklpF6EheOyFoGvMAecZh7P/BIZbNgLmvZNXknpywze4BaArrJRCQuvqpW9cS1vmlxBxn22v6X5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e90nYHxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e90nYHxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8741C4CECD;
	Sat,  7 Dec 2024 04:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545763;
	bh=MXpjGgs7J91YoIY2384QuaI6rpzx8c8mwwHsAwslpSA=;
	h=Date:To:From:Subject:From;
	b=e90nYHxj3VXE7BVUvP2qddLmKDgMn1L14gvI7PV8YJ6+yqzw4P/3O4BKqzdiK5M1b
	 aABpUsKG2+fhoEVQ+eOLCOjCzfGQ7vntfVauL2MmZTPn6WqOg4s9FJlXr3L1NBln5R
	 k2qruehp2rE6BhqzrZz+e96/cpCybyoh7IPr3lLE=
Date: Fri, 06 Dec 2024 20:29:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch added to mm-unstable branch
Message-Id: <20241207042923.A8741C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-mmap_lock_speculate_try_beginretry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-mmap_lock_speculate_try_beginretry-fix
Date: Fri Dec  6 08:24:17 PM PST 2024

use read_seqcount_retry() in mmap_lock_speculate_retry(), per Wei Yang

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmap_lock.h~mm-introduce-mmap_lock_speculate_try_beginretry-fix
+++ a/include/linux/mmap_lock.h
@@ -101,7 +101,7 @@ static inline bool mmap_lock_speculate_t
 
 static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
 {
-	return do_read_seqcount_retry(&mm->mm_lock_seq, seq);
+	return read_seqcount_retry(&mm->mm_lock_seq, seq);
 }
 
 #else /* CONFIG_PER_VMA_LOCK */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch

