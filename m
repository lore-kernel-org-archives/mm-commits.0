From: akpm@linux-foundation.org
Subject: + mm-add-anon_vma_lock-to-validate_mm.patch added to -mm tree
Date: Tue, 06 Nov 2012 13:30:29 -0800
Message-ID: <20121106213030.34CE05C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47155 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2KFVac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 16:30:32 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so64589wey.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 13:30:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, lliubbo@gmail.com, riel@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: mm: add anon_vma_lock to validate_mm()
has been added to the -mm tree.  Its filename is
     mm-add-anon_vma_lock-to-validate_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: add anon_vma_lock to validate_mm()

Iterating over the vma->anon_vma_chain without anon_vma_lock may cause
NULL ptr deref in anon_vma_interval_tree_verify(), because the node in the
chain might have been removed.

[ 1523.657950] BUG: unable to handle kernel paging request at fffffffffffffff0
[ 1523.660022] IP: [<ffffffff8122c29c>] anon_vma_interval_tree_verify+0xc/0xa0
[ 1523.660022] PGD 4e28067 PUD 4e29067 PMD 0
[ 1523.675725] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1523.750066] CPU 0
[ 1523.750066] Pid: 9050, comm: trinity-child64 Tainted: G        W    3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #77
[ 1523.750066] RIP: 0010:[<ffffffff8122c29c>]  [<ffffffff8122c29c>] anon_vma_interval_tree_verify+0xc/0xa0
[ 1523.750066] RSP: 0018:ffff880045f81d48  EFLAGS: 00010296
[ 1523.750066] RAX: 0000000000000000 RBX: fffffffffffffff0 RCX: 0000000000000000
[ 1523.750066] RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff0
[ 1523.750066] RBP: ffff880045f81d58 R08: 0000000000000000 R09: 0000000000000f14
[ 1523.750066] R10: 0000000000000f12 R11: 0000000000000000 R12: ffff8800096c8d70
[ 1523.750066] R13: ffff8800096c8d00 R14: 0000000000000000 R15: ffff8800095b45e0
[ 1523.750066] FS:  00007f7a923f3700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[ 1523.750066] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1523.750066] CR2: fffffffffffffff0 CR3: 000000000969d000 CR4: 00000000000406f0
[ 1523.750066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1523.750066] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1523.750066] Process trinity-child64 (pid: 9050, threadinfo ffff880045f80000, task ffff880048eb0000)
[ 1523.750066] Stack:
[ 1523.750066]  ffff88000d7533f0 fffffffffffffff0 ffff880045f81da8 ffffffff812361d8
[ 1523.750066]  ffff880045f81d98 ffff880048ee9000 ffff8800095b4580 ffff8800095b4580
[ 1523.750066]  ffff88001d1cdb00 ffff8800095b45f0 ffff880022a4d630 ffff8800095b45e0
[ 1523.750066] Call Trace:
[ 1523.750066]  [<ffffffff812361d8>] validate_mm+0x58/0x1e0
[ 1523.750066]  [<ffffffff81236aa5>] vma_adjust+0x635/0x6b0
[ 1523.750066]  [<ffffffff81236c81>] __split_vma.isra.22+0x161/0x220
[ 1523.750066]  [<ffffffff81237934>] split_vma+0x24/0x30
[ 1523.750066]  [<ffffffff8122ce6a>] sys_madvise+0x5da/0x7b0
[ 1523.750066]  [<ffffffff811cd14c>] ? rcu_eqs_exit+0x9c/0xb0
[ 1523.750066]  [<ffffffff811802cd>] ? trace_hardirqs_on+0xd/0x10
[ 1523.750066]  [<ffffffff83aee198>] tracesys+0xe1/0xe6
[ 1523.750066] Code: 4c 09 ff 48 39 ce 77 9e f3 c3 0f 1f 44 00 00 31 c0 c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53
48 89 fb 48 83 ec 08 <48> 8b 17 48 8b 8a 90 00 00 00 48 39 4f 40 74 34 80 3d f7 1f 5c
[ 1523.750066] RIP  [<ffffffff8122c29c>] anon_vma_interval_tree_verify+0xc/0xa0
[ 1523.750066]  RSP <ffff880045f81d48>
[ 1523.750066] CR2: fffffffffffffff0
[ 1523.750066] ---[ end trace e35e5fa49072faf9 ]---

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Figured-out-by: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mmap.c~mm-add-anon_vma_lock-to-validate_mm mm/mmap.c
--- a/mm/mmap.c~mm-add-anon_vma_lock-to-validate_mm
+++ a/mm/mmap.c
@@ -334,8 +334,10 @@ void validate_mm(struct mm_struct *mm)
 	struct vm_area_struct *vma = mm->mmap;
 	while (vma) {
 		struct anon_vma_chain *avc;
+		vma_lock_anon_vma(vma);
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
+		vma_unlock_anon_vma(vma);
 		vma = vma->vm_next;
 		i++;
 	}
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-add-anon_vma_lock-to-validate_mm.patch

