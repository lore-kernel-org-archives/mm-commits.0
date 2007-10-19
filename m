From: akpm@linux-foundation.org
Subject: - net-dccp-fix-link-error-with-config_sysctl.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:00 -0700
Message-ID: <200710190340.l9J3e0lw012652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965575AbXJSDkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, acme@ghostprotocols.net, davem@davemloft.net, ian.mcdonald@jandi.co.nz, mm-commits@vger.kernel.org


The patch titled
     net/DCCP: fix link error with !CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     net-dccp-fix-link-error-with-config_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/DCCP: fix link error with !CONFIG_SYSCTL
From: Ingo Molnar <mingo@elte.hu>

Do not define the sysctl_dccp_sync_ratelimit sysctl variable in the
CONFIG_SYSCTL dependent sysctl.c module - move it to input.c instead.

This fixes the following build bug:

 net/built-in.o: In function `dccp_check_seqno':
 input.c:(.text+0xbd859): undefined reference to `sysctl_dccp_sync_ratelimit'
 distcc[29953] ERROR: compile (null) on localhost failed
 make: *** [vmlinux] Error 1

Found via 'make randconfig' build testing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/input.c  |    3 +++
 net/dccp/sysctl.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN net/dccp/input.c~net-dccp-fix-link-error-with-config_sysctl net/dccp/input.c
--- a/net/dccp/input.c~net-dccp-fix-link-error-with-config_sysctl
+++ a/net/dccp/input.c
@@ -19,6 +19,9 @@
 #include "ccid.h"
 #include "dccp.h"
 
+/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
+int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
+
 static void dccp_fin(struct sock *sk, struct sk_buff *skb)
 {
 	sk->sk_shutdown |= RCV_SHUTDOWN;
diff -puN net/dccp/sysctl.c~net-dccp-fix-link-error-with-config_sysctl net/dccp/sysctl.c
--- a/net/dccp/sysctl.c~net-dccp-fix-link-error-with-config_sysctl
+++ a/net/dccp/sysctl.c
@@ -18,9 +18,6 @@
 #error This file should not be compiled without CONFIG_SYSCTL defined
 #endif
 
-/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
-int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
-
 static struct ctl_table dccp_default_table[] = {
 	{
 		.procname	= "seq_window",
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
fix-build-breakage-if-sysfs-fix.patch
git-x86.patch
i386-paravirt-boot-sequence.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
uninline-find_task_by_xxx-set-of-functions.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpuset-sched_load_balance-kmalloc-fix.patch
cpuset-sched_load_balance-flag-sched-domain-confusion-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
kexec-add-bss-to-resource-tree.patch
kexec-introduce-bootmem_exclusive.patch
kexec-use-bootmem_exclusive-on-x86.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
