Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DBEA2D
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 21:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751664210; cv=none; b=WV6xCgMoZiZmeD4zNJZEqbkTrJhWf7TbV7jqiqmtI7+ueADJSRPHoopcuHkTBRHb0/j1LJIbeC6H9rlmqSrzP8EI2LdD7C9+NbnpjUJfXxZoo8rpWOw7JDILEiaNoqTUcVD7x3vlxPHr1afQwzr1454+gCkItxJIgF0XTU6cEzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751664210; c=relaxed/simple;
	bh=Y1sYGuIQ1n0XED5/xmkzIpQH77q5+fqXB6IWjjjStko=;
	h=Date:To:From:Subject:Message-Id; b=aJBOIVltzToNIjuAebcyRTDKl9PFXFTvT3VJarJhbgVGnS3UcyOHY7mLi5jpwUCK5If9lP4PFf12zqHXL/Q2/agY38CWVVpIIzlcVFS7lI8J4S8I4Ug7x0FBkYPiFZtMpKZexhALVV/tfaJ96pTutkd8sVQHxvbhFpvqRGyBGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ikeSBxFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ikeSBxFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF224C4CEE3;
	Fri,  4 Jul 2025 21:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751664209;
	bh=Y1sYGuIQ1n0XED5/xmkzIpQH77q5+fqXB6IWjjjStko=;
	h=Date:To:From:Subject:From;
	b=ikeSBxFcmV30pWcpkeaLRYZXikrS/DQiKZBqe0C79qFVMLcAC71XKWebPkne2G2/O
	 V2ms/mx0StbO969fJy2jLTR6up0YW8D9qNjhqCVuHZPmc/dDFeuqmVLS9U8IcDD2lO
	 fm77Bmfqw0qRgeU5x0C6p4juy8ZIhqO1smT1VzEs=
Date: Fri, 04 Jul 2025 14:23:29 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch added to mm-new branch
Message-Id: <20250704212329.CF224C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: remove conversion of seq_file position to unsigned
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch

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
Subject: fs/proc/task_mmu: remove conversion of seq_file position to unsigned
Date: Thu, 3 Jul 2025 23:07:24 -0700

Back in 2.6 era, last_addr used to be stored in seq_file->version
variable, which was unsigned long.  As a result, sentinels to represent
gate vma and end of all vmas used unsigned values.  In more recent kernels
we don't used seq_file->version anymore and therefore conversion from
loff_t into unsigned type is not needed.  Similarly, sentinel values don't
need to be unsigned.  Remove type conversion for set_file position and
change sentinel values to signed.

Link: https://lkml.kernel.org/r/20250704060727.724817-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
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

 fs/proc/task_mmu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned
+++ a/fs/proc/task_mmu.c
@@ -135,7 +135,7 @@ static struct vm_area_struct *proc_get_v
 	if (vma) {
 		*ppos = vma->vm_start;
 	} else {
-		*ppos = -2UL;
+		*ppos = -2;
 		vma = get_gate_vma(priv->mm);
 	}
 
@@ -145,11 +145,11 @@ static struct vm_area_struct *proc_get_v
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = *ppos;
+	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
 	/* See m_next(). Zero at the start or after lseek. */
-	if (last_addr == -1UL)
+	if (last_addr == -1)
 		return NULL;
 
 	priv->task = get_proc_task(priv->inode);
@@ -170,9 +170,9 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
-	vma_iter_init(&priv->iter, mm, last_addr);
+	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
-	if (last_addr == -2UL)
+	if (last_addr == -2)
 		return get_gate_vma(mm);
 
 	return proc_get_vma(priv, ppos);
@@ -180,8 +180,8 @@ static void *m_start(struct seq_file *m,
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
-	if (*ppos == -2UL) {
-		*ppos = -1UL;
+	if (*ppos == -2) {
+		*ppos = -1;
 		return NULL;
 	}
 	return proc_get_vma(m->private, ppos);
_

Patches currently in -mm which might be from surenb@google.com are

selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
selftests-proc-add-verbose-more-for-tests-to-facilitate-debugging.patch
fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch
fs-proc-task_mmu-read-proc-pid-maps-under-per-vma-lock.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

