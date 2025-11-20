Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0917736922E
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658111; cv=none; b=eU0QETPWYgUj0imx/nI511aye4G4eTKYnKtD7loCFJ7ain50N6n2X0d+2iyXfj+WaMI+Ad9CKYR3znP7SuzcSa25VI/lDNaC2/EFS5/YQOjRO+UufG40RUbvZWJnxyKSvaQgPdBd7YUpWkk0S7KUdwiRBiHkMjaBa2W6n3lma5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658111; c=relaxed/simple;
	bh=4nq47d68/uScmch8M2OVZxc1cm1rrzVpOJI5IM18g4I=;
	h=Date:To:From:Subject:Message-Id; b=L8+zg74rrin+rSpVJnk0XOLbDhG1HOGZcLOPiGC+J4AFWzpvQtsA2nOjaBuSvAeDF7sa7+ZGGvv4yfVE0qB7oA0llLi1aCpnyfRTiJz2iOpEsEdDJtr+qLmbcl2ASXTl1VK/hrxoyEl77UcEFeaSQ0dCqIWnfh48PtOzIMiL7+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ri0kB/pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ri0kB/pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B283C116C6;
	Thu, 20 Nov 2025 17:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763658110;
	bh=4nq47d68/uScmch8M2OVZxc1cm1rrzVpOJI5IM18g4I=;
	h=Date:To:From:Subject:From;
	b=ri0kB/pwYMseHvpJgX4OXt+iYhWAhnxhVAdukZmsb3KM+06LJe2LFXeXB/Q5DGpOJ
	 CiLJ89do0ld752WPyRA56EXuqYq054H2WJYbgzp+9X2vTGKNDZkRilrsq+fRMb3mIe
	 vwNdgdYP0vJws9DoVfZHYDgphjuwSSNAJe85bhh0=
Date: Thu, 20 Nov 2025 09:01:49 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch added to mm-unstable branch
Message-Id: <20251120170150.6B283C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
Date: Thu Nov 20 07:59:25 AM PST 2025

add `inline' to shmem_uncharge() stub, per Balbir

Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/shmem_fs.h~mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
+++ a/include/linux/shmem_fs.h
@@ -143,7 +143,7 @@ static inline unsigned long shmem_swap_u
 	return 0;
 }
 
-static void shmem_uncharge(struct inode *inode, long pages)
+static inline void shmem_uncharge(struct inode *inode, long pages)
 {
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-propagate-vm_softdirty-on-merge-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

