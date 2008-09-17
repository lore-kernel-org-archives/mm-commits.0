From: akpm@linux-foundation.org
Subject: + fix-vma-display-mismatch-between-proc-pid-mapssmaps.patch added to -mm tree
Date: Wed, 17 Sep 2008 16:01:42 -0700
Message-ID: <200809172301.m8HN1gaj002663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbYIQXCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 19:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, mpm@selenic.com


The patch titled
     Fix VMA display mismatch between /proc/pid/{maps,smaps}
has been added to the -mm tree.  Its filename is
     fix-vma-display-mismatch-between-proc-pid-mapssmaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix VMA display mismatch between /proc/pid/{maps,smaps}
From: Joe Korty <joe.korty@ccur.com>

Fix vma display mismatch between /proc/pid/{maps,smaps}

The following commit

    From 4752c369789250eafcd7813e11c8fb689235b0d2
    From: Matt Mackall <mpm@selenic.com>
    Date: Mon, 4 Feb 2008 22:29:02 -0800
    Subject: [PATCH] maps4: simplify interdependence of maps and smaps

broke /proc/pid/smaps, causing it to display some vmas twice and other
vmas not at all.  For example:

    grep .- /proc/1/smaps >/tmp/smaps; diff /proc/1/maps /tmp/smaps

    1  25d24
    2  < 7fd7e23aa000-7fd7e23ac000 rw-p 7fd7e23aa000 00:00 0
    3  28a28
    4  > ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0  [vsyscall]

The bug has something to do with setting m->version before all the
seq_printf's have been performed.  show_map was doing this correctly,
but show_smap was doing this in the middle of its seq_printf sequence.
This patch arranges things so that the setting of m->version in show_smap
is also done at the end of its seq_printf sequence.

Testing: in addition to the above grep test, for each process I summed
up the 'Rss' fields of /proc/pid/smaps and compared that to the 'VmRSS'
field of /proc/pid/status.  All matched except for Xorg (which has a
/dev/mem mapping which Rss accounts for but VmRSS does not).  This result
gives us some confidence that neither /proc/pid/maps nor /proc/pid/smaps
are any longer skipping or double-counting vmas.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN fs/proc/task_mmu.c~fix-vma-display-mismatch-between-proc-pid-mapssmaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fix-vma-display-mismatch-between-proc-pid-mapssmaps
+++ a/fs/proc/task_mmu.c
@@ -198,11 +198,8 @@ static int do_maps_open(struct inode *in
 	return ret;
 }
 
-static int show_map(struct seq_file *m, void *v)
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-	struct vm_area_struct *vma = v;
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
@@ -210,9 +207,6 @@ static int show_map(struct seq_file *m, 
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -257,9 +251,21 @@ static int show_map(struct seq_file *m, 
 		}
 	}
 	seq_putc(m, '\n');
+}
+
+static int show_map(struct seq_file *m, void *v)
+{
+	struct vm_area_struct *vma = v;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
+	show_map_vma(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
+		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
 	return 0;
 }
 
@@ -367,9 +373,10 @@ static int smaps_pte_range(pmd_t *pmd, u
 
 static int show_smap(struct seq_file *m, void *v)
 {
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
-	int ret;
 	struct mm_walk smaps_walk = {
 		.pmd_entry = smaps_pte_range,
 		.mm = vma->vm_mm,
@@ -381,9 +388,10 @@ static int show_smap(struct seq_file *m,
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	ret = show_map(m, v);
-	if (ret)
-		return ret;
+	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
+	show_map_vma(m, vma);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
@@ -405,7 +413,10 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.swap >> 10);
 
-	return ret;
+	if (m->count < m->size)  /* vma is copied successfully */
+		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
+
+	return 0;
 }
 
 static const struct seq_operations proc_pid_smaps_op = {
_

Patches currently in -mm which might be from joe.korty@ccur.com are

linux-next.patch
forcdeth-increase-max_interrupt_work.patch
fix-vma-display-mismatch-between-proc-pid-mapssmaps.patch
message-queues-increase-range-limits.patch
message-queues-increase-range-limits-checkpatch-fixes.patch

