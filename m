Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AAA21ABD7
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409719; cv=none; b=r+fIMyiskMRQccikiO7JYJAcshVJXMiOU/TsSD7ipdFpq9q8peb58MZ2n9DsvCbclaCKnjKdGrrL8FxJxKlmOdEX3oazCkXwHVxvo8YRRt+x+6n6o2EUcizr/EKsVFfFbcmspEVh+avTB3pyIhXiTGQkK5p4ZU/ZvPoYSH8xbvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409719; c=relaxed/simple;
	bh=esL7nxe1je4X+vqpC5FqqJDp4IZ9kFnFCluSpTH1dyM=;
	h=Date:To:From:Subject:Message-Id; b=sQo4Imxblmruvb3iVBMyZSolIZ8+SRTO84cMm16AREspzwfU2b0U0akkANxW5S4+dbRr6CrrUmKHGlnRRBkfxpEAbiVn0NmhxXs7ZSiqDB3uKR1ftw728IUwoaSC24wllwKt+DRn+qkuRnuofTGhBb5piZiJcRcxO8ycf9caGR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTTL1S7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTTL1S7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883A9C4CEED;
	Fri, 25 Jul 2025 02:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409719;
	bh=esL7nxe1je4X+vqpC5FqqJDp4IZ9kFnFCluSpTH1dyM=;
	h=Date:To:From:Subject:From;
	b=MTTL1S7JSlLlKiEewzQ99BGb++l4FLENeXCzFhPUIjBE07ZNDq9Sjd5sfKuEHZgq3
	 sCdmrjHicWjYzOH4lNWaqpbOmkcopYyL4VglXHEdveSi54lrlemNljol0DqAZo8hfY
	 kG3+iD2JVuMQG6+uC6gMs6q44y5w8x7o4TMkL6o4=
Date: Thu, 24 Jul 2025 19:15:19 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,davem@davemloft.net,brauner@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch removed from -mm tree
Message-Id: <20250725021519.883A9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/Kconfig: enable HUGETLBFS only if ARCH_SUPPORTS_HUGETLBFS
has been removed from the -mm tree.  Its filename was
     fs-kconfig-enable-hugetlbfs-only-if-arch_supports_hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


