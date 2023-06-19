Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C640BC001DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFSXWX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFSXVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5655310C6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B7E60FA4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0A5C433C8;
        Mon, 19 Jun 2023 23:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216880;
        bh=dqL4nNAJDFeut+BkGrxXKd1iAez2tuFRsfVbsOk8a3A=;
        h=Date:To:From:Subject:From;
        b=2ljfQ8ZzEaJ02Hrm+ptLzViLIs76hly/Mg9zHmCfwJ6zzXW4v7sf7U0U4kr3s0h7s
         Y/0V7f1MDpiM/fmh0GP8Z0Wd+Hakl8jRkdRHF2VjmFiXkWPZXu/hQndh7gapSzE+9N
         jz9sTS0yvTAF8FwitgWresgBFlB3zsFwrUBD5dug=
Date:   Mon, 19 Jun 2023 16:21:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        frederic@kernel.org, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmstat-skip-periodic-vmstat-update-for-isolated-cpus.patch removed from -mm tree
Message-Id: <20230619232119.EA0A5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmstat: skip periodic vmstat update for isolated CPUs
has been removed from the -mm tree.  Its filename was
     vmstat-skip-periodic-vmstat-update-for-isolated-cpus.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: vmstat: skip periodic vmstat update for isolated CPUs
Date: Wed, 7 Jun 2023 17:28:07 -0300

Problem: The interruption caused by vmstat_update is undesirable
for certain applications.

With workloads that are running on isolated cpus with nohz full mode to
shield off any kernel interruption. For example, a VM running a
time sensitive application with a 50us maximum acceptable interruption
(use case: soft PLC).

oslat   1094.456862: sys_mlock(start: 7f7ed0000b60, len: 1000)
oslat   1094.456971: workqueue_queue_work: ... function=vmstat_update ...
oslat   1094.456974: sched_switch: prev_comm=oslat ... ==> next_comm=kworker/5:1 ...
kworker 1094.456978: sched_switch: prev_comm=kworker/5:1 ==> next_comm=oslat ...

The example above shows an additional 7us for the
        oslat -> kworker -> oslat

switches. In the case of a virtualized CPU, and the vmstat_update
interruption in the host (of a qemu-kvm vcpu), the latency penalty
observed in the guest is higher than 50us, violating the acceptable
latency threshold.

The isolated vCPU can perform operations that modify per-CPU page counters,
for example to complete I/O operations:

      CPU 11/KVM-9540    [001] dNh1.  2314.248584: mod_zone_page_state <-__folio_end_writeback
      CPU 11/KVM-9540    [001] dNh1.  2314.248585: <stack trace>
 => 0xffffffffc042b083
 => mod_zone_page_state
 => __folio_end_writeback
 => folio_end_writeback
 => iomap_finish_ioend
 => blk_mq_end_request_batch
 => nvme_irq
 => __handle_irq_event_percpu
 => handle_irq_event
 => handle_edge_irq
 => __common_interrupt
 => common_interrupt
 => asm_common_interrupt
 => vmx_do_interrupt_nmi_irqoff
 => vmx_handle_exit_irqoff
 => vcpu_enter_guest
 => vcpu_run
 => kvm_arch_vcpu_ioctl_run
 => kvm_vcpu_ioctl
 => __x64_sys_ioctl
 => do_syscall_64
 => entry_SYSCALL_64_after_hwframe

In kernel users of vmstat counters either require the precise value and
they are using zone_page_state_snapshot interface or they can live with an
imprecision as the regular flushing can happen at arbitrary time and
cumulative error can grow (see calculate_normal_threshold).

From that POV the regular flushing can be postponed for CPUs that have
been isolated from the kernel interference without critical infrastructure
ever noticing.  Skip regular flushing from vmstat_shepherd for all
isolated CPUs to avoid interference with the isolated workload.

Suggested by Michal Hocko.

Link: https://lkml.kernel.org/r/ZIDoV/zxFKVmQl7W@tpad
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/vmstat.c~vmstat-skip-periodic-vmstat-update-for-isolated-cpus
+++ a/mm/vmstat.c
@@ -28,6 +28,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_ext.h>
 #include <linux/page_owner.h>
+#include <linux/sched/isolation.h>
 
 #include "internal.h"
 
@@ -2022,6 +2023,20 @@ static void vmstat_shepherd(struct work_
 	for_each_online_cpu(cpu) {
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
+		/*
+		 * In kernel users of vmstat counters either require the precise value and
+		 * they are using zone_page_state_snapshot interface or they can live with
+		 * an imprecision as the regular flushing can happen at arbitrary time and
+		 * cumulative error can grow (see calculate_normal_threshold).
+		 *
+		 * From that POV the regular flushing can be postponed for CPUs that have
+		 * been isolated from the kernel interference without critical
+		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
+		 * for all isolated CPUs to avoid interference with the isolated workload.
+		 */
+		if (cpu_is_isolated(cpu))
+			continue;
+
 		if (!delayed_work_pending(dw) && need_update(cpu))
 			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 
_

Patches currently in -mm which might be from mtosatti@redhat.com are


