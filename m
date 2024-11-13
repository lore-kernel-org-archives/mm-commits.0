Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323D229A5;
	Wed, 13 Nov 2024 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461496; cv=none; b=dJem0UOPDbh7cXilMldxcOpE+oQGJwF1DaXKNCX+VCl1Bu2XNswSkFFs7UHdWqoz5e21tgAK8D6AzSzbYcOawth3rxfd/oUrBZKTJwAo+rQmOs+sOR8QrPB0zkb6hvkJRp0q5zmVj6SyqM67CPK8t/7+1UTWS1LRfjOzPZ89tk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461496; c=relaxed/simple;
	bh=x2yHj+KDgUyLwCQAKlmWBsyCmBxVapbNcnrLJQal0rs=;
	h=Date:To:From:Subject:Message-Id; b=FVoCFZy5/dCwsVkPXvmJN4ljSzPyVZauXKwYRPROWH2ZxYEYE6k1I0JMM+gU2uKQExprHFOsnUNiduOCjMtkcNiWFRZ45WuLvKgnEEloz5Eg74trGn8AGseSnZ4fARJB6yuKGRVmRpJ6XFDkh50+dOwdnHufPEYrJ4OSJf8hQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLl2mEJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLl2mEJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98C7C4CECD;
	Wed, 13 Nov 2024 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731461495;
	bh=x2yHj+KDgUyLwCQAKlmWBsyCmBxVapbNcnrLJQal0rs=;
	h=Date:To:From:Subject:From;
	b=tLl2mEJ+6WfBRt3SWBTU+qVLNViM9/cEysPOWeAaNQRWGji0bs/JkDSdgfh/Bq4H0
	 mxQS4IdckRkBFkBxn5B7Wj1y6GmJNNy+L67XKpwUqRXXMFrLwvx3dj05RM0P9wvAPl
	 Y0mosio7kPj9IlllZchPsopzf939pbsZhzga6jeU=
Date: Tue, 12 Nov 2024 17:31:35 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Reimar.Doeffinger@gmx.de,mpe@ellerman.id.au,glaubitz@physik.fu-berlin.de,ebiederm@xmission.com,bhe@redhat.com,dave@vasilevsky.ca,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32.patch added to mm-hotfixes-unstable branch
Message-Id: <20241113013135.A98C7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash, powerpc: default to CRASH_DUMP=n on PPC_BOOK3S_32
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32.patch

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
From: Dave Vasilevsky <dave@vasilevsky.ca>
Subject: crash, powerpc: default to CRASH_DUMP=n on PPC_BOOK3S_32
Date: Tue, 17 Sep 2024 12:37:20 -0400

Fixes boot failures on 6.9 on PPC_BOOK3S_32 machines using Open Firmware. 
On these machines, the kernel refuses to boot from non-zero
PHYSICAL_START, which occurs when CRASH_DUMP is on.

Since most PPC_BOOK3S_32 machines boot via Open Firmware, it should
default to off for them.  Users booting via some other mechanism can still
turn it on explicitly.

Does not change the default on any other architectures for the
time being.

Link: https://lkml.kernel.org/r/20240917163720.1644584-1-dave@vasilevsky.ca
Fixes: 75bc255a7444 ("crash: clean up kdump related config items")
Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
Reported-by: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
Closes: https://lists.debian.org/debian-powerpc/2024/07/msg00001.html
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig       |    3 +++
 arch/arm64/Kconfig     |    3 +++
 arch/loongarch/Kconfig |    3 +++
 arch/mips/Kconfig      |    3 +++
 arch/powerpc/Kconfig   |    4 ++++
 arch/riscv/Kconfig     |    3 +++
 arch/s390/Kconfig      |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/x86/Kconfig       |    3 +++
 kernel/Kconfig.kexec   |    2 +-
 10 files changed, 29 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/arm64/Kconfig
@@ -1576,6 +1576,9 @@ config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_S
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
--- a/arch/arm/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/arm/Kconfig
@@ -1598,6 +1598,9 @@ config ATAGS_PROC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address" if !ARCH_MULTIPLATFORM
 	default !(ARCH_FOOTBRIDGE || ARCH_RPC || ARCH_SA1100)
--- a/arch/loongarch/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/loongarch/Kconfig
@@ -604,6 +604,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SELECTS_CRASH_DUMP
 	def_bool y
 	depends on CRASH_DUMP
--- a/arch/mips/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/mips/Kconfig
@@ -2876,6 +2876,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded"
 	default "0xffffffff84000000"
--- a/arch/powerpc/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/powerpc/Kconfig
@@ -684,6 +684,10 @@ config RELOCATABLE_TEST
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
 
+config ARCH_DEFAULT_CRASH_DUMP
+	bool
+	default y if !PPC_BOOK3S_32
+
 config ARCH_SELECTS_CRASH_DUMP
 	def_bool y
 	depends on CRASH_DUMP
--- a/arch/riscv/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/riscv/Kconfig
@@ -898,6 +898,9 @@ config ARCH_SUPPORTS_KEXEC_PURGATORY
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
--- a/arch/s390/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/s390/Kconfig
@@ -276,6 +276,9 @@ config ARCH_SUPPORTS_CRASH_DUMP
 	  This option also enables s390 zfcpdump.
 	  See also <file:Documentation/arch/s390/zfcpdump.rst>
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 menu "Processor type and features"
 
 config HAVE_MARCH_Z10_FEATURES
--- a/arch/sh/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/sh/Kconfig
@@ -550,6 +550,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool BROKEN_ON_SMP
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SUPPORTS_KEXEC_JUMP
 	def_bool y
 
--- a/arch/x86/Kconfig~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/arch/x86/Kconfig
@@ -2084,6 +2084,9 @@ config ARCH_SUPPORTS_KEXEC_JUMP
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool X86_64 || (X86_32 && HIGHMEM)
 
+config ARCH_DEFAULT_CRASH_DUMP
+	def_bool y
+
 config ARCH_SUPPORTS_CRASH_HOTPLUG
 	def_bool y
 
--- a/kernel/Kconfig.kexec~crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32
+++ a/kernel/Kconfig.kexec
@@ -97,7 +97,7 @@ config KEXEC_JUMP
 
 config CRASH_DUMP
 	bool "kernel crash dumps"
-	default y
+	default ARCH_DEFAULT_CRASH_DUMP
 	depends on ARCH_SUPPORTS_CRASH_DUMP
 	depends on KEXEC_CORE
 	select VMCORE_INFO
_

Patches currently in -mm which might be from dave@vasilevsky.ca are

crash-powerpc-default-to-crash_dump=n-on-ppc_book3s_32.patch

