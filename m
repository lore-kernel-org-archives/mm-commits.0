Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBEF26ED41
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036642; cv=none; b=mxuqUd3mLHtD3uvNflFDZpC79L8+7bd99iR/7oVzh4lC2upoGoDu4KJG10VzhQUj5jEEpQESue085kMkS/n2Qh4mIJ/COLPtPaacQe6qUFQZdnvAcsjDuMUmBjymWel0+GE9ikKiorvq7bnYq4usOY7E9s3jsw7fWvAk8FtKQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036642; c=relaxed/simple;
	bh=I800UhJW0+cO4OZrojkUcrZKTdvuEAbXKbY1kSKoL4Q=;
	h=Date:To:From:Subject:Message-Id; b=QDqon00xbLmOHBsNu6janAXMp1rE+Qi5DgtSfYdqS9WhhVDu5Mme7R5FZy15zD/4rhNahlRJrpqjniCDGY9FZUouP2Am9qiJVESNEC2XGZzFYp7RfiJmhIBtlW3Pn34PIso9dS93GgtKY0vhrZ0CxObF3emOZXtxyKuwQ5oEuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BY7YMtug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BY7YMtug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928EB1F000E9;
	Sun, 26 Jul 2026 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036640;
	bh=9VC/Ihy7MRBYIDBvfDTbWifqaGVoouQh2FIWHuYkUkQ=;
	h=Date:To:From:Subject;
	b=BY7YMtugJDhyDPyiBbc5vJZ3gSaaJoyCwt8s19OxamcZ+eo6oZlCKPZRZ5/njS/mN
	 nguxl/Prv85t90gyK8NtB05nm1hxlNxgv5vnWthsO5fquYFG0o+oFUbxHj6EOEIjP3
	 KbRU5FnyAlVsciKtWGRlUefbA/WZ00gTH7DqNfQ4=
Date: Sat, 25 Jul 2026 20:30:40 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-xive-fix-use-after-free-of-xive_ipis.patch added to mm-nonmm-unstable branch
Message-Id: <20260726033040.928EB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/xive: fix use-after-free of xive_ipis
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-xive-fix-use-after-free-of-xive_ipis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-xive-fix-use-after-free-of-xive_ipis.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch
powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

