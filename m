Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE28299AAF
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760498883; cv=none; b=OxpTU7xEI3ZGmkndYJjDydD96iJtLvi6vD15W0jzB+cu+SMkM6aEpFe9r7OPRt2ykrWSjzIeZP1IGMmL8ZJqbXRmwCR1kUAerhWOK56B8zH08hbUrJbq+g7FDgNpkQofgPQstqXDhxXL7pGtRHm0o3exe0NOQu3gTfewyxKz+uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760498883; c=relaxed/simple;
	bh=HRI/Ucmx5eoCbdebE35AyXHvB3nYlvMdN073k8tTbn8=;
	h=Date:To:From:Subject:Message-Id; b=iwFgGx1iRupjutt7asoVxJJrRKKhGYFf5GIFQn+qtdBPQ7MbVv/5uEi0i5lrwhxYvyiCMlojDYIzEI4cv+xJFo7UMqQBaK0AGh9Nlv9KEo/s8KssO0giphHFXpITQDmKnObXBVfdmlKv5Bjlzk+0C/xI3mMQeKyTfas8WIiMY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDN3JjXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDN3JjXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A78BC4CEE7;
	Wed, 15 Oct 2025 03:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760498881;
	bh=HRI/Ucmx5eoCbdebE35AyXHvB3nYlvMdN073k8tTbn8=;
	h=Date:To:From:Subject:From;
	b=VDN3JjXgrvhV86EyOJB6POJSrm5Iuw9wYCklQKmWx/fUE8XXRxKeaooOWqLQmvHvn
	 z7i703oPRKSkLbTlkUXkKhtwZJA/VDnXDEc6GIM0DzGvmB7K1mRmnKvlsJ4xEW/enI
	 EP764+UIadFYdCKdSztkXmTN8AqKmGqdQNzqj92k=
Date: Tue, 14 Oct 2025 20:28:00 -0700
To: mm-commits@vger.kernel.org,zhanjie9@hisilicon.com,yangyicong@hisilicon.com,will@kernel.org,wangjinchao600@gmail.com,thorsten.blum@linux.dev,suzuki.poulose@arm.com,pjw@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@kernel.org,maz@kernel.org,masahiroy@kernel.org,mark.rutland@arm.com,lihuafei1@huawei.com,johannes@sipsolutions.net,dianders@chromium.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,anup@brainfault.org,alex@ghiti.fr,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-add-hardlockup_detector_perf-support.patch added to mm-nonmm-unstable branch
Message-Id: <20251015032801.7A78BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: add HARDLOCKUP_DETECTOR_PERF support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-add-hardlockup_detector_perf-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-add-hardlockup_detector_perf-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: riscv: add HARDLOCKUP_DETECTOR_PERF support
Date: Tue, 14 Oct 2025 11:14:25 +0800

Enable the HARDLOCKUP_DETECTOR_PERF function based on RISC-V SSE.

Link: https://lkml.kernel.org/r/20251014031425.93284-3-cuiyunhui@bytedance.com
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Paul Walmsley <pjw@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Anup Patel <anup@brainfault.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jie Zhan <zhanjie9@hisilicon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig           |    3 +++
 drivers/perf/riscv_pmu_sbi.c |   10 ++++++++++
 2 files changed, 13 insertions(+)

--- a/arch/riscv/Kconfig~riscv-add-hardlockup_detector_perf-support
+++ a/arch/riscv/Kconfig
@@ -186,6 +186,9 @@ config RISCV
 	select HAVE_PAGE_SIZE_4KB
 	select HAVE_PCI
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_EVENTS_NMI if RISCV_PMU_SBI_SSE
+	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	select WATCHDOG_PERF_ADJUST_PERIOD if HARDLOCKUP_DETECTOR_PERF && CPU_FREQ
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
--- a/drivers/perf/riscv_pmu_sbi.c~riscv-add-hardlockup_detector_perf-support
+++ a/drivers/perf/riscv_pmu_sbi.c
@@ -21,6 +21,7 @@
 #include <linux/sched/clock.h>
 #include <linux/soc/andes/irq.h>
 #include <linux/workqueue.h>
+#include <linux/nmi.h>
 
 #include <asm/errata_list.h>
 #include <asm/sbi.h>
@@ -1145,6 +1146,13 @@ static irqreturn_t pmu_sbi_ovf_handler(i
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
+bool arch_perf_nmi_is_available(void)
+{
+	return IS_ENABLED(CONFIG_RISCV_PMU_SBI_SSE);
+}
+#endif
+
 static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	struct riscv_pmu *pmu = hlist_entry_safe(node, struct riscv_pmu, node);
@@ -1567,6 +1575,8 @@ static int __init pmu_sbi_devinit(void)
 	/* Notify legacy implementation that SBI pmu is available*/
 	riscv_pmu_legacy_skip_init();
 
+	lockup_detector_retry_init();
+
 	return ret;
 }
 device_initcall(pmu_sbi_devinit)
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are

watchdog-move-arm64-watchdog_hld-into-common-code.patch
riscv-add-hardlockup_detector_perf-support.patch

