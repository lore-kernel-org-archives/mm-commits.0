From: akpm@linux-foundation.org
Subject: [patch 13/16] ipc: add missing container_of()s for randstruct
Date: Wed, 02 Aug 2017 13:32:21 -0700
Message-ID: <598236d5.YPxosepnMzdHEApl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdHBUcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, dave@stgolabs.net, linux@dominikbrodowski.net, manfred@colorfullife.com

From: Kees Cook <keescook@chromium.org>
Subject: ipc: add missing container_of()s for randstruct

When building with the randstruct gcc plugin, the layout of the IPC
structs will be randomized, which requires any sub-structure accesses to
use container_of().  The proc display handlers were missing the needed
container_of()s since the iterator is passing in the top-level struct
kern_ipc_perm.  This would lead to crashes when running the "lsipc"
program after the system had IPC registered (e.g.  after starting up
Gnome):

[  183.018415] general protection fault: 0000 [#1] PREEMPT SMP
...
[  183.018692] RIP: 0010:shm_add_rss_swap.isra.1+0x13/0xa0
...
[  183.019265] Call Trace:
[  183.019294]  sysvipc_shm_proc_show+0x5e/0x150
[  183.019338]  ? _raw_spin_lock+0x17/0x40
[  183.019376]  ? sysvipc_find_ipc+0xbc/0xf0
[  183.019416]  sysvipc_proc_show+0x1a/0x30
[  183.019456]  seq_read+0x2e9/0x3f0
...

Link: http://lkml.kernel.org/r/20170730205950.GA55841@beast
Fixes: 3859a271a003 ("randstruct: Mark various structs for randomization")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    3 ++-
 ipc/sem.c |    3 ++-
 ipc/shm.c |    4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff -puN ipc/msg.c~ipc-add-missing-container_ofs-for-randstruct ipc/msg.c
--- a/ipc/msg.c~ipc-add-missing-container_ofs-for-randstruct
+++ a/ipc/msg.c
@@ -1034,7 +1034,8 @@ void msg_exit_ns(struct ipc_namespace *n
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
-	struct msg_queue *msq = it;
+	struct kern_ipc_perm *ipcp = it;
+	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
 
 	seq_printf(s,
 		   "%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
diff -puN ipc/sem.c~ipc-add-missing-container_ofs-for-randstruct ipc/sem.c
--- a/ipc/sem.c~ipc-add-missing-container_ofs-for-randstruct
+++ a/ipc/sem.c
@@ -2179,7 +2179,8 @@ void exit_sem(struct task_struct *tsk)
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
-	struct sem_array *sma = it;
+	struct kern_ipc_perm *ipcp = it;
+	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 	time_t sem_otime;
 
 	/*
diff -puN ipc/shm.c~ipc-add-missing-container_ofs-for-randstruct ipc/shm.c
--- a/ipc/shm.c~ipc-add-missing-container_ofs-for-randstruct
+++ a/ipc/shm.c
@@ -1380,9 +1380,11 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
-	struct shmid_kernel *shp = it;
+	struct kern_ipc_perm *ipcp = it;
+	struct shmid_kernel *shp;
 	unsigned long rss = 0, swp = 0;
 
+	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 	shm_add_rss_swap(shp, &rss, &swp);
 
 #if BITS_PER_LONG <= 32
_
