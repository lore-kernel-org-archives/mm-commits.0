From: akpm@linux-foundation.org
Subject: + ipc-remove-use-of-seq_printf-return-value.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 15:58:48 -0800
Message-ID: <54ebbeb8.8jConsgsOkRGyrc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbbBWX6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     ipc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ipc: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |   34 ++++++++++++++++++----------------
 ipc/sem.c  |   26 ++++++++++++++------------
 ipc/shm.c  |   42 ++++++++++++++++++++++--------------------
 ipc/util.c |    6 ++++--
 4 files changed, 58 insertions(+), 50 deletions(-)

diff -puN ipc/msg.c~ipc-remove-use-of-seq_printf-return-value ipc/msg.c
--- a/ipc/msg.c~ipc-remove-use-of-seq_printf-return-value
+++ a/ipc/msg.c
@@ -1015,22 +1015,24 @@ static int sysvipc_msg_proc_show(struct
 	struct user_namespace *user_ns = seq_user_ns(s);
 	struct msg_queue *msq = it;
 
-	return seq_printf(s,
-			"%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
-			msq->q_perm.key,
-			msq->q_perm.id,
-			msq->q_perm.mode,
-			msq->q_cbytes,
-			msq->q_qnum,
-			msq->q_lspid,
-			msq->q_lrpid,
-			from_kuid_munged(user_ns, msq->q_perm.uid),
-			from_kgid_munged(user_ns, msq->q_perm.gid),
-			from_kuid_munged(user_ns, msq->q_perm.cuid),
-			from_kgid_munged(user_ns, msq->q_perm.cgid),
-			msq->q_stime,
-			msq->q_rtime,
-			msq->q_ctime);
+	seq_printf(s,
+		   "%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
+		   msq->q_perm.key,
+		   msq->q_perm.id,
+		   msq->q_perm.mode,
+		   msq->q_cbytes,
+		   msq->q_qnum,
+		   msq->q_lspid,
+		   msq->q_lrpid,
+		   from_kuid_munged(user_ns, msq->q_perm.uid),
+		   from_kgid_munged(user_ns, msq->q_perm.gid),
+		   from_kuid_munged(user_ns, msq->q_perm.cuid),
+		   from_kgid_munged(user_ns, msq->q_perm.cgid),
+		   msq->q_stime,
+		   msq->q_rtime,
+		   msq->q_ctime);
+
+	return 0;
 }
 #endif
 
diff -puN ipc/sem.c~ipc-remove-use-of-seq_printf-return-value ipc/sem.c
--- a/ipc/sem.c~ipc-remove-use-of-seq_printf-return-value
+++ a/ipc/sem.c
@@ -2170,17 +2170,19 @@ static int sysvipc_sem_proc_show(struct
 
 	sem_otime = get_semotime(sma);
 
-	return seq_printf(s,
-			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
-			  sma->sem_perm.key,
-			  sma->sem_perm.id,
-			  sma->sem_perm.mode,
-			  sma->sem_nsems,
-			  from_kuid_munged(user_ns, sma->sem_perm.uid),
-			  from_kgid_munged(user_ns, sma->sem_perm.gid),
-			  from_kuid_munged(user_ns, sma->sem_perm.cuid),
-			  from_kgid_munged(user_ns, sma->sem_perm.cgid),
-			  sem_otime,
-			  sma->sem_ctime);
+	seq_printf(s,
+		   "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
+		   sma->sem_perm.key,
+		   sma->sem_perm.id,
+		   sma->sem_perm.mode,
+		   sma->sem_nsems,
+		   from_kuid_munged(user_ns, sma->sem_perm.uid),
+		   from_kgid_munged(user_ns, sma->sem_perm.gid),
+		   from_kuid_munged(user_ns, sma->sem_perm.cuid),
+		   from_kgid_munged(user_ns, sma->sem_perm.cgid),
+		   sem_otime,
+		   sma->sem_ctime);
+
+	return 0;
 }
 #endif
diff -puN ipc/shm.c~ipc-remove-use-of-seq_printf-return-value ipc/shm.c
--- a/ipc/shm.c~ipc-remove-use-of-seq_printf-return-value
+++ a/ipc/shm.c
@@ -1342,25 +1342,27 @@ static int sysvipc_shm_proc_show(struct
 #define SIZE_SPEC "%21lu"
 #endif
 
-	return seq_printf(s,
-			  "%10d %10d  %4o " SIZE_SPEC " %5u %5u  "
-			  "%5lu %5u %5u %5u %5u %10lu %10lu %10lu "
-			  SIZE_SPEC " " SIZE_SPEC "\n",
-			  shp->shm_perm.key,
-			  shp->shm_perm.id,
-			  shp->shm_perm.mode,
-			  shp->shm_segsz,
-			  shp->shm_cprid,
-			  shp->shm_lprid,
-			  shp->shm_nattch,
-			  from_kuid_munged(user_ns, shp->shm_perm.uid),
-			  from_kgid_munged(user_ns, shp->shm_perm.gid),
-			  from_kuid_munged(user_ns, shp->shm_perm.cuid),
-			  from_kgid_munged(user_ns, shp->shm_perm.cgid),
-			  shp->shm_atim,
-			  shp->shm_dtim,
-			  shp->shm_ctim,
-			  rss * PAGE_SIZE,
-			  swp * PAGE_SIZE);
+	seq_printf(s,
+		   "%10d %10d  %4o " SIZE_SPEC " %5u %5u  "
+		   "%5lu %5u %5u %5u %5u %10lu %10lu %10lu "
+		   SIZE_SPEC " " SIZE_SPEC "\n",
+		   shp->shm_perm.key,
+		   shp->shm_perm.id,
+		   shp->shm_perm.mode,
+		   shp->shm_segsz,
+		   shp->shm_cprid,
+		   shp->shm_lprid,
+		   shp->shm_nattch,
+		   from_kuid_munged(user_ns, shp->shm_perm.uid),
+		   from_kgid_munged(user_ns, shp->shm_perm.gid),
+		   from_kuid_munged(user_ns, shp->shm_perm.cuid),
+		   from_kgid_munged(user_ns, shp->shm_perm.cgid),
+		   shp->shm_atim,
+		   shp->shm_dtim,
+		   shp->shm_ctim,
+		   rss * PAGE_SIZE,
+		   swp * PAGE_SIZE);
+
+	return 0;
 }
 #endif
diff -puN ipc/util.c~ipc-remove-use-of-seq_printf-return-value ipc/util.c
--- a/ipc/util.c~ipc-remove-use-of-seq_printf-return-value
+++ a/ipc/util.c
@@ -837,8 +837,10 @@ static int sysvipc_proc_show(struct seq_
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
 
-	if (it == SEQ_START_TOKEN)
-		return seq_puts(s, iface->header);
+	if (it == SEQ_START_TOKEN) {
+		seq_puts(s, iface->header);
+		return 0;
+	}
 
 	return iface->show(s, it);
 }
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

