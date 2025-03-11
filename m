Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A5826159F
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741715118; cv=none; b=SK7SIW6gVQ50XehB8vVZN6LZStcrVE9SGK3o2HG22OwukBuTfCWErJm1IBekc2dLMN7KNS2i5fj7ByPTKTB1dyP/TznP/SduP6NKoNO2+N+efwdn4vb54xfaCN4Qq11qJziiLZqe6MPKVIfyEDPYdzungVr2IWUurEexNliVElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741715118; c=relaxed/simple;
	bh=mtbannsYKTBjO7unHu9xmm4A7xUjW4WFFBcSw20QhGs=;
	h=Date:To:From:Subject:Message-Id; b=BhLQfh/4UF+4ZwKut7fMz6vmJgV5X8fapYuhaAP/oY614tpv4Ie5U0y3TV39I16wbe/CVfsXuPypg/cVT3M2ka5WP0EElWFH5kt5V1Uv4PsXRua68qvRPDMMCS6sXVrTEvATs2YMfGmgmRQCP0y6yPhYgMACUxuR/46sslX0foU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bH3cMo+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bH3cMo+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646F2C4CEE9;
	Tue, 11 Mar 2025 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741715117;
	bh=mtbannsYKTBjO7unHu9xmm4A7xUjW4WFFBcSw20QhGs=;
	h=Date:To:From:Subject:From;
	b=bH3cMo+l3VBHBlfb2r7ti8bat85v9oe9281CWM/3wOBIcpLm5/k2hLrLIH3q0EnKQ
	 bMGQWCbxSrs8VAM9rrLrUu4r13njWTGZreyxG7UsgjkoHjw5cl/Cw3bxw9nAvb/Jo0
	 IE7yRa5TpcDZscQ6SuI/WIe15CtLk8pM5Cb7Pcpw=
Date: Tue, 11 Mar 2025 10:45:16 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-enable-s390.patch added to mm-unstable branch
Message-Id: <20250311174517.646F2C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: enable s390
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-enable-s390.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-enable-s390.patch

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
Subject: mseal sysmap: enable s390
Date: Tue, 11 Mar 2025 13:33:26 +0100

Provide support for CONFIG_MSEAL_SYSTEM_MAPPINGS on s390, covering the
vdso.

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

 arch/s390/Kconfig       |    1 +
 arch/s390/kernel/vdso.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/Kconfig~mseal-sysmap-enable-s390
+++ a/arch/s390/Kconfig
@@ -141,6 +141,7 @@ config S390
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
_

Patches currently in -mm which might be from hca@linux.ibm.com are

mseal-sysmap-generic-vdso-vvar-mapping.patch
mseal-sysmap-enable-s390.patch

