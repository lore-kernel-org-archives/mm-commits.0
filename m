Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834822550D3
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795693; cv=none; b=OlmSJ8BDb23FFDce5TeX/NAs47g5cGgqx99BegvpinyNVX1mVWWdl0gJZiGN8MheGR6Va9DhTgwPy4/zpMG9bp7eJw7ETlBJP914pDyf+LFyiTdrINewUAE4Xg7T07Yw2NWwTvePvh51V3KVWheRuQZIQYh2hT6ze29QL2HfUUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795693; c=relaxed/simple;
	bh=Oc/Rgb7hEfxIvElC9g1DjoonxMLkHm5rLENAxM30Hqs=;
	h=Date:To:From:Subject:Message-Id; b=NaoxOtAy60+LvcI+WLXGW0mLtWgKtUGAQeLezLKiIT55E5rlG7CPIJkzeHTBp5MDm7ZUTARj6OxFIT6vkcONZuUDtCWwcKUZvaSMr7kyM/7qpo34cVkn9Mhc1H25UnMla3vRzMrcGAjTzxTdxp7mIUMoHcLleUFMQpTFftMh8z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWa1Ax9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWa1Ax9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008F0C4CEE3;
	Tue, 24 Jun 2025 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750795693;
	bh=Oc/Rgb7hEfxIvElC9g1DjoonxMLkHm5rLENAxM30Hqs=;
	h=Date:To:From:Subject:From;
	b=WWa1Ax9oVKln+IC6wTwqWo3ukt5yxkiVn7Vi985j6wApTUd+LoU22ngfNkdoWx+c/
	 CiV/dumvgtAYM1sAdraEH87TbobhgWiD0E+2szxE4veFeyfbO/iiNKxy99Z9yS/WrF
	 wzu9nLidDsEF5KMmvtGV3IAthUuINr9uOuvMP0bw=
Date: Tue, 24 Jun 2025 13:08:12 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-maps-execute-procmap_query-ioctl-under-per-vma-locks.patch added to mm-new branch
Message-Id: <20250624200813.008F0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/maps: execute PROCMAP_QUERY ioctl under per-vma locks
has been added to the -mm mm-new branch.  Its filename is
     mm-maps-execute-procmap_query-ioctl-under-per-vma-locks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-maps-execute-procmap_query-ioctl-under-per-vma-locks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/maps: execute PROCMAP_QUERY ioctl under per-vma locks
Date: Tue, 24 Jun 2025 12:33:59 -0700

Utilize per-vma locks to stabilize vma after lookup without taking
mmap_lock during PROCMAP_QUERY ioctl execution.  While we might take
mmap_lock for reading during contention, we do that momentarily only to
lock the vma.

This change is designed to reduce mmap_lock contention and prevent
PROCMAP_QUERY ioctl calls from blocking address space updates.

Link: https://lkml.kernel.org/r/20250624193359.3865351-8-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   56 +++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 12 deletions(-)

--- a/fs/proc/task_mmu.c~mm-maps-execute-procmap_query-ioctl-under-per-vma-locks
+++ a/fs/proc/task_mmu.c
@@ -492,28 +492,60 @@ static int pid_maps_open(struct inode *i
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct mm_struct *mm)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static int query_vma_setup(struct proc_maps_private *priv)
+{
+	rcu_read_lock();
+	priv->locked_vma = NULL;
+	priv->mmap_locked = false;
+
+	return 0;
+}
+
+static void query_vma_teardown(struct proc_maps_private *priv)
+{
+	unlock_vma(priv);
+	rcu_read_unlock();
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_private *priv,
+						     unsigned long addr)
+{
+	vma_iter_init(&priv->iter, priv->mm, addr);
+	return get_next_vma(priv, addr);
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static int query_vma_setup(struct proc_maps_private *priv)
 {
-	return mmap_read_lock_killable(mm);
+	return mmap_read_lock_killable(priv->mm);
 }
 
-static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
+static void query_vma_teardown(struct proc_maps_private *priv)
 {
-	mmap_read_unlock(mm);
+	mmap_read_unlock(priv->mm);
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_private *priv,
+						     unsigned long addr)
 {
-	return find_vma(mm, addr);
+	return find_vma(priv->mm, addr);
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
+#endif  /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *query_matching_vma(struct proc_maps_private *priv,
 						 unsigned long addr, u32 flags)
 {
 	struct vm_area_struct *vma;
 
 next_vma:
-	vma = query_vma_find_by_addr(mm, addr);
+	vma = query_vma_find_by_addr(priv, addr);
+	if (IS_ERR(vma))
+		return vma;
+
 	if (!vma)
 		goto no_vma;
 
@@ -589,13 +621,13 @@ static int do_procmap_query(struct proc_
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(mm);
+	err = query_vma_setup(priv);
 	if (err) {
 		mmput(mm);
 		return err;
 	}
 
-	vma = query_matching_vma(mm, karg.query_addr, karg.query_flags);
+	vma = query_matching_vma(priv, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
 		vma = NULL;
@@ -680,7 +712,7 @@ static int do_procmap_query(struct proc_
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(priv);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -700,7 +732,7 @@ static int do_procmap_query(struct proc_
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(priv);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
_

Patches currently in -mm which might be from surenb@google.com are

selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
selftests-proc-add-verbose-more-for-tests-to-facilitate-debugging.patch
mm-maps-read-proc-pid-maps-under-per-vma-lock.patch
mm-maps-execute-procmap_query-ioctl-under-per-vma-locks.patch

