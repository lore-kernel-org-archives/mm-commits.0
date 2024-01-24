Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BC8C08
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091398; cv=none; b=Pckom8DXIJM6RoOUKiQ4GIlvRXr/OA+6PTEoutamnuOPjBpW+cbqaJIPGOZpR98PU9C9VGwdmXT7YOqFBxdKzamlXbR7CkAxNYqM8mBOAi6rnLDt9u6tayhLMFlR7uGxiLTHk4rp1FlkgP8OWDqzXbECtM/b+52q8lfSz/FaZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091398; c=relaxed/simple;
	bh=moBHFuWO5sVeAhhrJX/O1WLsOlhUgSJDCVO0kJBiDd8=;
	h=Date:To:From:Subject:Message-Id; b=eIOQM5RAH0j9GT7SBKq8bs+KE2hP2INEENbxfi93om6Idp//4cceltNXD33WFyQ3vxqNSsWHBfH+CT1s2qLPyhjIs/zM3jIDfLP0+eISAoAy9YaznLtIv8HZfSf6AvjuHs8XHsro89SMeoB/tCuo6y1wBKxVqrRmy1QJsTYsyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rwexRjlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rwexRjlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9582CC433F1;
	Wed, 24 Jan 2024 10:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091398;
	bh=moBHFuWO5sVeAhhrJX/O1WLsOlhUgSJDCVO0kJBiDd8=;
	h=Date:To:From:Subject:From;
	b=rwexRjlq9pU4wy61xbte6B0J05SphJ1e/STfoAlrbI2xQUfSpejYu1/YgPJt5Oiqe
	 f1v9r8f4BR0Zealpr9iCURDdiTZPSRocm/t/k1Xe2k58kwXTeFnPkxu9h0V7TG14kA
	 AHvXARdfLnwiwQa/GsYz3qRflq9jWYmtMrVYWyzw=
Date: Wed, 24 Jan 2024 02:16:35 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240124101637.9582CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: sh, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:50 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on SuperH with some adjustments.

Wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery, and use
IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling in the
crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-11-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/machine_kexec.c |    3 +++
 arch/sh/kernel/setup.c         |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sh/kernel/machine_kexec.c~sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/sh/kernel/machine_kexec.c
@@ -153,6 +153,9 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base, NULL, NULL);
 	if (ret == 0 && crash_size > 0) {
--- a/arch/sh/kernel/setup.c~sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/sh/kernel/setup.c
@@ -220,7 +220,7 @@ void __init __add_active_range(unsigned
 	request_resource(res, &code_resource);
 	request_resource(res, &data_resource);
 	request_resource(res, &bss_resource);
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_RESERVE
 	request_resource(res, &crashk_res);
 #endif
 
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

