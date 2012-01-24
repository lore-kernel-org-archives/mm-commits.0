From: akpm@linux-foundation.org
Subject: [nacked] proc-speedup-proc-stat-handling.patch removed from -mm tree
Date: Tue, 24 Jan 2012 14:56:19 -0800
Message-ID: <20120124225619.E5329A03EE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44246 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2AXW4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:56:22 -0500
Received: by eekb15 with SMTP id b15so185544eek.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:56:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, linux@arm.linux.org.uk, mingo@elte.hu, pjt@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc:  speedup /proc/stat handling
has been removed from the -mm tree.  Its filename was
     proc-speedup-proc-stat-handling.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: proc:  speedup /proc/stat handling

On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096 bytes,
and is slow :

# strace -T -o /tmp/STRACE cat /proc/stat | wc -c
5826
# grep "cpu " /tmp/STRACE
read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>

Thats partly because show_stat() must be called twice since initial
buffer size is too small (4096 bytes for less than 32 possible cpus)

Fix this by :

1) Taking into account nr_irqs in the initial buffer sizing.

2) Using ksize() to allow better filling of initial buffer.

3) Reduce the bloat on "intr ..." line :
   Dont output trailing " 0" values at the end of irq range.

An alternative to 1) would be to remember the largest m->count reached
in show_stat()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff -puN fs/proc/stat.c~proc-speedup-proc-stat-handling fs/proc/stat.c
--- a/fs/proc/stat.c~proc-speedup-proc-stat-handling
+++ a/fs/proc/stat.c
@@ -49,6 +49,20 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+/*
+ * Most irqs at the end of the range are never used.
+ * Find the upper limit, to not output trailing " 0" values
+ */
+static int highest_irq_used(void)
+{
+	int nr;
+
+	for (nr = nr_irqs; nr; nr--)
+		if (kstat_irqs(nr - 1))
+			break;
+	return nr;
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -129,10 +143,10 @@ static int show_stat(struct seq_file *p,
 			(unsigned long long)cputime64_to_clock_t(guest_nice));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
+	/* Note that the "sum" value can already be obsolete. */
+	j = highest_irq_used();
+	for (i = 0; i < j; i++)
+		seq_printf(p, " %u", kstat_irqs(i));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -157,14 +171,17 @@ static int show_stat(struct seq_file *p,
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	unsigned size = 1024 + 128 * num_possible_cpus();
 	char *buf;
 	struct seq_file *m;
 	int res;
 
+	/* minimum size to display a 0 count per interrupt : 2 bytes */
+	size += 2 * nr_irqs;
+
 	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
+	size = min_t(unsigned, size, KMALLOC_MAX_SIZE);
+
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -173,7 +190,7 @@ static int stat_open(struct inode *inode
 	if (!res) {
 		m = file->private_data;
 		m->buf = buf;
-		m->size = size;
+		m->size = ksize(buf);
 	} else
 		kfree(buf);
 	return res;
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch

