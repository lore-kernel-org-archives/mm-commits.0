Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E786A19DF60
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 23:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752362204; cv=none; b=s3AZxmB+jSmb/+lA2ERcOmLw6MeO6uPm1IM0sSxpD8XwltLJN7WHXcybM3OV6JeLpX7Bw1GQNMyvT9bWusI9a9hfltlzEEOqe28ClDTpPJF10Gmxsk/1Y6D6FpCNBQcST75MV3OBP/HiloAd/w2TsMftqfYKwHjwmiETunkzD28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752362204; c=relaxed/simple;
	bh=Pa2dOlk51as2Ao4za83QYTwAhTZ1XItRq8+DtZGaV/k=;
	h=Date:To:From:Subject:Message-Id; b=koORWYykibmh/+OtByLnl1/2NSf2jL4o1AtolSAE+q22KzT5SDxQUkUGO+ZiB6aR8iPzP9zAQtqB6mPHRi3Gqgox1HMK4zpSo6o6wiCtqDKP/f+vNxIYp0C5GvAtD12sFMVFWqnkvIqRk+FNYByofs1X9uoRZJKfjkO2DrdE8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z6hbCBJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z6hbCBJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB8C4CEEF;
	Sat, 12 Jul 2025 23:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752362203;
	bh=Pa2dOlk51as2Ao4za83QYTwAhTZ1XItRq8+DtZGaV/k=;
	h=Date:To:From:Subject:From;
	b=Z6hbCBJjZf+IPfa0QxhXfzYYnZBEPyBFcYRETgcYPoYtlSsMtoJJiQ50IrRKa/crc
	 jB02cTQR35wFk3FRDxFZ4xVRc4IacDMLPkTKfML86kGODetjsyHP23NCb5EJ25HIe3
	 f9+yYf5euuLEoi9aS4IvxeKrrXIOGi0MjRNS6Fo0=
Date: Sat, 12 Jul 2025 16:16:42 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,davem@davemloft.net,brauner@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch added to mm-nonmm-unstable branch
Message-Id: <20250712231643.48AB8C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/Kconfig: enable HUGETLBFS only if ARCH_SUPPORTS_HUGETLBFS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: fs/Kconfig: enable HUGETLBFS only if ARCH_SUPPORTS_HUGETLBFS
Date: Fri, 11 Jul 2025 15:59:34 +0530

Enable HUGETLBFS only when platform subscrbes via ARCH_SUPPORTS_HUGETLBFS.
Hence select ARCH_SUPPORTS_HUGETLBFS on existing x86 and sparc for their
continuing HUGETLBFS support.  While here also just drop existing 'BROKEN'
dependency.

Link: https://lkml.kernel.org/r/20250711102934.2399533-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig |    1 +
 arch/x86/Kconfig   |    1 +
 fs/Kconfig         |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/sparc/Kconfig~fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs
+++ a/arch/sparc/Kconfig
@@ -97,6 +97,7 @@ config SPARC64
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select ARCH_SUPPORTS_HUGETLBFS
 	select HAVE_NMI
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select ARCH_USE_QUEUED_RWLOCKS
--- a/arch/x86/Kconfig~fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs
+++ a/arch/x86/Kconfig
@@ -125,6 +125,7 @@ config X86
 	select ARCH_SUPPORTS_ACPI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
--- a/fs/Kconfig~fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs
+++ a/fs/Kconfig
@@ -249,7 +249,7 @@ config ARCH_SUPPORTS_HUGETLBFS
 
 menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
-	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
+	depends on ARCH_SUPPORTS_HUGETLBFS
 	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
 	select PADATA if SMP
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch

