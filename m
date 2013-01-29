From: akpm@linux-foundation.org
Subject: + swap-make-each-swap-partition-have-one-address_space-fix-fix.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:31:40 -0800
Message-ID: <20130129003140.B50E25A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:54671 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3A2Abm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:31:42 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so631415iag.0
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:31:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, hughd@google.com, sasha.levin@oracle.com, shli@fusionio.com


The patch titled
     Subject: swap-make-each-swap-partition-have-one-address_space-fix-fix
has been added to the -mm tree.  Its filename is
     swap-make-each-swap-partition-have-one-address_space-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap-make-each-swap-partition-have-one-address_space-fix-fix

Sasha reported:
Commit "swap: make each swap partition have one address_space" is triggering
a series of warnings on boot:

[    3.446071] ------------[ cut here ]------------
[    3.446664] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
[    3.447715] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[    3.450360] Modules linked in:
[    3.451593] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc4-next-20130124-sasha-00004-g838a1b4 #266
[    3.454508] Call Trace:
[    3.455248]  [<ffffffff8110d1bc>] warn_slowpath_common+0x8c/0xc0
[    3.455248]  [<ffffffff8110d291>] warn_slowpath_fmt+0x41/0x50
[    3.455248]  [<ffffffff81a2bb5e>] debug_print_object+0x8e/0xb0
[    3.455248]  [<ffffffff81a2c26b>] __debug_object_init+0x20b/0x290
[    3.455248]  [<ffffffff81a2c305>] debug_object_init+0x15/0x20
[    3.455248]  [<ffffffff81a3fbed>] __percpu_counter_init+0x6d/0xe0
[    3.455248]  [<ffffffff81231bdc>] bdi_init+0x1ac/0x270
[    3.455248]  [<ffffffff8618f20b>] swap_setup+0x3b/0x87
[    3.455248]  [<ffffffff8618f257>] ? swap_setup+0x87/0x87
[    3.455248]  [<ffffffff8618f268>] kswapd_init+0x11/0x7c
[    3.455248]  [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
[    3.455248]  [<ffffffff86168cfd>] do_basic_setup+0x96/0xb4
[    3.455248]  [<ffffffff861685ae>] ? loglevel+0x31/0x31
[    3.455248]  [<ffffffff861885cd>] ? sched_init_smp+0x150/0x157
[    3.455248]  [<ffffffff86168ded>] kernel_init_freeable+0xd2/0x14c
[    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
[    3.455248]  [<ffffffff83cade19>] kernel_init+0x9/0xf0
[    3.455248]  [<ffffffff83d5727c>] ret_from_fork+0x7c/0xb0
[    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
[    3.455248] ---[ end trace 0b176d5c0f21bffb ]---

Initialize swap space backing_dev_info once to avoid the warning.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~swap-make-each-swap-partition-have-one-address_space-fix-fix mm/swap.c
--- a/mm/swap.c~swap-make-each-swap-partition-have-one-address_space-fix-fix
+++ a/mm/swap.c
@@ -858,8 +858,8 @@ void __init swap_setup(void)
 #ifdef CONFIG_SWAP
 	int i;
 
+	bdi_init(swapper_spaces[0].backing_dev_info);
 	for (i = 0; i < MAX_SWAPFILES; i++) {
-		bdi_init(swapper_spaces[i].backing_dev_info);
 		spin_lock_init(&swapper_spaces[i].tree_lock);
 		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
 	}
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch

