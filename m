From: akpm@linux-foundation.org
Subject: [merged] proc-speedup-proc-stat-handling.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:44 -0700
Message-ID: <20120326193244.90CDCA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58080 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2CZTcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:45 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so830938ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, linux@arm.linux.org.uk, mingo@elte.hu, pjt@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: speed up /proc/stat handling
has been removed from the -mm tree.  Its filename was
     proc-speedup-proc-stat-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: proc: speed up /proc/stat handling

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

 fs/proc/stat.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/stat.c~proc-speedup-proc-stat-handling fs/proc/stat.c
--- a/fs/proc/stat.c~proc-speedup-proc-stat-handling
+++ a/fs/proc/stat.c
@@ -157,11 +157,14 @@ static int show_stat(struct seq_file *p,
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	unsigned size = 1024 + 128 * num_possible_cpus();
 	char *buf;
 	struct seq_file *m;
 	int res;
 
+	/* minimum size to display an interrupt count : 2 bytes */
+	size += 2 * nr_irqs;
+
 	/* don't ask for more than the kmalloc() max size */
 	if (size > KMALLOC_MAX_SIZE)
 		size = KMALLOC_MAX_SIZE;
@@ -173,7 +176,7 @@ static int stat_open(struct inode *inode
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
lib-cpumaskc-remove-__any_online_cpu.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

