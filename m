Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129EA21931C
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545920; cv=none; b=YA9GX0qStJBaSB6L679NC3M0EoJ1u9TqOPc81s3K6fnctHsVwVixvPCYgpwBryXOXzDyuWpPfTwKZsM/WyGu+hqLIsFRQnGbkahrNthiSqhLBfjUQbdH4y0QuhbpOIP2fYA2FIRC8orkKqM2vtALYwUjrTwmD1ipekiPG0z91Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545920; c=relaxed/simple;
	bh=AZ9Pp0xit/nWQ6Ke67aWAMSDaGSWl8uXBGSRjUmetG8=;
	h=Date:To:From:Subject:Message-Id; b=F5ltvhWqM+l+Pxstp9gYyKcxaaprTWogTHVbloYaJbZUhdODIGE5N2sK4ogsVMjiBtH5yA21H3D2edwHgQgT26mRK7PPnO8U2GTZRDytHSrV8hssv+q2/D9gadXscmuxupyAiwgaTsVHHez0g2nu50C3b/44oXdADAMr3oCOaLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tw3UWbuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tw3UWbuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7219C4CEE4;
	Tue,  1 Apr 2025 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545919;
	bh=AZ9Pp0xit/nWQ6Ke67aWAMSDaGSWl8uXBGSRjUmetG8=;
	h=Date:To:From:Subject:From;
	b=Tw3UWbuW7wA/mc5HDp49PfZc7ata3CXMnXNdoItt4D2iYeg5FrB9rDgtM3l82T6f7
	 Xm0MpAKc4cWOJ1/X8vrXnO0kebGbz3q2gl8lmjKGaDtSejCeHy5m1Gqcu2gsRIMi8X
	 lPH/dkwCEthj8AIdfMRH8JPs5Yn+dMhGAA3MKz0w=
Date: Tue, 01 Apr 2025 15:18:39 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-enable-s390.patch removed from -mm tree
Message-Id: <20250401221839.D7219C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: enable s390
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-enable-s390.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: mseal sysmap: enable s390
Date: Tue, 11 Mar 2025 13:33:26 +0100

Provide support for CONFIG_MSEAL_SYSTEM_MAPPINGS on s390, covering the
vdso.

[hca@linux.ibm.com: update supported architectures]
  Link: https://lkml.kernel.org/r/20250317131917.1332402-1-hca@linux.ibm.com
Link: https://lkml.kernel.org/r/20250311123326.2686682-3-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |    3 ++-
 arch/s390/Kconfig                     |    1 +
 arch/s390/kernel/vdso.c               |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/Kconfig~mseal-sysmap-enable-s390
+++ a/arch/s390/Kconfig
@@ -137,6 +137,7 @@ config S390
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
+	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_USE_BUILTIN_BSWAP
--- a/arch/s390/kernel/vdso.c~mseal-sysmap-enable-s390
+++ a/arch/s390/kernel/vdso.c
@@ -80,7 +80,7 @@ static int map_vdso(unsigned long addr,
 	vdso_text_start = vvar_start + VDSO_NR_PAGES * PAGE_SIZE;
 	/* VM_MAYWRITE for COW so gdb can set breakpoints */
 	vma = _install_special_mapping(mm, vdso_text_start, vdso_text_len,
-				       VM_READ|VM_EXEC|
+				       VM_READ|VM_EXEC|VM_SEALED_SYSMAP|
 				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				       vdso_mapping);
 	if (IS_ERR(vma)) {
--- a/Documentation/userspace-api/mseal.rst~mseal-sysmap-enable-s390
+++ a/Documentation/userspace-api/mseal.rst
@@ -143,7 +143,8 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
 
-  The following architectures currently support this feature: x86-64 and arm64.
+  The following architectures currently support this feature: x86-64, arm64,
+  and s390.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
_

Patches currently in -mm which might be from hca@linux.ibm.com are


