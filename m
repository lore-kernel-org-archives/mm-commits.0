Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B8532B10F
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334387; cv=none; b=VTzUQbSrV846bIgdXiHz4SW4lhbAdavV5yld2cPOH+coOW55TIyjmY41AZ0uIJJs6xHtZ9mZuG1pmtGrBl1UMtV1JL5ZFWMnjBEJanMVCn/xlqCdpOqsAWlh+evxVBU50XPEp8aU1OhfqwkYdbfuzaMnhwzjZFdvOA1mmnKJDSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334387; c=relaxed/simple;
	bh=de6hGLVD28/lLnXlIKTxPNdC3MZo1/5FFksT169Ci0E=;
	h=Date:To:From:Subject:Message-Id; b=qm2EinJseS9DNgYgTWJQwQ7BBqwZxRV+AB9gnSzpE/sPzJNrDhLtpaFS12N7eidfO2eQxk5mY57JHaO2nG+9kceYeM3vhq4flST5URa397eYwmdier+g4SfAhmyNtkGWl9UTGIz7Nzudus6WHYImzkrLCFVXESBhANTuyJKhL28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L4Y12DV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L4Y12DV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D4B1F0089C;
	Wed,  7 Oct 2026 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334385;
	bh=hz6ocT/bcQuUD50yi1zMCxjIHJSfzwmCcfK8ILhDr3A=;
	h=Date:To:From:Subject;
	b=L4Y12DV8NRTByISqJXaePuXXdrS6onM2xyw/jDOPMuTD5/jYD3Ga1Haf6otkRc0iU
	 QPz4zZKolXthgJYsCOA3JH6P0q2pZBpnYFfBsMvdBB0gBbqRUfQeriWLhSXb7j380l
	 lmYVR4objKuD8S5o36OBX92YHf9aUijnnDm1+7l8=
Date: Tue, 06 Oct 2026 17:53:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch removed from -mm tree
Message-Id: <20261007005305.D3D4B1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace PF_KCOMPACTD flag with kthread_func() check
has been removed from the -mm tree.  Its filename was
     mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: replace PF_KCOMPACTD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:53 +0800

PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
nfs_release_folio() to not deadlock via kcompactd writeback") so
nfs_release_folio() could detect kcompactd context and skip writeback. 
The flag is only consumed by current_is_kcompactd(), whose sole caller is
nfs_release_folio().

Replace the flag-based check with kthread_func(current) == kcompactd,
freeing the 0x00010000 PF flag bit.

Link: https://lore.kernel.org/20260902131653.1338227-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 include/linux/compaction.h               |   11 ++++++-----
 include/linux/sched.h                    |    2 +-
 mm/compaction.c                          |    9 ++++++---
 tools/sched_ext/include/scx/common.bpf.h |    1 -
 4 files changed, 13 insertions(+), 10 deletions(-)

--- a/include/linux/compaction.h~mm-replace-pf_kcompactd-flag-with-kthread_func-check
+++ a/include/linux/compaction.h
@@ -81,10 +81,6 @@ static inline unsigned long compact_gap(
 	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
-static inline int current_is_kcompactd(void)
-{
-	return current->flags & PF_KCOMPACTD;
-}
 
 #ifdef CONFIG_COMPACTION
 
@@ -103,7 +99,7 @@ extern void compaction_defer_reset(struc
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 					int alloc_flags, gfp_t gfp_mask);
-
+bool current_is_kcompactd(void);
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
@@ -119,6 +115,11 @@ static inline bool compaction_suitable(s
 {
 	return false;
 }
+
+static inline bool current_is_kcompactd(void)
+{
+	return false;
+}
 
 static inline void kcompactd_run(int nid)
 {
--- a/include/linux/sched.h~mm-replace-pf_kcompactd-flag-with-kthread_func-check
+++ a/include/linux/sched.h
@@ -1809,7 +1809,7 @@ extern struct pid __rcu *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
+#define PF__HOLE__00010000	0x00010000
 #define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
--- a/mm/compaction.c~mm-replace-pf_kcompactd-flag-with-kthread_func-check
+++ a/mm/compaction.c
@@ -3197,7 +3197,6 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
-	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3254,11 +3253,15 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
-	current->flags &= ~PF_KCOMPACTD;
-
 	return 0;
 }
 
+bool current_is_kcompactd(void)
+{
+	return kthread_func(current) == kcompactd;
+}
+EXPORT_SYMBOL_GPL(current_is_kcompactd);
+
 /*
  * This kcompactd start function will be called by init and node-hot-add.
  * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
--- a/tools/sched_ext/include/scx/common.bpf.h~mm-replace-pf_kcompactd-flag-with-kthread_func-check
+++ a/tools/sched_ext/include/scx/common.bpf.h
@@ -31,7 +31,6 @@
 #define PF_IDLE				0x00000002	/* I am an IDLE thread */
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
-#define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch
mm-mincore-use-per-vma-lock-during-page-table-walk.patch

