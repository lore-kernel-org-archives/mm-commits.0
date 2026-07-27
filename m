Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D11A0BE0
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 03:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785121645; cv=none; b=DFNXR0zyUAYK2ZdYabHAMZD/1+Li67ZEzClbRt/21622j+TZNFXKR5lgD6g7UDVOBxuSNr/KgQdlRqo3qUxinYAeKyuOj/jfWIMcYDEE9SBbZtTGC+GaAS9toWhIIAY1ORidNj/unbuTMmsc5UGXxQ2QEVuQHu+EZE29zlpuLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785121645; c=relaxed/simple;
	bh=4Q1i3gwV3wJfnerETeLPPA4TZa0Yr+mIHuFpKvtsndU=;
	h=Date:To:From:Subject:Message-Id; b=Jww9EOLzLuSORskX9LJNhWSo0lUPwLMkWMDHtKpEZA+Z8kEvWbugRpL48HcGTlIPMyx8m6FDjHbh8/wB1PTTnzMR6P5ANPbTZu4XIq1EYJWBj7p8xuReP9SeVA3BQanDFD/o00jNihMUTl/VKRWuN85a8rnpQxCyMv+755/OVho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XeM2puoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XeM2puoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7AA1F000E9;
	Mon, 27 Jul 2026 03:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785121643;
	bh=SrnjxJ+zIyZE64OP4hEaOnrCcllzV/yhj2MdwazKNWc=;
	h=Date:To:From:Subject;
	b=XeM2puoH9xX2bjahCpFdGERWttpjV19U4iosBGQv+u+tROBOoaWhtgQKIWaP0L7Mt
	 7Umh6pPDTzwSiaCklKj8cotJBRJPrxuDebsa6hMe+5Q7OpdQpLOtdtzNxfUm2FH89Q
	 COUJkcQaVIXjjcZUITpMTrdi/LiAr1tDoh4iE1m8=
Date: Sun, 26 Jul 2026 20:07:22 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch removed from -mm tree
Message-Id: <20260727030723.6A7AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
has been removed from the -mm tree.  Its filename was
     powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gou Hao <gouhao@uniontech.com>
Subject: powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:46 +0800

Patch series "remove dead NULL checks after GFP_NOFAIL allocations and fix
xive use-after-free", v2.

This is a code cleanup series that removes unreachable NULL checks (and
associated error handling) that follow allocations using __GFP_NOFAIL,
which guarantees non-NULL return.


This patch (of 6):

kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code.  Remove it.

Link: https://lore.kernel.org/20260724022851.466017-1-gouhao@uniontech.com
Link: https://lore.kernel.org/20260724022851.466017-2-gouhao@uniontech.com
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

 arch/powerpc/sysdev/xive/common.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c~powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation
+++ a/arch/powerpc/sysdev/xive/common.c
@@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
 
 	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
 				 GFP_KERNEL | __GFP_NOFAIL);
-	if (!xive_ipis)
-		goto out_free_domain;
-
 	for_each_node(node) {
 		struct xive_ipi_desc *xid = &xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
@@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
 
 out_free_xive_ipis:
 	kfree(xive_ipis);
-out_free_domain:
+	xive_ipis = NULL;
 	irq_domain_remove(ipi_domain);
 out_free_fwnode:
 	irq_domain_free_fwnode(fwnode);
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

