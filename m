Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA99215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188317; cv=none; b=YImHy4uWXwvkPSwFN1bvQjlGB1Z26obcPiHCAKln8Fbw7WuV0gUcMPp3lLKciFDId2Z3YnrvQNKg157flu1JnmNzzZv1BAaQ45BelD6g8nIXLlSZJ0SRJcyezL4ovoNgh0xrlh5ZH8iCanVXgHxY4YHdIXVKk2CUFO/moISbUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188317; c=relaxed/simple;
	bh=IcU0VfKtu9V9m3EE747ahs8ow7QXi7JL4+dglVeffS4=;
	h=Date:To:From:Subject:Message-Id; b=o6u/EIaWDDFEU94rdRUec9Z1i5B8zeh+ZVzcTw8yQ8vV1x+RLVinLnQ2qWV0K82U3Sqk1FJnLuUUcECopRwzoE/7HK+Ap3qRZWYjY64tayeMPzl9S2XeL19zkRRa0AqJ5Q+6sxGZI5aIRLlxAEPX4iDsHiTZRplDDFOqZ5pK1gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D4lS7p+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D4lS7p+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD1EC4CEEC;
	Mon, 17 Mar 2025 05:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188317;
	bh=IcU0VfKtu9V9m3EE747ahs8ow7QXi7JL4+dglVeffS4=;
	h=Date:To:From:Subject:From;
	b=D4lS7p+Kpp1IKXhW0srh5y2UvygE/pn5JgTVzDBKDUdDhR4S7cWFdgDcgCm9UzPTo
	 NsQhSBe2GkpG4tk6XKYcz73b+OVu5t0rX5/liU6gEmCUWRbYdg/u7aeUczIRwPWLwA
	 bif4MZrKtpGx22euoUe0fNtCDB/24l5YYM2Uiehc=
Date: Sun, 16 Mar 2025 22:11:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-mmap_init_lock-out-of-the-header-file.patch removed from -mm tree
Message-Id: <20250317051157.6BD1EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move mmap_init_lock() out of the header file
has been removed from the -mm tree.  Its filename was
     mm-move-mmap_init_lock-out-of-the-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: move mmap_init_lock() out of the header file
Date: Thu, 13 Feb 2025 14:46:45 -0800

mmap_init_lock() is used only from mm_init() in fork.c, therefore it does
not have to reside in the header file.  This move lets us avoid including
additional headers in mmap_lock.h later, when mmap_init_lock() needs to
initialize rcuwait object.

Link: https://lkml.kernel.org/r/20250213224655.1680278-9-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    6 ------
 kernel/fork.c             |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-move-mmap_init_lock-out-of-the-header-file
+++ a/include/linux/mmap_lock.h
@@ -122,12 +122,6 @@ static inline bool mmap_lock_speculate_r
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
-static inline void mmap_init_lock(struct mm_struct *mm)
-{
-	init_rwsem(&mm->mmap_lock);
-	mm_lock_seqcount_init(mm);
-}
-
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
--- a/kernel/fork.c~mm-move-mmap_init_lock-out-of-the-header-file
+++ a/kernel/fork.c
@@ -1230,6 +1230,12 @@ static void mm_init_uprobes_state(struct
 #endif
 }
 
+static void mmap_init_lock(struct mm_struct *mm)
+{
+	init_rwsem(&mm->mmap_lock);
+	mm_lock_seqcount_init(mm);
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
_

Patches currently in -mm which might be from surenb@google.com are


