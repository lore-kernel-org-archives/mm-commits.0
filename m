Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828034;
	b=hzwtMCGPnXeA/gqKBfvobPP+MuKqvHm/eNTvIhZAhLqU6FIwxcPYzK0XvYiSe7RTaHap
	 uXHNVy5SVBNdeWsDv9ppFBZUqPKklyAbsWuhCbg6VQLvwtNGUaGP6Obp71k48qXNpRARw
	 pNbsg91l0nBrRKTuZKkLiJ1yJnZGffQW9l6UukPGU3YIS4ivYwellKwkGaC4XhB2xw4Fu
	 /bR5qD0eoAhZ4V9F2TrEKiy0dbRdEeruJI+ob6tRa+DhsebLg5sbVRJtGxexabNKJd50c
	 mE1heBkhYIojlKIiEzpc3MubbeMcgYPfMNC1dJ+qX/QHHkr7mmohAuEcbP7bpDaWlhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828034;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6pSWs4PzQFbFJxW2MTfPlrGoet1lrHeJFSqB2NLnPQA=;
	b=5CnJoo9SPMJtSfeARL52AOK94KzDTUg6NRj3U+ozYVsrslpv2ts8V+TiZDu+jnMr0Tzo
	 Aw8SCY7q/b41CChzNI5lT2A0JFLhF4sPkGZrpfrIDU3B3wIEzL78WyJdsppfgtdm/NyiF
	 F8p8S5VjlmAfmglHtOFGf5VYmj0HvTFEaJOG5JS4dI2q/YksGYWsmOdZW0nVNIoPyg1Xi
	 7e2YXI9D/2cIA6SUsy2UdtHebUC1wCNRo/2w7NSyIRQBFI+3SYXSSUIfre3lKUZ8t950q
	 YBcFfOyb79kyEdtPuhYJMcTnpJopKVD9yuvExeX5lGidNS6PjLlcKgOGWlp5DSg0UiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDc11v9g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941F606A322;
	Sat, 24 Oct 2026 07:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDc11v9g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A1F1F01828;
	Sat, 24 Oct 2026 07:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828033;
	bh=6pSWs4PzQFbFJxW2MTfPlrGoet1lrHeJFSqB2NLnPQA=;
	h=Date:To:From:Subject;
	b=qDc11v9gDDMfrRcqG/rhDz71Q0riivotxmHiIWeUkNgXEhHoK8xQAecRp+UAWtpjh
	 +8DOPEYoL9bPbFl66EKk7S+taFbEGMG/FEjXEyErW+m/aTBFITCNAseKO+uzutykRu
	 0AdMWxzbjZPhoVSjnaKF6YTokU4x0vAobyiIalVc=
Date: Sat, 24 Oct 2026 00:47:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-drain-quorum-work-before-removing-the-cluster.patch removed from -mm tree
Message-Id: <20261024074713.B2A1F1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: drain quorum work before removing the cluster
has been removed from the -mm tree.  Its filename was
     ocfs2-drain-quorum-work-before-removing-the-cluster.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: drain quorum work before removing the cluster
Date: Tue, 20 Oct 2026 11:45:04 +0800

The configured cluster must remain available until an in-flight quorum
decision has finished using its fencing method.  o2quo_make_decision()
drops qs_lock before calling o2quo_fence_self(), which marks heartbeat
regions for unclean stop and then reads
o2nm_single_cluster->cl_fence_method.  Cluster removal clears the
singleton without waiting for this independent system-workqueue item.

When a failed-quorum decision overlaps removal of the heartbeat regions,
nodes and cluster through configfs, the worker can be preempted after
marking the regions and resume after the singleton has been cleared:

  Quorum worker                     Configfs removal
  select fence; drop qs_lock
  o2hb_stop_all_regions()
                                    remove regions; join heartbeat threads
                                    remove nodes; stop o2net
                                    clear singleton; release cluster
  read cl_fence_method

The resumed read dereferences NULL instead of applying the configured
fencing method. The heartbeat thread's dependency protects the local
node only until the thread exits, and draining o2net does not wait for
qs_work.

Add o2quo_flush_work() to drain pending or running quorum decisions
before clearing the singleton in o2nm_cluster_group_drop_item(). By
this point the heartbeat regions and nodes have been removed, so their
work publishers are stopped. The worker can finish while the cluster
and its configured fencing method remain available. It does not acquire
the configfs mutex held by the removal path.

Keep o2quo_exit() as the counterpart of o2quo_init() for module teardown
and initialization failure, and have it call the same drain helper.
Cluster removal uses only the explicitly named drain operation.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc000000011b: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x00000000000008d8-0x00000000000008df]
    CPU: 0 UID: 0 PID: 72 Comm: kworker/0:2 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: events o2quo_make_decision
    RIP: 0010:o2quo_fence_self+0x65/0x200

Register dump omitted.

    Call Trace:
     <TASK>
     o2quo_make_decision+0x345/0x3a0
     ? __pfx_o2quo_make_decision+0x10/0x10
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in:
    ---[ end trace 0000000000000000 ]---

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0064-v5-e3870bf6571b80b07b52@gmail.com
Fixes: f6656d26d17b ("ocfs2/cluster: Make fence method configurable - v2")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/nodemanager.c |    3 +++
 fs/ocfs2/cluster/quorum.c      |    7 ++++++-
 fs/ocfs2/cluster/quorum.h      |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-drain-quorum-work-before-removing-the-cluster
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -12,6 +12,7 @@
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
+#include "quorum.h"
 #include "masklog.h"
 #include "sys.h"
 
@@ -740,6 +741,8 @@ static void o2nm_cluster_group_drop_item
 	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
 
 	BUG_ON(o2nm_single_cluster != cluster);
+	/* Drain quorum work before it loses access to the cluster. */
+	o2quo_flush_work();
 	o2nm_single_cluster = NULL;
 
 	configfs_remove_default_groups(&cluster->cl_group);
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-drain-quorum-work-before-removing-the-cluster
+++ a/fs/ocfs2/cluster/quorum.c
@@ -318,9 +318,14 @@ void o2quo_init(void)
 	INIT_WORK(&qs->qs_work, o2quo_make_decision);
 }
 
-void o2quo_exit(void)
+void o2quo_flush_work(void)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
 	flush_work(&qs->qs_work);
 }
+
+void o2quo_exit(void)
+{
+	o2quo_flush_work();
+}
--- a/fs/ocfs2/cluster/quorum.h~ocfs2-drain-quorum-work-before-removing-the-cluster
+++ a/fs/ocfs2/cluster/quorum.h
@@ -8,6 +8,7 @@
 
 void o2quo_init(void);
 void o2quo_exit(void);
+void o2quo_flush_work(void);
 
 void o2quo_hb_up(u8 node);
 void o2quo_hb_down(u8 node);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch
ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch
ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch
ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

