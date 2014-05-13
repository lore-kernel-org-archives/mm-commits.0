From: akpm@linux-foundation.org
Subject: + ipcmsg-move-some-msgq-ns-code-around.patch added to -mm tree
Date: Tue, 13 May 2014 13:39:27 -0700
Message-ID: <537282ff.ibiky4zI4PkBCEzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaEMUj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipcmsg-move-some-msgq-ns-code-around.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:39:27 -0700


The patch titled
     Subject: ipc,msg: move some msgq ns code around
has been added to the -mm tree.  Its filename is
     ipcmsg-move-some-msgq-ns-code-around.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-move-some-msgq-ns-code-around.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-move-some-msgq-ns-code-around.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: move some msgq ns code around

Nothing big and no logical changes, just get rid of some redundant
function declarations.  Move msg_[init/exit]_ns down the end of the file.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |  132 ++++++++++++++++++++++++----------------------------
 1 file changed, 63 insertions(+), 69 deletions(-)

diff -puN ipc/msg.c~ipcmsg-move-some-msgq-ns-code-around ipc/msg.c
--- a/ipc/msg.c~ipcmsg-move-some-msgq-ns-code-around
+++ a/ipc/msg.c
@@ -70,75 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
-static int newque(struct ipc_namespace *, struct ipc_params *);
-#ifdef CONFIG_PROC_FS
-static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
-#endif
-
-/*
- * Scale msgmni with the available lowmem size: the memory dedicated to msg
- * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
- * Also take into account the number of nsproxies created so far.
- * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
- */
-void recompute_msgmni(struct ipc_namespace *ns)
-{
-	struct sysinfo i;
-	unsigned long allowed;
-	int nb_ns;
-
-	si_meminfo(&i);
-	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
-		/ MSGMNB;
-	nb_ns = atomic_read(&nr_ipc_ns);
-	allowed /= nb_ns;
-
-	if (allowed < MSGMNI) {
-		ns->msg_ctlmni = MSGMNI;
-		return;
-	}
-
-	if (allowed > IPCMNI / nb_ns) {
-		ns->msg_ctlmni = IPCMNI / nb_ns;
-		return;
-	}
-
-	ns->msg_ctlmni = allowed;
-}
-
-void msg_init_ns(struct ipc_namespace *ns)
-{
-	ns->msg_ctlmax = MSGMAX;
-	ns->msg_ctlmnb = MSGMNB;
-
-	recompute_msgmni(ns);
-
-	atomic_set(&ns->msg_bytes, 0);
-	atomic_set(&ns->msg_hdrs, 0);
-	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
-}
-
-#ifdef CONFIG_IPC_NS
-void msg_exit_ns(struct ipc_namespace *ns)
-{
-	free_ipcs(ns, &msg_ids(ns), freeque);
-	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
-}
-#endif
-
-void __init msg_init(void)
-{
-	msg_init_ns(&init_ipc_ns);
-
-	printk(KERN_INFO "msgmni has been set to %d\n",
-		init_ipc_ns.msg_ctlmni);
-
-	ipc_init_proc_interface("sysvipc/msg",
-				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
-				IPC_MSG_IDS, sysvipc_msg_proc_show);
-}
-
 static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
@@ -1054,6 +985,57 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, stru
 	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
 }
 
+/*
+ * Scale msgmni with the available lowmem size: the memory dedicated to msg
+ * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
+ * Also take into account the number of nsproxies created so far.
+ * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
+ */
+void recompute_msgmni(struct ipc_namespace *ns)
+{
+	struct sysinfo i;
+	unsigned long allowed;
+	int nb_ns;
+
+	si_meminfo(&i);
+	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
+		/ MSGMNB;
+	nb_ns = atomic_read(&nr_ipc_ns);
+	allowed /= nb_ns;
+
+	if (allowed < MSGMNI) {
+		ns->msg_ctlmni = MSGMNI;
+		return;
+	}
+
+	if (allowed > IPCMNI / nb_ns) {
+		ns->msg_ctlmni = IPCMNI / nb_ns;
+		return;
+	}
+
+	ns->msg_ctlmni = allowed;
+}
+
+void msg_init_ns(struct ipc_namespace *ns)
+{
+	ns->msg_ctlmax = MSGMAX;
+	ns->msg_ctlmnb = MSGMNB;
+
+	recompute_msgmni(ns);
+
+	atomic_set(&ns->msg_bytes, 0);
+	atomic_set(&ns->msg_hdrs, 0);
+	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
+}
+
+#ifdef CONFIG_IPC_NS
+void msg_exit_ns(struct ipc_namespace *ns)
+{
+	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
+}
+#endif
+
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 {
@@ -1078,3 +1060,15 @@ static int sysvipc_msg_proc_show(struct
 			msq->q_ctime);
 }
 #endif
+
+void __init msg_init(void)
+{
+	msg_init_ns(&init_ipc_ns);
+
+	printk(KERN_INFO "msgmni has been set to %d\n",
+		init_ipc_ns.msg_ctlmni);
+
+	ipc_init_proc_interface("sysvipc/msg",
+				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
+				IPC_MSG_IDS, sysvipc_msg_proc_show);
+}
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-always-respect-msg_noerror.patch
ipcmsg-document-volatile-r_msg.patch
ipcmsg-loosen-check-for-full-queue.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

