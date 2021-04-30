Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCA1C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 00:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05F861107
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 00:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhD3ATL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Apr 2021 20:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhD3ATK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Apr 2021 20:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F4DF613CC;
        Fri, 30 Apr 2021 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619741903;
        bh=PpVP+okG4ZltW7giJfnjWfO9t4FDeqRrqITCJ9a3yc0=;
        h=Date:From:To:Subject:From;
        b=fb0mCvtxZC7+1ZAsea5c6IdTPjZizARcgEMEieqBhThRvOTmn1DAu3cPp6Sdy08kk
         CawuLR5CSqXaCNPGWaUKovCNvzkv63IjSUDx7EVd4ZbCE22x4SXTKcPOPKe/F/MvDw
         3yh4hm1hhhWkELhkMMf/HzBR2OzMll5OEQILJMpE=
Date:   Thu, 29 Apr 2021 17:18:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210430001822.vnU705v1W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                                           |   18 ---
 arch/alpha/kernel/syscalls/syscall.tbl             |    3 
 arch/arm/tools/syscall.tbl                         |    3 
 arch/arm64/include/asm/unistd.h                    |    4 
 arch/arm64/include/asm/unistd32.h                  |    3 
 arch/ia64/kernel/syscalls/syscall.tbl              |    3 
 arch/m68k/kernel/syscalls/syscall.tbl              |    3 
 arch/microblaze/kernel/syscalls/syscall.tbl        |    3 
 arch/mips/kernel/syscalls/syscall_n32.tbl          |    3 
 arch/mips/kernel/syscalls/syscall_n64.tbl          |    3 
 arch/mips/kernel/syscalls/syscall_o32.tbl          |    3 
 arch/parisc/kernel/syscalls/syscall.tbl            |    3 
 arch/powerpc/kernel/syscalls/syscall.tbl           |    3 
 arch/s390/kernel/syscalls/syscall.tbl              |    3 
 arch/sh/kernel/syscalls/syscall.tbl                |    3 
 arch/sparc/kernel/syscalls/syscall.tbl             |    3 
 arch/x86/entry/syscalls/syscall_32.tbl             |    3 
 arch/x86/entry/syscalls/syscall_64.tbl             |    3 
 arch/x86/kernel/kvm.c                              |   44 -------
 arch/xtensa/kernel/syscalls/syscall.tbl            |    3 
 drivers/block/rnbd/rnbd-clt.c                      |    8 -
 drivers/bluetooth/virtio_bt.c                      |    3 
 drivers/target/iscsi/iscsi_target.c                |    4 
 fs/io_uring.c                                      |   61 -----------
 include/linux/blk-mq.h                             |    9 -
 include/uapi/asm-generic/unistd.h                  |    6 -
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    4 
 27 files changed, 212 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -483,9 +483,6 @@
 551	common	epoll_pwait2			sys_epoll_pwait2
 552	common	mount_setattr			sys_mount_setattr
 553	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 554	common	landlock_create_ruleset		sys_landlock_create_ruleset
 555	common	landlock_add_rule		sys_landlock_add_rule
 556	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/arm64/include/asm/unistd32.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/unistd32.h
@@ -895,15 +895,12 @@ __SYSCALL(__NR_epoll_pwait2, compat_sys_
 __SYSCALL(__NR_mount_setattr, sys_mount_setattr)
 #define __NR_quotactl_path 443
 __SYSCALL(__NR_quotactl_path, sys_quotactl_path)
-<<<<<<< HEAD
-=======
 #define __NR_landlock_create_ruleset 444
 __SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
 #define __NR_landlock_add_rule 445
 __SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
 #define __NR_landlock_restrict_self 446
 __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
->>>>>>> linux-next/akpm-base
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,11 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-<<<<<<< HEAD
-#define __NR_compat_syscalls		444
-=======
 #define __NR_compat_syscalls		447
->>>>>>> linux-next/akpm-base
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm/tools/syscall.tbl~linux-next-git-rejects
+++ a/arch/arm/tools/syscall.tbl
@@ -457,9 +457,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/ia64/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -364,9 +364,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/m68k/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -443,9 +443,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -449,9 +449,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -382,9 +382,6 @@
 441	n32	epoll_pwait2			compat_sys_epoll_pwait2
 442	n32	mount_setattr			sys_mount_setattr
 443	n32	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	n32	landlock_create_ruleset		sys_landlock_create_ruleset
 445	n32	landlock_add_rule		sys_landlock_add_rule
 446	n32	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -358,9 +358,6 @@
 441	n64	epoll_pwait2			sys_epoll_pwait2
 442	n64	mount_setattr			sys_mount_setattr
 443	n64	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	n64	landlock_create_ruleset		sys_landlock_create_ruleset
 445	n64	landlock_add_rule		sys_landlock_add_rule
 446	n64	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -431,9 +431,6 @@
 441	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
 442	o32	mount_setattr			sys_mount_setattr
 443	o32	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	o32	landlock_create_ruleset		sys_landlock_create_ruleset
 445	o32	landlock_add_rule		sys_landlock_add_rule
 446	o32	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/parisc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -441,9 +441,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -523,9 +523,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/s390/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -446,9 +446,6 @@
 441  common	epoll_pwait2		sys_epoll_pwait2		compat_sys_epoll_pwait2
 442  common	mount_setattr		sys_mount_setattr		sys_mount_setattr
 443  common	quotactl_path		sys_quotactl_path		sys_quotactl_path
-<<<<<<< HEAD
-=======
 444  common	landlock_create_ruleset	sys_landlock_create_ruleset	sys_landlock_create_ruleset
 445  common	landlock_add_rule	sys_landlock_add_rule		sys_landlock_add_rule
 446  common	landlock_restrict_self	sys_landlock_restrict_self	sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/sh/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -446,9 +446,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/sparc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -489,9 +489,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/x86/entry/syscalls/syscall_32.tbl~linux-next-git-rejects
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -448,9 +448,6 @@
 441	i386	epoll_pwait2		sys_epoll_pwait2		compat_sys_epoll_pwait2
 442	i386	mount_setattr		sys_mount_setattr
 443	i386	quotactl_path		sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	i386	landlock_create_ruleset	sys_landlock_create_ruleset
 445	i386	landlock_add_rule	sys_landlock_add_rule
 446	i386	landlock_restrict_self	sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/arch/x86/entry/syscalls/syscall_64.tbl~linux-next-git-rejects
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -365,12 +365,9 @@
 441	common	epoll_pwait2		sys_epoll_pwait2
 442	common	mount_setattr		sys_mount_setattr
 443	common	quotactl_path		sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset	sys_landlock_create_ruleset
 445	common	landlock_add_rule	sys_landlock_add_rule
 446	common	landlock_restrict_self	sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/arch/x86/kernel/kvm.c~linux-next-git-rejects
+++ a/arch/x86/kernel/kvm.c
@@ -659,43 +659,8 @@ static int kvm_cpu_down_prepare(unsigned
 	local_irq_enable();
 	return 0;
 }
-<<<<<<< HEAD
-#endif
-
-static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
-			const struct flush_tlb_info *info)
-{
-	u8 state;
-	int cpu;
-	struct kvm_steal_time *src;
-	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
-
-	cpumask_copy(flushmask, cpumask);
-	/*
-	 * We have to call flush only on online vCPUs. And
-	 * queue flush_on_enter for pre-empted vCPUs
-	 */
-	for_each_cpu(cpu, flushmask) {
-		/*
-		 * The local vCPU is never preempted, so we do not explicitly
-		 * skip check for local vCPU - it will never be cleared from
-		 * flushmask.
-		 */
-		src = &per_cpu(steal_time, cpu);
-		state = READ_ONCE(src->preempted);
-		if ((state & KVM_VCPU_PREEMPTED)) {
-			if (try_cmpxchg(&src->preempted, &state,
-					state | KVM_VCPU_FLUSH_TLB))
-				__cpumask_clear_cpu(cpu, flushmask);
-		}
-	}
-
-	native_flush_tlb_multi(flushmask, info);
-}
-=======
 
 #endif
->>>>>>> linux-next/akpm-base
 
 static void __init kvm_guest_init(void)
 {
@@ -711,15 +676,6 @@ static void __init kvm_guest_init(void)
 		static_call_update(pv_steal_clock, kvm_steal_clock);
 	}
 
-<<<<<<< HEAD
-	if (pv_tlb_flush_supported()) {
-		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
-		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
-		pr_info("KVM setup pv remote TLB flush\n");
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -414,9 +414,6 @@
 441	common	epoll_pwait2			sys_epoll_pwait2
 442	common	mount_setattr			sys_mount_setattr
 443	common	quotactl_path			sys_quotactl_path
-<<<<<<< HEAD
-=======
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
->>>>>>> linux-next/akpm-base
--- a/drivers/block/rnbd/rnbd-clt.c~linux-next-git-rejects
+++ a/drivers/block/rnbd/rnbd-clt.c
@@ -320,11 +320,7 @@ static struct rtrs_permit *rnbd_get_perm
 	struct rtrs_permit *permit;
 
 	permit = rtrs_clt_get_permit(sess->rtrs, con_type, wait);
-<<<<<<< HEAD
-	if (likely(permit))
-=======
 	if (permit)
->>>>>>> linux-next/akpm-base
 		/* We have a subtle rare case here, when all permits can be
 		 * consumed before busy counter increased.  This is safe,
 		 * because loser will get NULL as a permit, observe 0 busy
@@ -359,11 +355,7 @@ static struct rnbd_iu *rnbd_get_iu(struc
 		return NULL;
 
 	permit = rnbd_get_permit(sess, con_type, wait);
-<<<<<<< HEAD
-	if (unlikely(!permit)) {
-=======
 	if (!permit) {
->>>>>>> linux-next/akpm-base
 		kfree(iu);
 		return NULL;
 	}
--- a/drivers/bluetooth/virtio_bt.c~linux-next-git-rejects
+++ a/drivers/bluetooth/virtio_bt.c
@@ -34,12 +34,9 @@ static int virtbt_add_inbuf(struct virti
 	int err;
 
 	skb = alloc_skb(1000, GFP_KERNEL);
-<<<<<<< HEAD
-=======
 	if (!skb)
 		return -ENOMEM;
 
->>>>>>> linux-next/akpm-base
 	sg_init_one(sg, skb->data, 1000);
 
 	err = virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);
--- a/drivers/target/iscsi/iscsi_target.c~linux-next-git-rejects
+++ a/drivers/target/iscsi/iscsi_target.c
@@ -1169,10 +1169,6 @@ int iscsit_setup_scsi_cmd(struct iscsi_c
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
 						GFP_KERNEL);
-<<<<<<< HEAD
-
-=======
->>>>>>> linux-next/akpm-base
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
 			return iscsit_add_reject_cmd(cmd,
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -456,10 +456,7 @@ struct io_ring_ctx {
 	spinlock_t			rsrc_ref_lock;
 	struct io_rsrc_node		*rsrc_node;
 	struct io_rsrc_node		*rsrc_backup_node;
-<<<<<<< HEAD
-=======
 	struct io_mapped_ubuf		*dummy_ubuf;
->>>>>>> linux-next/akpm-base
 
 	struct io_restriction		restrictions;
 
@@ -7154,7 +7151,6 @@ static int io_rsrc_ref_quiesce(struct io
 }
 
 static void io_rsrc_data_free(struct io_rsrc_data *data)
-<<<<<<< HEAD
 {
 	kvfree(data->tags);
 	kfree(data);
@@ -7164,17 +7160,6 @@ static struct io_rsrc_data *io_rsrc_data
 					       rsrc_put_fn *do_put,
 					       unsigned nr)
 {
-=======
-{
-	kvfree(data->tags);
-	kfree(data);
-}
-
-static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
-					       rsrc_put_fn *do_put,
-					       unsigned nr)
-{
->>>>>>> linux-next/akpm-base
 	struct io_rsrc_data *data;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -7559,10 +7544,7 @@ static void __io_rsrc_put_work(struct io
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock_irqsave(&ctx->completion_lock, flags);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-<<<<<<< HEAD
-=======
 			ctx->cq_extra++;
->>>>>>> linux-next/akpm-base
 			io_commit_cqring(ctx);
 			spin_unlock_irqrestore(&ctx->completion_lock, flags);
 			io_cqring_ev_posted(ctx);
@@ -8131,41 +8113,6 @@ static unsigned long rings_size(unsigned
 }
 
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
-<<<<<<< HEAD
-{
-	struct io_mapped_ubuf *imu = *slot;
-	unsigned int i;
-
-	for (i = 0; i < imu->nr_bvecs; i++)
-		unpin_user_page(imu->bvec[i].bv_page);
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx, imu->acct_pages);
-	kvfree(imu);
-	*slot = NULL;
-}
-
-static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
-{
-	io_buffer_unmap(ctx, &prsrc->buf);
-	prsrc->buf = NULL;
-}
-
-static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
-{
-	unsigned int i;
-
-	for (i = 0; i < ctx->nr_user_bufs; i++)
-		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
-	kfree(ctx->user_bufs);
-	kfree(ctx->buf_data);
-	ctx->user_bufs = NULL;
-	ctx->buf_data = NULL;
-	ctx->nr_user_bufs = 0;
-}
-
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
-{
-=======
 {
 	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
@@ -8201,7 +8148,6 @@ static void __io_sqe_buffers_unregister(
 
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
->>>>>>> linux-next/akpm-base
 	int ret;
 
 	if (!ctx->buf_data)
@@ -8522,21 +8468,14 @@ static int __io_sqe_buffers_update(struc
 		err = io_buffer_validate(&iov);
 		if (err)
 			break;
-<<<<<<< HEAD
-=======
 		if (!iov.iov_base && tag)
 			return -EINVAL;
->>>>>>> linux-next/akpm-base
 		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
 		if (err)
 			break;
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
-<<<<<<< HEAD
-		if (ctx->user_bufs[i]) {
-=======
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
->>>>>>> linux-next/akpm-base
 			err = io_queue_rsrc_removal(ctx->buf_data, offset,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
--- a/include/linux/blk-mq.h~linux-next-git-rejects
+++ a/include/linux/blk-mq.h
@@ -313,21 +313,12 @@ struct blk_mq_ops {
 	 */
 	void (*put_budget)(struct request_queue *, int);
 
-<<<<<<< HEAD
-	/*
-	 * @set_rq_budget_toekn: store rq's budget token
-	 */
-	void (*set_rq_budget_token)(struct request *, int);
-	/*
-	 * @get_rq_budget_toekn: retrieve rq's budget token
-=======
 	/**
 	 * @set_rq_budget_token: store rq's budget token
 	 */
 	void (*set_rq_budget_token)(struct request *, int);
 	/**
 	 * @get_rq_budget_token: retrieve rq's budget token
->>>>>>> linux-next/akpm-base
 	 */
 	int (*get_rq_budget_token)(struct request *);
 
--- a/include/uapi/asm-generic/unistd.h~linux-next-git-rejects
+++ a/include/uapi/asm-generic/unistd.h
@@ -865,11 +865,6 @@ __SC_COMP(__NR_epoll_pwait2, sys_epoll_p
 __SYSCALL(__NR_mount_setattr, sys_mount_setattr)
 #define __NR_quotactl_path 443
 __SYSCALL(__NR_quotactl_path, sys_quotactl_path)
-<<<<<<< HEAD
-
-#undef __NR_syscalls
-#define __NR_syscalls 444
-=======
 #define __NR_landlock_create_ruleset 444
 __SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
 #define __NR_landlock_add_rule 445
@@ -879,7 +874,6 @@ __SYSCALL(__NR_landlock_restrict_self, s
 
 #undef __NR_syscalls
 #define __NR_syscalls 447
->>>>>>> linux-next/akpm-base
 
 /*
  * 32 bit systems traditionally used different
--- a/Makefile~linux-next-git-rejects
+++ a/Makefile
@@ -270,11 +270,7 @@ no-dot-config-targets := $(clean-targets
 			 cscope gtags TAGS tags help% %docs check% coccicheck \
 			 $(version_h) headers headers_% archheaders archscripts \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
-<<<<<<< HEAD
-			 outputmakefile
-=======
 			 outputmakefile rustfmt rustfmtcheck
->>>>>>> linux-next/akpm-base
 # Installation targets should not require compiler. Unfortunately, vdso_install
 # is an exception where build artifacts may be updated. This must be fixed.
 no-compiler-targets := $(no-dot-config-targets) install dtbs_install \
@@ -627,21 +623,7 @@ export TENTATIVE_CLANG_FLAGS
 CC_VERSION_TEXT = $(subst $(pound),,$(shell $(CC) --version 2>/dev/null | head -n 1))
 
 ifneq ($(findstring clang,$(CC_VERSION_TEXT)),)
-<<<<<<< HEAD
-ifneq ($(CROSS_COMPILE),)
-CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
-endif
-ifeq ($(LLVM_IAS),1)
-CLANG_FLAGS	+= -integrated-as
-else
-CLANG_FLAGS	+= -no-integrated-as
-GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
-CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
-endif
-CLANG_FLAGS	+= -Werror=unknown-warning-option
-=======
 CLANG_FLAGS	+= $(TENTATIVE_CLANG_FLAGS)
->>>>>>> linux-next/akpm-base
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
 KBUILD_AFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh~linux-next-git-rejects
+++ a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -274,11 +274,7 @@ check_mptcp_disabled()
 	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
 
 	local err=0
-<<<<<<< HEAD
-	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
-=======
 	LC_ALL=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
->>>>>>> linux-next/akpm-base
 		grep -q "^socket: Protocol not available$" && err=1
 	ip netns delete ${disabled_ns}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

