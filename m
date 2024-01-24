Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395B8C08
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091373; cv=none; b=bVYeVlN3MV7tSxIp3QQ4vVOa/JM9V2CxxTiRtIYNzbZ4TYxxpf5lEZI/TVVz6Va70rQ75mLVlFTEGTkkBGjIYwnkrfvTllhVuw2V+xJYbHsvd+COdhmtuvfeN9fNzJK2y6r3HxNrQLsdSr+bNhjLYKOflqAJ01LssflAxFAMLWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091373; c=relaxed/simple;
	bh=SjaZiQKSGlco1jNZF7fUBNbHpiDAf39Jb5uswVbFYiY=;
	h=Date:To:From:Subject:Message-Id; b=tdFezZHGn+u38IbdQi+TrtEx2NUeVnZr5pwV1dTuX9a9hIgAzzkgwbCLMp/KSIyjNCtYSKmuth8WlgmB2MkwOAsNharstiINf6JjGNtH4fKfGaF9Ke5lzfrD7ryg4iNf6O5rJWP7LnzQpZO8yBn1eVLXsCtC5aE9xU6PXR6BYJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAPhAUfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAPhAUfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E176C43390;
	Wed, 24 Jan 2024 10:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091372;
	bh=SjaZiQKSGlco1jNZF7fUBNbHpiDAf39Jb5uswVbFYiY=;
	h=Date:To:From:Subject:From;
	b=OAPhAUfMDOG6JrxrDdwLPglmadURnINsvCnA3ITeNsgG3LLtjiyeHI3zYSOUw2YLj
	 NrGcePqRZhodOFmx9Hh8A+qE64KaO0ptHtaL3bHkAHO4bwAbHxMoJwkMe9PTtovdrf
	 b+o3I7ImDWxEorbSdSCUL4SA7fQBy6JIifvPBpZ0=
Date: Wed, 24 Jan 2024 02:16:09 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-remove-dependency-of-fa_dump-on-crash_dump.patch added to mm-unstable branch
Message-Id: <20240124101612.2E176C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
has been added to the -mm mm-unstable branch.  Its filename is
     crash-remove-dependency-of-fa_dump-on-crash_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-remove-dependency-of-fa_dump-on-crash_dump.patch

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
Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
Date: Wed, 24 Jan 2024 13:12:43 +0800

In kdump kernel, /proc/vmcore is an elf file mapping the crashed kernel's
old memory content. Its elf header is constructed in 1st kernel and passed
to kdump kernel via elfcorehdr_addr. Config CRASH_DUMP enables the code
of 1st kernel's old memory accessing in different architectures.

Currently, config FA_DUMP has dependency on CRASH_DUMP because fadump
needs access global variable 'elfcorehdr_addr' to judge if it's in
kdump kernel within function is_kdump_kernel(). In the current
kernel/crash_dump.c, variable 'elfcorehdr_addr' is defined, and function
setup_elfcorehdr() used to parse kernel parameter to fetch the passed
value of elfcorehdr_addr. Only for accessing elfcorehdr_addr, FA_DUMP
really doesn't have to depends on CRASH_DUMP.

To remove the dependency of FA_DUMP on CRASH_DUMP to avoid confusion,
rename kernel/crash_dump.c to kernel/elfcorehdr.c, and build it when
CONFIG_VMCORE_INFO is ebabled. With this, FA_DUMP doesn't need to depend
on CRASH_DUMP.

Link: https://lkml.kernel.org/r/20240124051254.67105-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig    |    1 -
 kernel/Makefile         |    3 +--
 kernel/kexec_internal.h |    2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/Kconfig~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/arch/powerpc/Kconfig
@@ -692,7 +692,6 @@ config FA_DUMP
 	depends on PPC64 && (PPC_RTAS || PPC_POWERNV)
 	select VMCORE_INFO
 	select CRASH_RESERVE
-	select CRASH_DUMP
 	help
 	  A robust mechanism to get reliable kernel crash dump with
 	  assistance from firmware. This approach does not use kexec,
--- a/kernel/kexec_internal.h~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/kernel/kexec_internal.h
@@ -4,6 +4,8 @@
 
 #include <linux/kexec.h>
 
+struct kexec_segment;
+
 struct kimage *do_kimage_alloc_init(void);
 int sanity_check_segment_list(struct kimage *image);
 void kimage_free_page_list(struct list_head *list);
--- a/kernel/Makefile~crash-remove-dependency-of-fa_dump-on-crash_dump
+++ a/kernel/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_MODULE_SIG_FORMAT) += modul
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_KALLSYMS_SELFTEST) += kallsyms_selftest.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
-obj-$(CONFIG_VMCORE_INFO) += vmcore_info.o
+obj-$(CONFIG_VMCORE_INFO) += vmcore_info.o elfcorehdr.o
 obj-$(CONFIG_CRASH_RESERVE) += crash_reserve.o
 obj-$(CONFIG_KEXEC_CORE) += kexec_core.o crash_core.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -121,7 +121,6 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
-obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
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
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

