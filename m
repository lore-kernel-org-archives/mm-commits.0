Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E012620F5
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714930; cv=none; b=QGmAYHEzGBgqPH+OpGQXJLAEOmm06omXL+xJZhCGFEEKseV0pDMSdjeLTBu47em31pywAlvk7bGQqqMgcwQHFzwplR2cB0C3GqYd1Wy7FjSbLyh66ntRhdOIN0ydedUcZcWv5v4SWjgl8fRAZdNAZOe3e9/hdSEFzzVfJ4eSjBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714930; c=relaxed/simple;
	bh=4LZgvpuOjKruLU45ufhWJOthqaC336Ljng3Mx+ZjhD4=;
	h=Date:To:From:Subject:Message-Id; b=sSy1LWE/4yMgD/FlrLtDlzppK5uBh9unw5I7BxPy4q0FdBY7b70kVDbfRVLKMm+PBEzzRSzLPKpLsocjUkmD++v09AwW+qSgLyLtlojAtZXCiTS+H80H7G/EfRFl238BB0eTjpVKiXH50c3i1t4FlhBc63F1pvhvYOhjZCRWE+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oiGY1qVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oiGY1qVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC2C4CEF0;
	Tue, 11 Mar 2025 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714929;
	bh=4LZgvpuOjKruLU45ufhWJOthqaC336Ljng3Mx+ZjhD4=;
	h=Date:To:From:Subject:From;
	b=oiGY1qVyd0H/EcziLNO/qOI4E30YXMo3DxNRCuSeB1sJ3BGxNqXXtJ6cwz3AFY0Kr
	 0NMfwW8I71ehCphcT9+gZToyz9LpKx/Ut8JQ8AJrIS5q23q3hNS7b9qpA/34RG2Cc7
	 i2efUFVO0DBGU4/cermfpOuEYYEgbNMg26Zc4i0M=
Date: Tue, 11 Mar 2025 10:42:09 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-generic-vdso-vvar-mapping.patch added to mm-unstable branch
Message-Id: <20250311174209.D1BC2C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: generic vdso vvar mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-generic-vdso-vvar-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-generic-vdso-vvar-mapping.patch

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
From: Heiko Carstens <hca@linux.ibm.com>
Subject: mseal sysmap: generic vdso vvar mapping
Date: Tue, 11 Mar 2025 13:33:25 +0100

With the introduction of the generic vdso data storage the VM_SEALED_SYSMAP
vm flag must be moved from the architecture specific
_install_special_mapping() call [1] [2] which maps the vvar mapping to
generic code.

[1] https://lkml.kernel.org/r/20250305021711.3867874-4-jeffxu@google.com
[2] https://lkml.kernel.org/r/20250305021711.3867874-5-jeffxu@google.com

Link: https://lkml.kernel.org/r/20250311123326.2686682-2-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vdso/datastore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/vdso/datastore.c~mseal-sysmap-generic-vdso-vvar-mapping
+++ a/lib/vdso/datastore.c
@@ -99,7 +99,8 @@ const struct vm_special_mapping vdso_vva
 struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr)
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
-					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP | VM_PFNMAP,
+					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
+					VM_PFNMAP | VM_SEALED_SYSMAP,
 					&vdso_vvar_mapping);
 }
 
_

Patches currently in -mm which might be from hca@linux.ibm.com are

mseal-sysmap-generic-vdso-vvar-mapping.patch

