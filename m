Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C42E20CCE5
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160833; cv=none; b=dIkJ0nWtpz8c5QAyTiaFcSltF4FOcF3EiKFGbfHBlRyl5fdAMPV4zRpIVk6FVjnFmaVx5U167lXjL3yW/88WmtgQju5qGD9fmLjrgvMlsOD0xHC/sf6t5qyeeTPux1wN6jFy8PvMuYXWRRamLF+eE75zpwfainQ1DXkACXqXFas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160833; c=relaxed/simple;
	bh=3mDzMyHBD5d77d5PXsKKQOyx0kOtpwLlNXJHtJcxSbs=;
	h=Date:To:From:Subject:Message-Id; b=c4h7Mu1MJGAEOqfns6OB7ZUDJPoYYNS757ehwHbU3naOjuaZBqgW4kehAgwDAa9mtqE+gi/JJ5X9H889GdkLlhOUxHlk2A07j34lww8W0jKVr1ZajT0up+4S0TddTxVMUugnxCkwx18pwn1b7J7TNbsdOIah7cL/XVi4kneCnvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PYUwm/em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PYUwm/em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA62C4CEEF;
	Sat,  2 Aug 2025 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160832;
	bh=3mDzMyHBD5d77d5PXsKKQOyx0kOtpwLlNXJHtJcxSbs=;
	h=Date:To:From:Subject:From;
	b=PYUwm/emTrNxLFsKcSQzu9UzgumAzjeYWeB74S9B++3Uc0u9/UrEJGPodoCXqK01Q
	 wA4z4Z5l9NlOVeKveC7g3vTsiH/wi5eIuwO6K2JUxUsEY7s6iwHbZue1nNHg9P68ai
	 goZKKmERRc8k0qEOKzxkJdedWqx+blwTDvyEk9rI=
Date: Sat, 02 Aug 2025 11:53:52 -0700
To: mm-commits@vger.kernel.org,ville.syrjala@linux.intel.com,patryk@kowalczyk.ws,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch removed from -mm tree
Message-Id: <20250802185352.DAA62C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5981,8 +5981,8 @@ struct folio *shmem_read_folio_gfp(struc
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


