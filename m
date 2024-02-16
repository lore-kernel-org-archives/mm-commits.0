Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F67DDA3
	for <mm-commits@vger.kernel.org>; Fri, 16 Feb 2024 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708047334; cv=none; b=nkNVM2qgBHIYPJH+gwAJI1Uz5aXrFjBzq2CNPoCCPvkIWEYCRPCgLoyGinuLuQTWNVeCPeRR/0v5BEvaM4b3JQ62OJ5ue9a+kczWEtQXj4wc94jVApu2D6c47hKk4OybAjqB2WkGYEfBOu1rhsUrP90f/yE7rb7lznPq6gAX47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708047334; c=relaxed/simple;
	bh=OjJhaCYo/Cu7tRT3A9la21TKTRo2/7K0jVC9bVYZAMs=;
	h=Date:To:From:Subject:Message-Id; b=MrWVbknl12lbbWkTL0JmIC1fvWjQlbB1PSnEQxfYPfxipF6DeNvaB52suWLQvPk90OztWc/Rv58Nwt6TriIS2ANhjQLQ+ScmNA7DXtJawxJ/pkrqn6GjvbtcUCdrVnAMQY6AeD9OmjnfdT4hzZ72XsY089Ui/ZOWNfPBAQd2RkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iY2H5gPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iY2H5gPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4354C433F1;
	Fri, 16 Feb 2024 01:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708047333;
	bh=OjJhaCYo/Cu7tRT3A9la21TKTRo2/7K0jVC9bVYZAMs=;
	h=Date:To:From:Subject:From;
	b=iY2H5gPDUFiJtXrrBLJmXZqOqdnBVRlrzhWrf1OtOerQfZnT4B/1S9npCJp4AvJup
	 SIMjNtu6FVelzT0tXqV3s+UL2R5uO7b9e/HVGDo+CyWWD2zgMNcEczGUP1FvEvtzvk
	 FNQo939INPT4yc+wAAXK3e6YWpCrnIif8AYirVuE=
Date: Thu, 15 Feb 2024 17:35:33 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch added to mm-unstable branch
Message-Id: <20240216013533.D4354C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch

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
Subject: arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
Date: Thu Feb 15 05:33:42 PM PST 2024

remove stray newlines at eof

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
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

 arch/powerpc/kexec/vmcore_info.c |    2 --
 arch/s390/kernel/vmcore_info.c   |    2 --
 arch/sh/kernel/vmcore_info.c     |    2 --
 3 files changed, 6 deletions(-)

--- a/arch/powerpc/kexec/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/powerpc/kexec/vmcore_info.c
@@ -30,5 +30,3 @@ void arch_crash_save_vmcoreinfo(void)
 	vmcoreinfo_append_str("NUMBER(RADIX_MMU)=%d\n", early_radix_enabled());
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
 }
-
-
--- a/arch/s390/kernel/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/s390/kernel/vmcore_info.c
@@ -19,5 +19,3 @@ void arch_crash_save_vmcoreinfo(void)
 	abs_lc->vmcore_info = paddr_vmcoreinfo_note();
 	put_abs_lowcore(abs_lc);
 }
-
-
--- a/arch/sh/kernel/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/sh/kernel/vmcore_info.c
@@ -13,5 +13,3 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_CONFIG(X2TLB);
 #endif
 }
-
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

