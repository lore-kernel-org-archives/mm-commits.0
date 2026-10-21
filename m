Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792607984;
	b=wAKkrMHiEpXjgHnXRNXnwlYyIy8x2iwWPfOBigKs3z+hEBbSo2dfG8fzDpZnv7uRt/Ip
	 3m2xbOzG4zE4RsqXG4+xp33wjdgHmkbw34umujgDvrhVeDivJH/yDTCmYwEnlv937viE/
	 0eyYvx4Tj0ye9lc8cBQSt3HRjM/xBz+Gg38KWUmubmgYdKtt+2655aUtDdo0cI5k5rULv
	 nv2cEr/gK2Q1Gi4V2eNrNqA07gUY1v0feCmmlHH4p+p+EreHypsmTvEv7+q4G0sk7O6jD
	 GZkwfNkXPt9omPjZ3Hq2LG+TxK/r1QQPS84u/57jlH0U+Q36L9x3xs3aZ6dMlSnMpYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792607984;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=R/cyaRzWC9pd6KDI+55QfQUjuj9Ehis3S52PJ74iJxE=;
	b=iD3xE4xUNpm5WgPbqjcb5cMKD6AIllt8hDdey1AO0SscDQBs0ewRWw+iIO4RgBUnlUfP
	 l+J4Be3Znk1LC4jGvSp5pYzoRNz211J0JMoWOQRQi4Q0ob5BQL8UTVYItEeDdPi1AqfrD
	 VpN4fySTer7Bhj9JezhFV/wKbHJa9la1CJBMfhOvHePt0yQm5LPZ1TO/LQBB5+s4tMmZ8
	 /z74TMrV5Hxdv9DFE7zXZ4iiHq6AMrRy6t5w+NosDUumEnoYxK37yRmvDcK6lUjrwnfqk
	 rTnkwziqU2vLbUPNbTO7K2349u3T4/vaLPOJAqvav8rn8NIQWgOhCijCGXbxHhc6olQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JL6HFLwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F5C606A319;
	Wed, 21 Oct 2026 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JL6HFLwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E801F000C1;
	Wed, 21 Oct 2026 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792607983;
	bh=R/cyaRzWC9pd6KDI+55QfQUjuj9Ehis3S52PJ74iJxE=;
	h=Date:To:From:Subject;
	b=JL6HFLwrzsr6RLCbi06ldmbRTHHbx4/TWyX7KbvvebYj+rl1ofAcdMB2Y2U1JhKuC
	 BN3yd4l61GMj36waQTg4v+YPebj9PDHosc8aLXJWo+EdbUYgWLX7rII7c+sSHV8Ib2
	 QeGyJDFNLCqI5kKkrbUE3q6jakcdCBVOsLet26w8=
Date: Wed, 21 Oct 2026 11:39:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-drain-quorum-work-before-removing-the-cluster.patch added to mm-nonmm-unstable branch
Message-Id: <20261021183943.15E801F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: drain quorum work before removing the cluster
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-drain-quorum-work-before-removing-the-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-drain-quorum-work-before-removing-the-cluster.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-drain-quorum-work-before-removing-the-cluster.patch

