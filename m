Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC80A4A01
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178266; cv=none; b=HFfP6sjK99rrjHXsq1SB21zz5g7k66gnQ7rQr4tka6nUxoKtneKyHo2fZzyy/dEn/h6Qb2afBewoYqKxQpQrdvpnO81M/XkcmJszpN5VOjomLErB8rJz8fP09clSKE2afkKs6Kr2Yx2+5gW10E2Pce30wJzhytaED6mV00s5jXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178266; c=relaxed/simple;
	bh=c5L+s+vHfqjDUR77JfCNA1Z4xsihxYS5A42MuEiL3uo=;
	h=Date:To:From:Subject:Message-Id; b=m1d3mYOt/K4Cy57MalPS9H88yR1OJVHn1UHkJ+0i1kx5qsUIXlJzpnVbrppQFnf4gQ0ZSriyXZUE34vapLoHhP2J0Vnalbw8SEJQ/QB9IKOGAgsEOIjqRO9xzSAhCi5d+l72ADnduv378uPet5P8vgGMBB3TVBKSDU4Rr9HKZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Os14+oRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Os14+oRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823FAC433F1;
	Tue,  6 Feb 2024 00:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178266;
	bh=c5L+s+vHfqjDUR77JfCNA1Z4xsihxYS5A42MuEiL3uo=;
	h=Date:To:From:Subject:From;
	b=Os14+oRtKVYUMpDplOkjCt9zWqsUs3IJ4HEgKOfo8CpKDhfI8qyEdrsQc8cgRfbkm
	 Oft2zFO2etnHtRUqoUo6VJiDab3DyWhdvvYm2Lrl4TMM4Lpw/JEB+VkZkSonevUKzC
	 LhLGVhOvvtR4FoNeiWQtLozUE4jme3UACtXXTPAE=
Date: Mon, 05 Feb 2024 16:11:05 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch added to mm-unstable branch
Message-Id: <20240206001106.823FAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: power/fadump: make FA_DUMP select CRASH_DUMP
has been added to the -mm mm-unstable branch.  Its filename is
     crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: power/fadump: make FA_DUMP select CRASH_DUMP
Date: Sun, 4 Feb 2024 11:06:54 +0800

FA_DUMP which is similar with kdump needs vmcoreinfo exporting,
crashkernel reservation and /proc/vmcore file . After refactoring crash
related codes and Kconfig items, make FA_DUMP select CRASH_DUMP. Now
the dependency layout is like below:

                           ---->VMCORE_INFO
                         /|
FA_DUMP--> CRASH_DUMP-->/-|---->CRASH_RESERVE
                        \ |
                          \---->PROC_VMCORE

Link: https://lkml.kernel.org/r/Zb8D1ASrgX0qVm9z@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/Kconfig~crash-remove-dependency-of-fa_dump-on-crash_dump-fix
+++ a/arch/powerpc/Kconfig
@@ -690,8 +690,7 @@ config ARCH_SELECTS_CRASH_DUMP
 config FA_DUMP
 	bool "Firmware-assisted dump"
 	depends on PPC64 && (PPC_RTAS || PPC_POWERNV)
-	select VMCORE_INFO
-	select CRASH_RESERVE
+	select CRASH_DUMP
 	help
 	  A robust mechanism to get reliable kernel crash dump with
 	  assistance from firmware. This approach does not use kexec,
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch
panic-suppress-gnu_printf-warning.patch

