Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABAC5732A
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970655; cv=none; b=Qfmgu6DWe0j3bUL2J+ZIRRS38bhwIm+qKvt4BusbIRxJ5kyxMlulmi4n0MZd5lefAHwv/TZT8Y6BztUR6ewR/62cesPmFtJb3gCT6FiVxapGQi9fZdCAothOV0qbnXFUXs6YGZ0Q8NymMZ63u60uET+5u09+FP7dxBKUAe1IO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970655; c=relaxed/simple;
	bh=LBLuINkyRfv2dt9OYM9+4qeEf4Y0iGz9C4GWdO154sw=;
	h=Date:To:From:Subject:Message-Id; b=FycBhJtd9njhyApzhL3zOqCdMZaRt+G7OkqAu/qK3yfXfnXsZsIVghADUlaxV0n8Lcu0bmovTRA9/HDNQ8zQI4XRt42xhn9D62HC8WuiBqFs+ZvdHvvkbbQFO+6p6aQJDbGUmHslb+zNRjem1lrEmtC3IdbBEZz4JBltNrjadm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1y9zhWJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1y9zhWJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C705C43399;
	Tue, 23 Jan 2024 00:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970654;
	bh=LBLuINkyRfv2dt9OYM9+4qeEf4Y0iGz9C4GWdO154sw=;
	h=Date:To:From:Subject:From;
	b=1y9zhWJRfvj+4QVKvAgmeauf0UUJIIwGpcSUZyAFXmCZ/A4nQNzhYKT62UA4S7/gA
	 uugQmVuGaNmaCq/nNTMyQzTX7nziXqxjgHxGGLd6lh/kbFepAn4AlCP6C7Eb4ExMhI
	 G/l0TsqBNmP5jcVlWqmJ6yp83B5Np2NvbqE5zv8g=
Date: Mon, 22 Jan 2024 16:44:11 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch added to mm-unstable branch
Message-Id: <20240123004414.4C705C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ppc, crash: enforce KEXEC and KEXEC_FILE to select CRASH_DUMP
has been added to the -mm mm-unstable branch.  Its filename is
     ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch

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
Subject: ppc, crash: enforce KEXEC and KEXEC_FILE to select CRASH_DUMP
Date: Fri, 19 Jan 2024 22:52:35 +0800

In PowerPC, the crash dumping and kexec reboot share code in
arch_kexec_locate_mem_hole(), in which struct crash_mem is used.

Here enfoce enforce KEXEC and KEXEC_FILE to select CRASH_DUMP for now.

Link: https://lkml.kernel.org/r/20240119145241.769622-9-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/Kconfig~ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump
+++ a/arch/powerpc/Kconfig
@@ -608,6 +608,10 @@ config PPC64_SUPPORTS_MEMORY_FAILURE
 config ARCH_SUPPORTS_KEXEC
 	def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
 
+config ARCH_SELECTS_KEXEC
+	def_bool y
+	select CRASH_DUMP
+
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool PPC64
 
@@ -618,6 +622,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
 	depends on KEXEC_FILE
 	select KEXEC_ELF
+	select CRASH_DUMP
 	select HAVE_IMA_KEXEC if IMA
 
 config PPC64_BIG_ENDIAN_ELF_ABI_V2
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

