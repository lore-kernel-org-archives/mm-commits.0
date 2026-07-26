Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AE26ED41
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036639; cv=none; b=RrddtdKv6+ar161zozLt6WGwn/6HT8uoNWOoAp4AKAtmTTWViVda5FFzWsSJ1N49TukR0wsHYwkQ6EqqYh0h3k0G0+pBJE+LuLjboPN2xEt57Hm2CELlpoOJGJBTCIuq+mudkc+SiD7O4EE3KdvGgvQGoVip4NJZSpLVqv8rmcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036639; c=relaxed/simple;
	bh=oK94rcsIjAUrjP+uFxiXC143R+CS2WxxRsrASlN+stU=;
	h=Date:To:From:Subject:Message-Id; b=AQrHjp78YioB+mjcC1Hd/BySxNZ46o358ONVORiGFjlCrHUmVUBrY1VwzZppC8gjyyJrHiDYw7PUhJNLMSMEzSOS4B8NzIoowVNitlN/Te0aeeZDacfqI9XiqGMzB69JQ29Yteww7YlrT65Cck/jIN8NQIEL6qS9cGTTsFz7PFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TduMRVFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TduMRVFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0418A1F00A3A;
	Sun, 26 Jul 2026 03:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036638;
	bh=XyV2qisLHtZknXgbPgQnYX8Qfq7pNI27t2Xqmdn76pI=;
	h=Date:To:From:Subject;
	b=TduMRVFgVIS30MdMcRZlKpGAN2P7qDvSwPeJet86jCOvgiCe0sefh1ZFwUxz5iJt6
	 kATJ8EWzhnKe5sDzu5/wsY6J8K2qgG+BNqlujrGrdkyc473fmLGcyMGYqKGhCSSWdI
	 OviZSFeGV7nSMDy5SnzmDUQvFJbiG/BnVEHBf9Vk=
Date: Sat, 25 Jul 2026 20:30:37 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-xive-add-error-return-value-to-xive_smp_probe.patch added to mm-nonmm-unstable branch
Message-Id: <20260726033038.0418A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/xive: add error return value to xive_smp_probe()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-xive-add-error-return-value-to-xive_smp_probe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-xive-add-error-return-value-to-xive_smp_probe.patch

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
@@ -1254,7 +1254,7 @@ noinstr static void xive_cleanup_cpu_ipi
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1263,6 +1263,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch
powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

