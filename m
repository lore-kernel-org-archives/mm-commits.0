Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502162E36F8
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 21:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754084683; cv=none; b=pfF6oT2521zz7XiFXVOYo/Gq29r/8MaYSpwmx082lqEtvR+wt96qnIYTD78kxMjwKClmN0Sox0hwT4C0uy3/qAFg+upWvsxtL8A+SzNM8K3F1dl+dsY2gdeXTQAkE2DAfx9BPe0Qo9+TtHd8Dhn8KeMgbi6NX6arMRLZcb25ZtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754084683; c=relaxed/simple;
	bh=dA+bEN+u6D0RDxOcRVsHRWGpQIwKEVpr1EZBfakBSlY=;
	h=Date:To:From:Subject:Message-Id; b=HSfk3fAHJGobvRteK7BfoLtR4MQjZcH6AqZqvV2uAu+yA/jfYUVdVGxm8QyaE9gblAHC0/7YOXdZ2L+StlhpGt/VSwXS0kCmGPO/ILblrkahOwjaUC/MPoOdVjoSnJo+UhPECshJOHA3DwbUmKpHs29dtsID4E7eMcGMKg8ZBdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZbKi1V9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZbKi1V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81C6C4CEE7;
	Fri,  1 Aug 2025 21:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754084682;
	bh=dA+bEN+u6D0RDxOcRVsHRWGpQIwKEVpr1EZBfakBSlY=;
	h=Date:To:From:Subject:From;
	b=oZbKi1V90LGmyIqsBA0jOaROO36uWCuDohXV+hpzMPvBsHGdOsWcEf+kIxPqIGh8E
	 qff/Ucu6cDMkyUAaFpfBkzNzdCVzRghOk3frlHPDvHKB/Z6NcoFbP1QPv3yw6rg/nN
	 zZ8GgKndPzqXX8zkfEPFBjz5/259vX9+0nslmBcY=
Date: Fri, 01 Aug 2025 14:44:41 -0700
To: mm-commits@vger.kernel.org,ville.syrjala@linux.intel.com,patryk@kowalczyk.ws,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801214442.C81C6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
Date: Thu, 31 Jul 2025 09:53:43 +0800

After commit acd7ccb284b8 ("mm: shmem: add large folio support for
tmpfs"), we extend the 'huge=' option to allow any sized large folios for
tmpfs, which means tmpfs will allow getting a highest order hint based on
the size of write() and fallocate() paths, and then will try each
allowable large order.

However, when the i915 driver allocates shmem memory, it doesn't provide
hint information about the size of the large folio to be allocated,
resulting in the inability to allocate PMD-sized shmem, which in turn
affects GPU performance.

Patryk added:

: In my tests, the performance drop ranges from a few percent up to 13%
: in Unigine Superposition under heavy memory usage on the CPU Core Ultra
: 155H with the Xe 128 EU GPU.  Other users have reported performance
: impact up to 30% on certain workloads.  Please find more in the
: regressions reports:
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
:
: I believe the change should be backported to all active kernel branches
: after version 6.12.

To fix this issue, we can use the inode's size as a write size hint in
shmem_read_folio_gfp() to help allocate PMD-sized large folios.

Link: https://lkml.kernel.org/r/f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/mm/shmem.c
@@ -5949,8 +5949,8 @@ struct folio *shmem_read_folio_gfp(struc
 	struct folio *folio;
 	int error;
 
-	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
-				    gfp, NULL, NULL);
+	error = shmem_get_folio_gfp(inode, index, i_size_read(inode),
+				    &folio, SGP_CACHE, gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

