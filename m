From: akpm@linux-foundation.org
Subject: [merged]
 ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits.patch removed from -mm tree
Date: Tue, 18 Aug 2015 12:42:22 -0700
Message-ID: <55d38a9e.8NYSuCHd61OQ/lLd%akpm__37246.8223482885$1439926955$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbHRTmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 15:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@redhat.com, aquini@redhat.com, aris@redhat.com, dave@stgolabs.net, djeffery@redhat.com, manfred@colorfullife.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: fix use after free on IPC_RMID after a task using same semaphore set exits
has been removed from the -mm tree.  Its filename was
     ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Herton R. Krzesinski" <herton@redhat.com>
Subject: ipc,sem: fix use after free on IPC_RMID after a task using same semaphore set exits

The current semaphore code allows a potential use after free: in exit_sem
we may free the task's sem_undo_list while there is still another task
looping through the same semaphore set and cleaning the sem_undo list at
freeary function (the task called IPC_RMID for the same semaphore set).

For example, with a test program [1] running which keeps forking a lot of processes
(which then do a semop call with SEM_UNDO flag), and with the parent right after
removing the semaphore set with IPC_RMID, and a kernel built with CONFIG_SLAB,
CONFIG_SLAB_DEBUG and CONFIG_DEBUG_SPINLOCK, you can easily see something like
the following in the kernel log:

[  876.146023] Slab corruption (Not tainted): kmalloc-64 start=ffff88003b45c1c0, len=64
[  876.146548] 000: 6b 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b 6b 6b 6b 6b  kkkkkkkk.kkkkkkk
[  876.146935] 010: ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
[  876.147313] Prev obj: start=ffff88003b45c180, len=64
[  876.147686] 000: 00 00 00 00 ad 4e ad de ff ff ff ff 5a 5a 5a 5a  .....N......ZZZZ
[  876.147938] 010: ff ff ff ff ff ff ff ff c0 fb 01 37 00 88 ff ff  ...........7....
[  876.148161] Next obj: start=ffff88003b45c200, len=64
[  876.148401] 000: 00 00 00 00 ad 4e ad de ff ff ff ff 5a 5a 5a 5a  .....N......ZZZZ
[  876.148759] 010: ff ff ff ff ff ff ff ff 68 29 a7 3c 00 88 ff ff  ........h).<....
[ 1947.014490] BUG: spinlock wrong CPU on CPU#2, test/18028
[ 1947.014944] general protection fault: 0000 [#1] SMP
[ 1947.015004] Modules linked in: 8021q mrp garp stp llc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc ppdev input_leds joydev parport_pc parport floppy serio_raw virtio_balloon virtio_rng virtio_console virtio_net iosf_mbi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr qxl ttm drm_kms_helper drm snd_hda_codec_generic i2c_piix4 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore crc32c_intel virtio_pci virtio_ring virtio pata_acpi ata_generic [last unloaded: speedstep_lib]
[ 1947.015004] CPU: 2 PID: 18028 Comm: test Not tainted 4.2.0-rc5+ #1
[ 1947.015004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.1-20150318_183358- 04/01/2014
[ 1947.015004] task: ffff88003bf98080 ti: ffff88003750c000 task.ti: ffff88003750c000
[ 1947.015004] RIP: 0010:[<ffffffff810d6053>]  [<ffffffff810d6053>] spin_dump+0x53/0xc0
[ 1947.015004] RSP: 0018:ffff88003750fd68  EFLAGS: 00010202
[ 1947.015004] RAX: 000000000000002c RBX: ffff88003cb5be08 RCX: 0000000000000000
[ 1947.015004] RDX: ffff88003fd11518 RSI: ffff88003fd0eb68 RDI: ffff88003fd0eb68
[ 1947.015004] RBP: ffff88003750fd78 R08: 0000000000000000 R09: 000000006b6b6b6b
[ 1947.015004] R10: 000000000000026c R11: 0000000000008000 R12: 6b6b6b6b6b6b6b6b
[ 1947.015004] R13: ffff88003b25f040 R14: ffff88003ad1dcc0 R15: ffff88003b25f040
[ 1947.015004] FS:  00007fda0d30a700(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
[ 1947.015004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1947.015004] CR2: 00007fda0d105dd4 CR3: 000000003acac000 CR4: 00000000000406e0
[ 1947.015004] Stack:
[ 1947.015004]  ffff88003cb5be08 ffffffff81a4f3b9 ffff88003750fd98 ffffffff810d60f0
[ 1947.015004]  ffff88003cb5be08 ffff88003b25f0b8 ffff88003750fdb8 ffffffff810d6171
[ 1947.015004]  ffff88003b25f040 ffff88003b25f090 ffff88003750fdc8 ffffffff8175d28e
[ 1947.015004] Call Trace:
[ 1947.015004]  [<ffffffff810d60f0>] spin_bug+0x30/0x40
[ 1947.015004]  [<ffffffff810d6171>] do_raw_spin_unlock+0x71/0xa0
[ 1947.015004]  [<ffffffff8175d28e>] _raw_spin_unlock+0xe/0x10
[ 1947.015004]  [<ffffffff812f4472>] freeary+0x82/0x2a0
[ 1947.015004]  [<ffffffff8175d30e>] ? _raw_spin_lock+0xe/0x10
[ 1947.015004]  [<ffffffff812f5d8e>] semctl_down.clone.0+0xce/0x160
[ 1947.015004]  [<ffffffff810633fa>] ? __do_page_fault+0x19a/0x430
[ 1947.015004]  [<ffffffff8112e588>] ? __audit_syscall_entry+0xa8/0x100
[ 1947.015004]  [<ffffffff812f6056>] SyS_semctl+0x236/0x2c0
[ 1947.015004]  [<ffffffff810215ce>] ? syscall_trace_leave+0xde/0x130
[ 1947.015004]  [<ffffffff8175d52e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1947.015004] Code: 8b 80 88 03 00 00 48 8d 88 60 05 00 00 48 c7 c7 a0 2c a4 81 31 c0 65 8b 15 eb 40 f3 7e e8 08 31 68 00 4d 85 e4 44 8b 4b 08 74 5e <45> 8b 84 24 88 03 00 00 49 8d 8c 24 60 05 00 00 8b 53 04 48 89
[ 1947.015004] RIP  [<ffffffff810d6053>] spin_dump+0x53/0xc0
[ 1947.015004]  RSP <ffff88003750fd68>
[ 1947.045328] ---[ end trace 783ebb76612867a0 ]---
[ 1972.023009] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [test:18053]
[ 1972.023011] Modules linked in: 8021q mrp garp stp llc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc ppdev input_leds joydev parport_pc parport floppy serio_raw virtio_balloon virtio_rng virtio_console virtio_net iosf_mbi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr qxl ttm drm_kms_helper drm snd_hda_codec_generic i2c_piix4 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore crc32c_intel virtio_pci virtio_ring virtio pata_acpi ata_generic [last unloaded: speedstep_lib]
[ 1972.023011] CPU: 3 PID: 18053 Comm: test Tainted: G      D         4.2.0-rc5+ #1
[ 1972.023011] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.1-20150318_183358- 04/01/2014
[ 1972.023011] task: ffff88003caaa2c0 ti: ffff88003d2f4000 task.ti: ffff88003d2f4000
[ 1972.023011] RIP: 0010:[<ffffffff8101cb30>]  [<ffffffff8101cb30>] native_read_tsc+0x0/0x20
[ 1972.023011] RSP: 0018:ffff88003d2f7c10  EFLAGS: 00000202
[ 1972.023011] RAX: 00000539305fc462 RBX: 00007ffd046999d0 RCX: 00000000305fc462
[ 1972.023011] RDX: 0000000000000539 RSI: 0000000000000000 RDI: 0000000000000001
[ 1972.023011] RBP: ffff88003d2f7c38 R08: 0000000000000000 R09: ffff8800370c0e40
[ 1972.023011] R10: 00007ffd046999d0 R11: 000000000000000c R12: 8000000021a12065
[ 1972.023011] R13: ffff88003d2f7c08 R14: ffffffff8106a938 R15: ffff88003d2f7b98
[ 1972.023011] FS:  00007fda0d30a700(0000) GS:ffff88003fd80000(0000) knlGS:0000000000000000
[ 1972.023011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1972.023011] CR2: 00007fda0ce60fd0 CR3: 000000003d359000 CR4: 00000000000406e0
[ 1972.023011] Stack:
[ 1972.023011] Call Trace:
[ 1972.023011]  [<ffffffff8138bbc0>] ? delay_tsc+0x40/0x70
[ 1972.023011]  [<ffffffff8138bb3f>] __delay+0xf/0x20
[ 1972.023011]  [<ffffffff810d6326>] do_raw_spin_lock+0x96/0x140
[ 1972.023011]  [<ffffffff8175d30e>] _raw_spin_lock+0xe/0x10
[ 1972.023011]  [<ffffffff812f4b11>] sem_lock_and_putref+0x11/0x70
[ 1972.023011]  [<ffffffff812f583f>] SYSC_semtimedop+0x7bf/0x960
[ 1972.023011]  [<ffffffff811bec56>] ? handle_mm_fault+0xbf6/0x1880
[ 1972.023011]  [<ffffffff810c8429>] ? dequeue_task_fair+0x79/0x4a0
[ 1972.023011]  [<ffffffff810633fa>] ? __do_page_fault+0x19a/0x430
[ 1972.023011]  [<ffffffff811e47e6>] ? kfree_debugcheck+0x16/0x40
[ 1972.023011]  [<ffffffff810633fa>] ? __do_page_fault+0x19a/0x430
[ 1972.023011]  [<ffffffff8112e588>] ? __audit_syscall_entry+0xa8/0x100
[ 1972.023011]  [<ffffffff81021686>] ? do_audit_syscall_entry+0x66/0x70
[ 1972.023011]  [<ffffffff810217c9>] ? syscall_trace_enter_phase1+0x139/0x160
[ 1972.023011]  [<ffffffff812f59ee>] SyS_semtimedop+0xe/0x10
[ 1972.023011]  [<ffffffff812f3570>] SyS_semop+0x10/0x20
[ 1972.023011]  [<ffffffff8175d52e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1972.023011] Code: 47 10 83 e8 01 85 c0 89 47 10 75 08 65 48 89 3d 1f 74 ff 7e c9 c3 0f 1f 44 00 00 55 48 89 e5 e8 87 17 04 00 66 90 c9 c3 0f 1f 00 <55> 48 89 e5 0f 31 89 c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9
[ 1972.023011] Kernel panic - not syncing: softlockup: hung tasks

I wasn't able to trigger any badness on a recent kernel without the proper
config debugs enabled, however I have softlockup reports on some kernel
versions, in the semaphore code, which are similar as above (the scenario
is seen on some servers running IBM DB2 which uses semaphore syscalls).

The patch here fixes the race against freeary, by acquiring or waiting on
the sem_undo_list lock as necessary (exit_sem can race with freeary, while
freeary sets un->semid to -1 and removes the same sem_undo from list_proc
or when it removes the last sem_undo).

After the patch I'm unable to reproduce the problem using the test case [1].

[1] Test case used below:

#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>

#define NSEM 1
#define NSET 5

int sid[NSET];

void thread()
{
	struct sembuf op;
	int s;
	uid_t pid = getuid();

	s = rand() % NSET;
	op.sem_num = pid % NSEM;
	op.sem_op = 1;
	op.sem_flg = SEM_UNDO;

	semop(sid[s], &op, 1);
	exit(EXIT_SUCCESS);
}

void create_set()
{
	int i, j;
	pid_t p;
	union {
		int val;
		struct semid_ds *buf;
		unsigned short int *array;
		struct seminfo *__buf;
	} un;

	/* Create and initialize semaphore set */
	for (i = 0; i < NSET; i++) {
		sid[i] = semget(IPC_PRIVATE , NSEM, 0644 | IPC_CREAT);
		if (sid[i] < 0) {
			perror("semget");
			exit(EXIT_FAILURE);
		}
	}
	un.val = 0;
	for (i = 0; i < NSET; i++) {
		for (j = 0; j < NSEM; j++) {
			if (semctl(sid[i], j, SETVAL, un) < 0)
				perror("semctl");
		}
	}

	/* Launch threads that operate on semaphore set */
	for (i = 0; i < NSEM * NSET * NSET; i++) {
		p = fork();
		if (p < 0)
			perror("fork");
		if (p == 0)
			thread();
	}

	/* Free semaphore set */
	for (i = 0; i < NSET; i++) {
		if (semctl(sid[i], NSEM, IPC_RMID))
			perror("IPC_RMID");
	}

	/* Wait for forked processes to exit */
	while (wait(NULL)) {
		if (errno == ECHILD)
			break;
	};
}

int main(int argc, char **argv)
{
	pid_t p;

	srand(time(NULL));

	while (1) {
		p = fork();
		if (p < 0) {
			perror("fork");
			exit(EXIT_FAILURE);
		}
		if (p == 0) {
			create_set();
			goto end;
		}

		/* Wait for forked processes to exit */
		while (wait(NULL)) {
			if (errno == ECHILD)
				break;
		};
	}
end:
	return 0;
}

[akpm@linux-foundation.org: use normal comment layout]
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Rafael Aquini <aquini@redhat.com>
CC: Aristeu Rozanski <aris@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -puN ipc/sem.c~ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits ipc/sem.c
--- a/ipc/sem.c~ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits
+++ a/ipc/sem.c
@@ -2074,17 +2074,28 @@ void exit_sem(struct task_struct *tsk)
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
 				    struct sem_undo, list_proc);
-		if (&un->list_proc == &ulp->list_proc)
-			semid = -1;
-		 else
-			semid = un->semid;
+		if (&un->list_proc == &ulp->list_proc) {
+			/*
+			 * We must wait for freeary() before freeing this ulp,
+			 * in case we raced with last sem_undo. There is a small
+			 * possibility where we exit while freeary() didn't
+			 * finish unlocking sem_undo_list.
+			 */
+			spin_unlock_wait(&ulp->lock);
+			rcu_read_unlock();
+			break;
+		}
+		spin_lock(&ulp->lock);
+		semid = un->semid;
+		spin_unlock(&ulp->lock);
 
+		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (semid == -1) {
 			rcu_read_unlock();
-			break;
+			continue;
 		}
 
-		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);
+		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, semid);
 		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (IS_ERR(sma)) {
 			rcu_read_unlock();
_

Patches currently in -mm which might be from herton@redhat.com are


