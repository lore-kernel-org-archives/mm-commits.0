Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7A73EDE59
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816367; cv=none; b=PVPcatrie/0m5ezG/j6JOFNFxY/an8g6p5Hw8perrX4HS+Cg832n6x8bKiSEJ1aQR0ajnv95K9v0Ouh79jHGDOsDC+FX5qO3aU+EeuKxFAyJgaQX7Ipk4KGo3Cid9RxatJJmsaxZqFmgvltk74Y/DGB1sBq31+adKimmMEme83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816367; c=relaxed/simple;
	bh=wv79aSn7hIyjbBgK0O2OyGPxVydv8+35Ob5+ITvjMeg=;
	h=Date:To:From:Subject:Message-Id; b=e98PJifL2rYSICqbv6LexUidWKjT3yuiDPin4xMI2u89n8pRZqV+HtqYVymAZq7jyB2id5GE7JpuW/l6kt81wl+fFdKHRoFHfpUNF7TeY0mMU0KZpgBHQU7dGS+VgHC377E11KdqPwn0U6+STjkfqfv0MsmQ/w+4U9AAj/QGqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/31NWpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/31NWpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47231F00A3A;
	Tue,  4 Aug 2026 04:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816365;
	bh=JoVguiFvvOXLRyJGpCMHOmYn0m6AuM72eNfuwF+/w9w=;
	h=Date:To:From:Subject;
	b=L/31NWpB7QELGPusMrOLznWx4kWo+QNzipxmxib961ETmAA4Ym7vhDc6M5A36WH+C
	 wzhe3o7Mgr0snwB5FmSKA1jyMgI11iFE5wz/aizGPuH/n31wNSiYKMA8Co34MScpuS
	 N/P2ef3EqfJ1qEMDgijYBbtZ7RD1k/T710JZ4kEA=
Date: Mon, 03 Aug 2026 21:06:05 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,apopple@nvidia.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch removed from -mm tree
Message-Id: <20260804040605.C47231F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
has been removed from the -mm tree.  Its filename was
     drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Alistair Popple <apopple@nvidia.com>
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


