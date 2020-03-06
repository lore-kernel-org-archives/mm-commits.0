From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?memcg-fix-null-pointer-dereference-in-=5F=5Fmem=5Fcgroup=5F?=
 =?US-ASCII?Q?usage=5Funregister=5Fevent.patch?= added to -mm tree
Date: Thu, 05 Mar 2020 19:24:30 -0800
Message-ID: <20200306032430.3a6AiSD0O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCFDYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 22:24:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brookxu@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: memcg: fix NULL pointer dereference in __mem_cgroup_usage_unr=
egister_event
has been added to the -mm tree.  Its filename is
     memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_ev=
ent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-null-pointer-derefer=
ence-in-__mem_cgroup_usage_unregister_event.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-null-pointer-derefer=
ence-in-__mem_cgroup_usage_unregister_event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Chunguang Xu <brookxu@tencent.com>
Subject: memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregist=
er_event

An eventfd monitors multiple memory thresholds of the cgroup, closes them,
the kernel deletes all events related to this eventfd.  Before all events
are deleted, another eventfd monitors the memory threshold of this cgroup,
leading to a crash:

[135.675108] BUG: kernel NULL pointer dereference, address: 0000000000000004
[135.675350] #PF: supervisor write access in kernel mode
[135.675579] #PF: error_code(0x0002) - not-present page
[135.675816] PGD 800000033058e067 P4D 800000033058e067 PUD 3355ce067 PMD 0
[135.676080] Oops: 0002 [#1] SMP PTI
[135.676332] CPU: 2 PID: 14012 Comm: kworker/2:6 Kdump: loaded Not tainted =
5.6.0-rc4 #3
[135.676610] Hardware name: LENOVO 20AWS01K00/20AWS01K00, BIOS GLET70WW (2.=
24 ) 05/21/2014
[135.676909] Workqueue: events memcg_event_remove
[135.677192] RIP: 0010:__mem_cgroup_usage_unregister_event+0xb3/0x190
[135.677825] RSP: 0018:ffffb47e01c4fe18 EFLAGS: 00010202
[135.678186] RAX: 0000000000000001 RBX: ffff8bb223a8a000 RCX: 0000000000000=
001
[135.678548] RDX: 0000000000000001 RSI: ffff8bb22fb83540 RDI: 0000000000000=
001
[135.678912] RBP: ffffb47e01c4fe48 R08: 0000000000000000 R09: 0000000000000=
010
[135.679287] R10: 000000000000000c R11: 071c71c71c71c71c R12: ffff8bb226aba=
880
[135.679670] R13: ffff8bb223a8a480 R14: 0000000000000000 R15: 0000000000000=
000
[135.680066] FS:=C2=A0 0000000000000000(0000) GS:ffff8bb242680000(0000) knl=
GS:0000000000000000
[135.680475] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[135.680894] CR2: 0000000000000004 CR3: 000000032c29c003 CR4: 0000000000160=
6e0
[135.681325] Call Trace:
[135.681763]=C2=A0 memcg_event_remove+0x32/0x90
[135.682209]=C2=A0 process_one_work+0x172/0x380
[135.682657]=C2=A0 worker_thread+0x49/0x3f0
[135.683111]=C2=A0 kthread+0xf8/0x130
[135.683570]=C2=A0 ? max_active_store+0x80/0x80
[135.684034]=C2=A0 ? kthread_bind+0x10/0x10
[135.684506]=C2=A0 ret_from_fork+0x35/0x40
[135.689733] CR2: 0000000000000004

We can reproduce this problem in the following ways:

1. We create a new cgroup subdirectory and a new eventfd, and then we
   monitor multiple memory thresholds of the cgroup through this eventfd.

2.  closing this eventfd, and __mem_cgroup_usage_unregister_event ()
   will be called multiple times to delete all events related to this
   eventfd.

The first time __mem_cgroup_usage_unregister_event() is called, the kernel
will clear all items related to this eventfd in thresholds-> primary.Since
there is currently only one eventfd, thresholds-> primary becomes empty,
so the kernel will set thresholds-> primary and hresholds-> spare to NULL.
If at this time, the user creates a new eventfd and monitor the memory
threshold of this cgroup, kernel will re-initialize thresholds-> primary.=
=20
Then when __mem_cgroup_usage_unregister_event () is called for the second
time, because thresholds-> primary is not empty, the system will access
thresholds-> spare, but thresholds-> spare is NULL, which will trigger a
crash.

In general, the longer it takes to delete all events related to this
eventfd, the easier it is to trigger this problem.

The solution is to check whether the thresholds associated with the
eventfd has been cleared when deleting the event.  If so, we do nothing.

Link: http://lkml.kernel.org/r/077a6f67-aefa-4591-efec-f2f3af2b0b02@gmail.c=
om
Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-fix-null-pointer-dereference-in-__mem_cgroup_us=
age_unregister_event
+++ a/mm/memcontrol.c
@@ -4038,7 +4038,7 @@ static void __mem_cgroup_usage_unregiste
 	struct mem_cgroup_thresholds *thresholds;
 	struct mem_cgroup_threshold_ary *new;
 	unsigned long usage;
-	int i, j, size;
+	int i, j, size, entries;
=20
 	mutex_lock(&memcg->thresholds_lock);
=20
@@ -4058,14 +4058,20 @@ static void __mem_cgroup_usage_unregiste
 	__mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
=20
 	/* Calculate new number of threshold */
-	size =3D 0;
+	size =3D entries =3D 0;
 	for (i =3D 0; i < thresholds->primary->size; i++) {
 		if (thresholds->primary->entries[i].eventfd !=3D eventfd)
 			size++;
+		else
+			entries++;
 	}
=20
 	new =3D thresholds->spare;
=20
+	/* If items related to eventfd have been cleared, nothing to do */
+	if (!entries)
+		goto unlock;
+
 	/* Set thresholds array to NULL if we don't have thresholds */
 	if (!size) {
 		kfree(new);
_

Patches currently in -mm which might be from brookxu@tencent.com are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event.p=
atch
