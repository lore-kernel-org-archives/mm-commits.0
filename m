From: akpm@linux-foundation.org
Subject: - mm-owner-fix-race-between-swap-and-exit-fix.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:55 -0700
Message-ID: <200810012152.m91Lqttk006090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbYJAVxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm_owner: fix cgroup null dereference
has been removed from the -mm tree.  Its filename was
     mm-owner-fix-race-between-swap-and-exit-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm_owner: fix cgroup null dereference
From: Jiri Slaby <jirislaby@gmail.com>

mm->owner is set to NULL prior to calling cgroup_mm_owner_callbacks, but
it should be set after that to not pass NULL pointer as the old owner
which otherwise results in an oops (shortened):

BUG: unable to handle kernel NULL pointer dereference at 0000000000000580
Oops: 0000 [1] SMP
Pid: 3396, comm: nscd Tainted: G        W 2.6.27-rc3-mm1_64 #439
RIP: 0010:[<ffffffff8027035a>]  [<ffffffff8027035a>] cgroup_mm_owner_callbacks+0x3a/0x90
RAX: 0000000000000000 RBX: ffffffff80589720 RCX: ffff880079f503e8
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff806c36e0
RBP: ffff880078291bd8 R08: ffff880078290000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800787f8e20
Call Trace:
 [<ffffffff8023d42a>] mm_update_next_owner+0x1ca/0x240
 [<ffffffff8023d5aa>] exit_mm+0x10a/0x150
 [<ffffffff8023f1fc>] do_exit+0x1dc/0x940
Code: 89 fe 41 55 49 89 f5 41 54 53 74 68 48 c7 c3 20 97 58 80 45 31 e4 0f 1f 00 48 8b 3b 4d 85 ed 48 63 47 58 48 8d 14 c5 00 00 00 00 <49> 8b 86 80 05 00 00 48 8d 44 10 38 48 8b 00 48 8b 30 74 12 49

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~mm-owner-fix-race-between-swap-and-exit-fix kernel/exit.c
--- a/kernel/exit.c~mm-owner-fix-race-between-swap-and-exit-fix
+++ a/kernel/exit.c
@@ -641,8 +641,8 @@ retry:
 	 * the callback and take action
 	 */
 	down_write(&mm->mmap_sem);
-	mm->owner = NULL;
 	cgroup_mm_owner_callbacks(mm->owner, NULL);
+	mm->owner = NULL;
 	up_write(&mm->mmap_sem);
 	return;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-hid.patch
git-net.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
char-ds1286-eliminate-busy-waiting.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch
tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

