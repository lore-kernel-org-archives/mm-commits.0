From: akpm@linux-foundation.org
Subject: - serial8250-sanity-check-nr_uarts-on-all-paths.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:51 -0700
Message-ID: <200807141934.m6EJYp2I023842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013AbYGNTfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     serial8250: sanity check nr_uarts on all paths.
has been removed from the -mm tree.  Its filename was
     serial8250-sanity-check-nr_uarts-on-all-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial8250: sanity check nr_uarts on all paths.
From: Eric W. Biederman <ebiederm@xmission.com>

I had 8250.nr_uarts=16 in the boot line of a test kernel and I had a weird
mysterious crash in sysfs.  After taking an in-depth look I realized that
CONFIG_SERIAL_8250_NR_UARTS was set to 4 and I was walking off the end of
the serial8250_ports array.

Ouch!!!

Don't let this happen to someone else.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/serial/8250.c~serial8250-sanity-check-nr_uarts-on-all-paths drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial8250-sanity-check-nr_uarts-on-all-paths
+++ a/drivers/serial/8250.c
@@ -2623,6 +2623,9 @@ static struct console serial8250_console
 
 static int __init serial8250_console_init(void)
 {
+	if (nr_uarts > UART_NR)
+		nr_uarts = UART_NR;
+
 	serial8250_isa_init_ports();
 	register_console(&serial8250_console);
 	return 0;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
generic-irqs-enable-polling-for-disabled-screaming-irqs.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
sysctl-check-for-bogus-modes.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
kernel-kexecc-make-kimage_terminate-void.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

