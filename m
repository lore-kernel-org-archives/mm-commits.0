From: akpm@linux-foundation.org
Subject: - infiniband-work-around-gcc-bug-on-sparc64.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:20:13 -0800
Message-ID: <200702100520.l1A5KDKB004443@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbXBJFXl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, davem@davemloft.net, rdreier@cisco.com, mm-commits@vger.kernel.org


The patch titled
     infiniband: work around gcc bug on sparc64
has been removed from the -mm tree.  Its filename was
     infiniband-work-around-gcc-bug-on-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: infiniband: work around gcc bug on sparc64
From: David Howells <dhowells@redhat.com>

For some reason gcc-3.4.5 on sparc64 does:

 WARNING: "____ilog2_NaN" [drivers/infiniband/hw/mthca/ib_mthca.ko] undefined!


Points to note:

 (1) The asm volatile flush/flushw are just markers for viewing what comes out
     in the assembly; removing them has no effect on the result.

 (2) Changing almost anything else in dwh__mthca_arbel_init_srq_context() or
     dwh__mthca_alloc_srq() causes the problem to go away.

The compiler command line issued by the kernel build is:

/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -fno-strict-aliasing -fno-common -Os -m64 -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wa,--undeclared-regs -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls -fasynchronous-unwind-tables -g  -c -o drivers/infiniband/hw/mthca/.tmp_mthca_srq.o drivers/infiniband/hw/mthca/mthca_srq.c

This can be reduced to this whilst still retaining the problem:

/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -m64 -c -o drivers/infiniband/hw/mthca/mthca_srq.o drivers/infiniband/hw/mthca/mthca_srq.c -Os

Removing -Os or changing it to -O or -O0 thru -O6 gets rid of the problem.

This patch to the kernel code fixes the problem:

Cc: Roland Dreier <rdreier@cisco.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/mthca/mthca_srq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/mthca/mthca_srq.c~infiniband-work-around-gcc-bug-on-sparc64 drivers/infiniband/hw/mthca/mthca_srq.c
--- a/drivers/infiniband/hw/mthca/mthca_srq.c~infiniband-work-around-gcc-bug-on-sparc64
+++ a/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -116,11 +116,12 @@ static void mthca_arbel_init_srq_context
 					 struct mthca_srq *srq,
 					 struct mthca_arbel_srq_context *context)
 {
-	int logsize;
+	int logsize, max;
 
 	memset(context, 0, sizeof *context);
 
-	logsize = ilog2(srq->max);
+	max = srq->max;
+	logsize = ilog2(max);
 	context->state_logsize_srqn = cpu_to_be32(logsize << 24 | srq->srqn);
 	context->lkey = cpu_to_be32(srq->mr.ibmr.lkey);
 	context->db_index = cpu_to_be32(srq->db_index);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-infiniband.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-frv.patch
reiser4-get_sb_dev-fix.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
mutex-subsystem-synchro-test-module.patch
