Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF22D7DC4
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036645; cv=none; b=dBtImMHB8fz3UrX4MQoq5SFX7sBMPskdPctz+BedZLLm4yf+AZQqm3XUf7kGFdNJSTq+pzr+UF1fG0EtzfrKn3sUZhpd5wh1qhpdy1eTBqHUasOW5GI6A7yzO4KLqfmgXP3BcRVagU+4TT2zM1o4Wn9ZDuXdRTmwdToQ/04fuo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036645; c=relaxed/simple;
	bh=39zDLxLGMJ2F+zYUP18wFyYVDdwozDss7nqjlXNLZwA=;
	h=Date:To:From:Subject:Message-Id; b=JP7ENlMrdBiuLiEgnBPAQIwvDv6SaaTKhfkgE091sYsivBDibndH2uSLbJARjNySwvib9rBSMgTw3w/0iFRPY2TxjRgpET3GEipoP3HdVyQ5abDtUZkjSZXH/7M6nJ+IJakYAQe2NjQ749eP5j40RfIouKGRQICPSOQG/BJvx+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1f6CxOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1f6CxOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D41F000E9;
	Sun, 26 Jul 2026 03:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036643;
	bh=GEkrRE0t0cYPb2Br0Tj3hOwxdfhICEuYHJVD+uBy+yc=;
	h=Date:To:From:Subject;
	b=Z1f6CxOxTnO+v1r7Lq5ZKoZLc/WlzpuxFvm8JAJSKjXELjun6Yt86V0Rszi8SNNH5
	 6VsNUGiFGoNAiTXr6UVt3tn7QmOgT2ba+aVJVmDMQAJoFJZ70eUPjmLc/C6TxCj2UK
	 r6WfbFykGxeGGFjyyVGpizZrjmSb3MvD+xGc90LM=
Date: Sat, 25 Jul 2026 20:30:43 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20260726033043.8F6D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch

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
Subject: drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:49 +0800

kzalloc_obj with the __GFP_NOFAIL flag will never return NULL, so the
subsequent WARN_ON(!ctx) is unreachable dead code.  Remove it.

Link: https://lore.kernel.org/20260724022851.466017-5-gouhao@uniontech.com
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Cc: Bharat Potnuri <bharat@chelsio.com>
Cc: Cédric Le Goater <clg@kaod.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: jiazhenyuan <jiazhenyuan@uniontech.com>
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
Cc: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_modeset_lock.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/drm_modeset_lock.c~drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation
+++ a/drivers/gpu/drm/drm_modeset_lock.c
@@ -149,11 +149,7 @@ void drm_modeset_lock_all(struct drm_dev
 	int ret;
 
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL | __GFP_NOFAIL);
-	if (WARN_ON(!ctx))
-		return;
-
 	mutex_lock(&config->mutex);
-
 	drm_modeset_acquire_init(ctx, 0);
 
 retry:
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch
powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

