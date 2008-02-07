From: akpm@linux-foundation.org
Subject: + pppol2tp-fix-printk-warnings.patch added to -mm tree
Date: Thu, 07 Feb 2008 00:48:04 -0700
Message-ID: <200802070747.m177lkVd022674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762AbYBGHs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 02:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org


The patch titled
     pppol2tp: fix printk warnings
has been added to the -mm tree.  Its filename is
     pppol2tp-fix-printk-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pppol2tp: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/pppol2tp.c: In function `pppol2tp_seq_tunnel_show':
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 4)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 5)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 6)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 7)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 8)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 9)
drivers/net/pppol2tp.c: In function `pppol2tp_seq_session_show':
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 5)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 6)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 7)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 8)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 9)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 10)

Not all platforms implement u64 with unsigned long long.  eg: powerpc.

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pppol2tp.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/net/pppol2tp.c~pppol2tp-fix-printk-warnings drivers/net/pppol2tp.c
--- a/drivers/net/pppol2tp.c~pppol2tp-fix-printk-warnings
+++ a/drivers/net/pppol2tp.c
@@ -2289,10 +2289,12 @@ static void pppol2tp_seq_tunnel_show(str
 		   atomic_read(&tunnel->ref_count) - 1);
 	seq_printf(m, " %08x %llu/%llu/%llu %llu/%llu/%llu\n",
 		   tunnel->debug,
-		   tunnel->stats.tx_packets, tunnel->stats.tx_bytes,
-		   tunnel->stats.tx_errors,
-		   tunnel->stats.rx_packets, tunnel->stats.rx_bytes,
-		   tunnel->stats.rx_errors);
+		   (unsigned long long)tunnel->stats.tx_packets,
+		   (unsigned long long)tunnel->stats.tx_bytes,
+		   (unsigned long long)tunnel->stats.tx_errors,
+		   (unsigned long long)tunnel->stats.rx_packets,
+		   (unsigned long long)tunnel->stats.rx_bytes,
+		   (unsigned long long)tunnel->stats.rx_errors);
 }
 
 static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
@@ -2320,12 +2322,12 @@ static void pppol2tp_seq_session_show(st
 		   jiffies_to_msecs(session->reorder_timeout));
 	seq_printf(m, "   %hu/%hu %llu/%llu/%llu %llu/%llu/%llu\n",
 		   session->nr, session->ns,
-		   session->stats.tx_packets,
-		   session->stats.tx_bytes,
-		   session->stats.tx_errors,
-		   session->stats.rx_packets,
-		   session->stats.rx_bytes,
-		   session->stats.rx_errors);
+		   (unsigned long long)session->stats.tx_packets,
+		   (unsigned long long)session->stats.tx_bytes,
+		   (unsigned long long)session->stats.tx_errors,
+		   (unsigned long long)session->stats.rx_packets,
+		   (unsigned long long)session->stats.rx_bytes,
+		   (unsigned long long)session->stats.rx_errors);
 }
 
 static int pppol2tp_seq_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
cpusets-update_cpumask-revision.patch
drivers-edac-add-marvell-mv64x60-driver.patch
introduce-flags-for-reserve_bootmem.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
pppol2tp-fix-printk-warnings.patch
