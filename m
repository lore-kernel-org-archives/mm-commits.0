Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FC342586C
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816366; cv=none; b=Cx/SFgzF3sx0scC6fnDR1jALZBiE8sWEKdXnNJIu8FLTrQEV/sagtWxq/eEhwM4+yMbuvc3v9+pAYpdv5LPUNMM5NiQLjPHivjcl6/cI+j2heX7sWPa+goClxeuHKpuHc4DVEPR0Hc9Q9DPTFrgda1K+3QkdlqnHvdaXp5Z1/4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816366; c=relaxed/simple;
	bh=0ZYU5WlnWBneLD8sUDW+XZ5zULFVs5mCfq7zs/iCicY=;
	h=Date:To:From:Subject:Message-Id; b=B0rSkhBpBM8FPkl3/kxeTbivBAfCvbgucMfkdff2wkPKexeHnwBuaBeStyewduFiNz/OL2G/H4BiHQ1k64ukkETx35nvy5a1Dr7f8zgV6YxTx47I+m2xnBA7kkEFzFJBnPUCbjQVUfsRdlERBSfJuVO3bBWMz5+gGhApL7UAmE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdE4wUkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdE4wUkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A0B1F000E9;
	Tue,  4 Aug 2026 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816364;
	bh=QM0xBZ9SkrkFb+amGrJy1ZKZpLdT9sobJzow/fFardw=;
	h=Date:To:From:Subject;
	b=gdE4wUkOkqsQo82tlm4qa7eQv7eCt7LgPqQallO2qlUy1PgUmXIt8tvyBiL/mLuv9
	 u/YEbJiQdM1qPJISmsPZVbwSKiWqATRY5GMDeMw7zG+KALgn9xV4rTMa9NwwNbxVYe
	 Fu5vDlhWWE0lb62XId/IH/zk1xSY1VRJZPRUwIW4=
Date: Mon, 03 Aug 2026 21:06:04 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,apopple@nvidia.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-xive-add-error-return-value-to-xive_smp_probe.patch removed from -mm tree
Message-Id: <20260804040604.83A0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/xive: add error return value to xive_smp_probe()
has been removed from the -mm tree.  Its filename was
     powerpc-xive-add-error-return-value-to-xive_smp_probe.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gou Hao <gouhao@uniontech.com>
Subject: powerpc/xive: add error return value to xive_smp_probe()
Date: Fri, 24 Jul 2026 10:28:47 +0800

xive_smp_probe() calls xive_init_ipis() which can fail, but its return
value is currently ignored.  Change xive_smp_probe() to return int so that
errors can be propagated to callers.

This is a preparatory patch for the next one.

No functional change yet; the return value is always 0 at this point.

Link: https://lore.kernel.org/20260724022851.466017-3-gouhao@uniontech.com
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
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/xive.h   |    4 ++--
 arch/powerpc/sysdev/xive/common.c |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/xive.h~powerpc-xive-add-error-return-value-to-xive_smp_probe
+++ a/arch/powerpc/include/asm/xive.h
@@ -91,7 +91,7 @@ static inline bool xive_enabled(void) {
 
 bool xive_spapr_init(void);
 bool xive_native_init(void);
-void xive_smp_probe(void);
+int xive_smp_probe(void);
 int  xive_smp_prepare_cpu(unsigned int cpu);
 void xive_smp_setup_cpu(void);
 void xive_smp_disable_cpu(void);
@@ -153,7 +153,7 @@ static inline bool xive_enabled(void) {
 
 static inline bool xive_spapr_init(void) { return false; }
 static inline bool xive_native_init(void) { return false; }
-static inline void xive_smp_probe(void) { }
+static inline int xive_smp_probe(void) { return -EINVAL; }
 static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
 static inline void xive_smp_setup_cpu(void) { }
 static inline void xive_smp_disable_cpu(void) { }
--- a/arch/powerpc/sysdev/xive/common.c~powerpc-xive-add-error-return-value-to-xive_smp_probe
+++ a/arch/powerpc/sysdev/xive/common.c
@@ -1257,7 +1257,7 @@ noinstr static void xive_cleanup_cpu_ipi
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1266,6 +1266,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
_

Patches currently in -mm which might be from gouhao@uniontech.com are


