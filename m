Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322093A7F6B
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 03:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785121663; cv=none; b=kEq3pceiigNwSL+8X/+YOTnQeOgqaTPG8DIBlPFHgA+2BYYHTmC5PN8As6bZ48S0+0C+ujxBhREjiM+fMGO7qTWPYJo7jiyr5DCtv3mW0dGMK6FouqO4RDrKjn4dKbgyqprXxb8MPpsc52/h1KcEhSxJjZUy2YKQwdkd6IZ3/GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785121663; c=relaxed/simple;
	bh=PsmODh4HRxkC6YHtBnIBUs2UJX8NrYrq1TscdKsxeVw=;
	h=Date:To:From:Subject:Message-Id; b=A9d63RdSXd8fuT+7/W+wMaV72dex7ktU6tLAR3T4fBVvE7txpbJn1Ri5etGP+49GSBnG8chwTSU2An6uemuFULj/i+ejtfp4FBL5Hr0luX8Weo0VOyPfdA3vwoCYJdrc3VG705pOYSWGy+Siw5rq8/ANJCiON0J0HXsDq8Vib0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HU0cCgAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HU0cCgAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCC71F000E9;
	Mon, 27 Jul 2026 03:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785121661;
	bh=dbfSCa0A2xejYU3mNYsXCIjkH8ad4MTg+0u1+gqfELA=;
	h=Date:To:From:Subject;
	b=HU0cCgAAmaSTQawUFnC2QTH72UZd/T4cfl6PxA0+OZwylEftLgYkdPZw/DisMNF9a
	 GOj4pfZ0rUp8cQB1kdlJqf4/qUdF+nJhrHLhogVqoo5yNCgfj8oXvoi7HyHcCmFVVy
	 pMMfxl1GxIwfMHMN6JlQQ1fkz3yv15Iqb34DN3dM=
Date: Sun, 26 Jul 2026 20:07:41 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] powerpc-xive-fix-use-after-free-of-xive_ipis.patch removed from -mm tree
Message-Id: <20260727030741.BBCC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/xive: fix use-after-free of xive_ipis
has been removed from the -mm tree.  Its filename was
     powerpc-xive-fix-use-after-free-of-xive_ipis.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gou Hao <gouhao@uniontech.com>
Subject: powerpc/xive: fix use-after-free of xive_ipis
Date: Fri, 24 Jul 2026 10:28:48 +0800

When irq_domain_alloc_irqs() fails in xive_init_ipis(), the error path
frees the global xive_ipis array via kfree().  However, xive_smp_probe()
ignores the error return and proceeds to call xive_setup_cpu_ipi(), which
dereferences the already-freed xive_ipis pointer, resulting in a
use-after-free.

Propagate the error from xive_init_ipis() through xive_smp_probe() and
check it in both pnv_smp_probe() and pSeries_smp_probe() so that IPI setup
is aborted cleanly on failure.

Link: https://lore.kernel.org/20260724022851.466017-4-gouhao@uniontech.com
Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Cc: Bharat Potnuri <bharat@chelsio.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/smp.c |    8 +++++---
 arch/powerpc/platforms/pseries/smp.c |    8 +++++---
 arch/powerpc/sysdev/xive/common.c    |    6 +++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/powernv/smp.c~powerpc-xive-fix-use-after-free-of-xive_ipis
+++ a/arch/powerpc/platforms/powernv/smp.c
@@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
 
 static void __init pnv_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	if (cpu_has_feature(CPU_FTR_DBELL)) {
 		ic_cause_ipi = smp_ops->cause_ipi;
--- a/arch/powerpc/platforms/pseries/smp.c~powerpc-xive-fix-use-after-free-of-xive_ipis
+++ a/arch/powerpc/platforms/pseries/smp.c
@@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu
 
 static __init void pSeries_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	/* No doorbell facility, must use the interrupt controller for IPIs */
 	if (!cpu_has_feature(CPU_FTR_DBELL))
--- a/arch/powerpc/sysdev/xive/common.c~powerpc-xive-fix-use-after-free-of-xive_ipis
+++ a/arch/powerpc/sysdev/xive/common.c
@@ -1256,10 +1256,14 @@ noinstr static void xive_cleanup_cpu_ipi
 
 int __init xive_smp_probe(void)
 {
+	int ret;
+
 	smp_ops->cause_ipi = xive_cause_ipi;
 
 	/* Register the IPI */
-	xive_init_ipis();
+	ret = xive_init_ipis();
+	if (ret < 0)
+		return ret;
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

