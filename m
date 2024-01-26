Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018FE524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235384; cv=none; b=hI6Qj1ix/LJ1RjDzzAuW5ejH/Bpr8ii3D9zvsRWlhta+H/uuaota1fgQifpaWRHRkaS0NJwRl556Nk1ftxg7wRomsawuUhKasGBH8wxJ4wPqQocXVZ49BsV8rk13/BjS9s9qJ2gbi8QcR9qbTjxZzTq3dzEZpbN0sSYECNpMt6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235384; c=relaxed/simple;
	bh=fdyctwjj5pkmqjMzHVm3Wi346zJEGFBwdfs54/AuN4k=;
	h=Date:To:From:Subject:Message-Id; b=PfZMflXwjEE487nIim4zpN57JT/F7p7Kk678gJsRN9c7jgs85OZcGakVVhK+oJjwEbWFCRIPcyQpdT1PIH10k+zSlwGv50Ai4FRFMhOVovzpz33qZJquuMAHRQmMFMjV0kWiO2C7EoWCPiaSVem2hQ4W1LI7naoBX4wRLtCS51s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXQNx/jM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXQNx/jM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E0C433F1;
	Fri, 26 Jan 2024 02:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235383;
	bh=fdyctwjj5pkmqjMzHVm3Wi346zJEGFBwdfs54/AuN4k=;
	h=Date:To:From:Subject:From;
	b=iXQNx/jMgHiByBIWw2LxtTAOW94v5Gc9wfgR0azl4bxHdjtPv3148ns0OQdVLYS6r
	 JrM/MVLtTSkgOqJcPynYgFDdSdU6i0V19LHNQgrbxM+5YEQ894IJdpANw9tZsITZ43
	 5Pg9v918XemdDIgHvAsjI2YQVKXuR6zPCyz9ATmk=
Date: Thu, 25 Jan 2024 18:16:20 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch added to mm-unstable branch
Message-Id: <20240126021623.177E0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
has been added to the -mm mm-unstable branch.  Its filename is
     ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch

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
Subject: ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
Date: Thu, 25 Jan 2024 22:29:07 +0800

I reproduced the failure with allnoconfig on ppc, and found below change
can fix it too. And the change makes ARCH_SELECTS_KEXEC consistent with
ARCH_SELECTS_KEXEC_FILE on the dependency. What do you think?

Link: https://lkml.kernel.org/r/ZbJwMyCpz4HDySoo@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig~ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
+++ a/arch/powerpc/Kconfig
@@ -610,6 +610,7 @@ config ARCH_SUPPORTS_KEXEC
 
 config ARCH_SELECTS_KEXEC
 	def_bool y
+	depends on KEXEC
 	select CRASH_DUMP
 
 config ARCH_SUPPORTS_KEXEC_FILE
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
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

