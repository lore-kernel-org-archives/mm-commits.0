Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16125F541
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970625; cv=none; b=aw4FZcnktOI4Fe5T6YDe2MkYWqJywQySgg0qURSaIj6KhC8NSDH9DUpSvto6KcNA5y/0DgU7swoeqE1bbyKIsq8W39320SYhCEbeF2aZWJKuUxbVlocRTv7YRZ3Ked3VguI4s4kpLtc+wnXpLF8cA6HUG/gLPHoRKNaFUSy+QLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970625; c=relaxed/simple;
	bh=GtYdyGhwwxsdEBUXuEat/e91TaR8X/JkTc5UyFPb94g=;
	h=Date:To:From:Subject:Message-Id; b=bPxxGwvATF1YL6ge4w7zodCcM2tzEKkUOr7yzY8ZVtteyHmfipj85gjy+OtQseVl8cROCW7GC030IfmYY9tmDtZjn3z9+QahAN0J6RJEbUjEOoi2aLHF6oEDUrayKzDL3TE9fX50D9E07w/Vua+2BE1BNTSZU8Ufem/y7RNt7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VfeEoSHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VfeEoSHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124FCC433F1;
	Tue, 23 Jan 2024 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970624;
	bh=GtYdyGhwwxsdEBUXuEat/e91TaR8X/JkTc5UyFPb94g=;
	h=Date:To:From:Subject:From;
	b=VfeEoSHmIbUMt/W+ijUAuGzidlA3ZXWitDIoAFala5iHqjFVmBPX1MqHq2ubS3fQ/
	 Jc9K2x+yk8abOmlVfkWa9Fo3AIpXGhnO+z+BY4W3/ZWbltOiGNiGc2O0NshO/ZpZrV
	 PbbTQQyWEgtS8wEEZanFBSGsnG6GCTMB9XEDjgyA=
Date: Mon, 22 Jan 2024 16:43:41 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangxingui@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,usama.anjum@collabora.com,talumbau@google.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,mgorman@techsingularity.net,mathieu.desnoyers@efficios.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,dhowells@redhat.com,dchinner@redhat.com,david@redhat.com,casey@schaufler-ca.com,brauner@kernel.org,ben.wolsieffer@hefring.com,axelrasmussen@google.com,avagin@google.com,andriy.shevchenko@linux.intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-maps-read-proc-pid-maps-under-rcu.patch added to mm-unstable branch
Message-Id: <20240123004344.124FCC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/maps: read proc/pid/maps under RCU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-maps-read-proc-pid-maps-under-rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-maps-read-proc-pid-maps-under-rcu.patch

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
Subject: mm/maps: read proc/pid/maps under RCU
Date: Sun, 21 Jan 2024 23:13:24 -0800

With maple_tree supporting vma tree traversal under RCU and per-vma locks
making vma access RCU-safe, /proc/pid/maps can be read under RCU and
without the need to read-lock mmap_lock.  However vma content can change
from under us, therefore we make a copy of the vma and we pin pointer
fields used when generating the output (currently only vm_file and
anon_name).  Afterwards we check for concurrent address space
modifications, wait for them to end and retry.  That last check is needed
to avoid possibility of missing a vma during concurrent maple_tree node
replacement, which might report a NULL when a vma is replaced with another
one.  While we take the mmap_lock for reading during such contention, we
do that momentarily only to record new mm_wr_seq counter.  This change is
designed to reduce mmap_lock contention and prevent a process reading
/proc/pid/maps files (often a low priority task, such as monitoring/data
collection services) from blocking address space updates.

Note that this change has a userspace visible disadvantage: it allows for
sub-page data tearing as opposed to the previous mechanism where data
tearing could happen only between pages of generated output data.  Since
current userspace considers data tearing between pages to be acceptable,
we assume is will be able to handle sub-page data tearing as well.

Link: https://lkml.kernel.org/r/20240122071324.2099712-3-surenb@google.com
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
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xingui Yang <yangxingui@huawei.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    2 
 fs/proc/task_mmu.c |  114 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 7 deletions(-)

--- a/fs/proc/internal.h~mm-maps-read-proc-pid-maps-under-rcu
+++ a/fs/proc/internal.h
@@ -290,6 +290,8 @@ struct proc_maps_private {
 	struct task_struct *task;
 	struct mm_struct *mm;
 	struct vma_iterator iter;
+	unsigned long mm_wr_seq;
+	struct vm_area_struct vma_copy;
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
--- a/fs/proc/task_mmu.c~mm-maps-read-proc-pid-maps-under-rcu
+++ a/fs/proc/task_mmu.c
@@ -126,11 +126,96 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
-						loff_t *ppos)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static const struct seq_operations proc_pid_maps_op;
+/*
+ * Take VMA snapshot and pin vm_file and anon_name as they are used by
+ * show_map_vma.
+ */
+static int get_vma_snapshow(struct proc_maps_private *priv, struct vm_area_struct *vma)
+{
+	struct vm_area_struct *copy = &priv->vma_copy;
+	int ret = -EAGAIN;
+
+	memcpy(copy, vma, sizeof(*vma));
+	if (copy->vm_file && !get_file_rcu(&copy->vm_file))
+		goto out;
+
+	if (copy->anon_name && !anon_vma_name_get_rcu(copy))
+		goto put_file;
+
+	if (priv->mm_wr_seq == mmap_write_seq_read(priv->mm))
+		return 0;
+
+	/* Address space got modified, vma might be stale. Wait and retry. */
+	rcu_read_unlock();
+	ret = mmap_read_lock_killable(priv->mm);
+	mmap_write_seq_record(priv->mm, &priv->mm_wr_seq);
+	mmap_read_unlock(priv->mm);
+	rcu_read_lock();
+
+	if (!ret)
+		ret = -EAGAIN; /* no other errors, ok to retry */
+
+	if (copy->anon_name)
+		anon_vma_name_put(copy->anon_name);
+put_file:
+	if (copy->vm_file)
+		fput(copy->vm_file);
+out:
+	return ret;
+}
+
+static void put_vma_snapshot(struct proc_maps_private *priv)
+{
+	struct vm_area_struct *vma = &priv->vma_copy;
+
+	if (vma->anon_name)
+		anon_vma_name_put(vma->anon_name);
+	if (vma->vm_file)
+		fput(vma->vm_file);
+}
+
+static inline bool needs_mmap_lock(struct seq_file *m)
+{
+	/*
+	 * smaps and numa_maps perform page table walk, therefore require
+	 * mmap_lock but maps can be read under RCU.
+	 */
+	return m->op != &proc_pid_maps_op;
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+/* Without per-vma locks VMA access is not RCU-safe */
+static inline bool needs_mmap_lock(struct seq_file *m) { return true; }
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {
+	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = vma_next(&priv->iter);
 
+#ifdef CONFIG_PER_VMA_LOCK
+	if (vma && !needs_mmap_lock(m)) {
+		int ret;
+
+		put_vma_snapshot(priv);
+		while ((ret = get_vma_snapshow(priv, vma)) == -EAGAIN) {
+			/* lookup the vma at the last position again */
+			vma_iter_init(&priv->iter, priv->mm, *ppos);
+			vma = vma_next(&priv->iter);
+		}
+
+		if (ret) {
+			put_vma_snapshot(priv);
+			return NULL;
+		}
+		vma = &priv->vma_copy;
+	}
+#endif
 	if (vma) {
 		*ppos = vma->vm_start;
 	} else {
@@ -169,12 +254,20 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
+	/* Drop mmap_lock if possible */
+	if (!needs_mmap_lock(m)) {
+		mmap_write_seq_record(priv->mm, &priv->mm_wr_seq);
+		mmap_read_unlock(priv->mm);
+		rcu_read_lock();
+		memset(&priv->vma_copy, 0, sizeof(priv->vma_copy));
+	}
+
 	vma_iter_init(&priv->iter, mm, last_addr);
 	hold_task_mempolicy(priv);
 	if (last_addr == -2UL)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(priv, ppos);
+	return proc_get_vma(m, ppos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
@@ -183,7 +276,7 @@ static void *m_next(struct seq_file *m,
 		*ppos = -1UL;
 		return NULL;
 	}
-	return proc_get_vma(m->private, ppos);
+	return proc_get_vma(m, ppos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -195,7 +288,10 @@ static void m_stop(struct seq_file *m, v
 		return;
 
 	release_task_mempolicy(priv);
-	mmap_read_unlock(mm);
+	if (needs_mmap_lock(m))
+		mmap_read_unlock(mm);
+	else
+		rcu_read_unlock();
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -283,8 +379,10 @@ show_map_vma(struct seq_file *m, struct
 	start = vma->vm_start;
 	end = vma->vm_end;
 	show_vma_header_prefix(m, start, end, flags, pgoff, dev, ino);
-	if (mm)
-		anon_name = anon_vma_name(vma);
+	if (mm) {
+		anon_name = needs_mmap_lock(m) ? anon_vma_name(vma) :
+				anon_vma_name_get_rcu(vma);
+	}
 
 	/*
 	 * Print the dentry name for named mappings, and a
@@ -338,6 +436,8 @@ done:
 		seq_puts(m, name);
 	}
 	seq_putc(m, '\n');
+	if (anon_name && !needs_mmap_lock(m))
+		anon_vma_name_put(anon_name);
 }
 
 static int show_map(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from surenb@google.com are

mm-make-vm_area_struct-anon_name-field-rcu-safe.patch
mm-add-mm_struct-sequence-number-to-detect-write-locks.patch
mm-maps-read-proc-pid-maps-under-rcu.patch

