Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDCE5732A
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970662; cv=none; b=s+ivDdqjAKYeHppKfnJXR521grmtotOlN9oMHun5YNJIKE29P7OZiyRFpwbEv9QTFA9IT5NE0zHtYbvOOAmDsL21p8GZO45NYiBYMHUvtGffGCiqP/RfrL295VOKgrOHypHW0CaeV9BwlTQVZBwhNFexNA272zlKOjRk1ul+81g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970662; c=relaxed/simple;
	bh=PZeU2W7ODOrb62O0nrrQDicwh6fLQBs/HQIcfxVfDRE=;
	h=Date:To:From:Subject:Message-Id; b=hz/m0rXsiP2NRdc6zA7wk7r7zQ0JKHo5uNbZJL5Hge+MAUAPiXgDIRxZ/8YfXFBy++L3lGVJWYTMm8mV68yA5jGXMcbyVw6rKrBATTGfdY+iAq7c6xb82UKqDzZnJa38w5B0B9Evs3KAIrJydjQ6N9iRUt8t9UkdKUOAN9MxfAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iIs2V3+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iIs2V3+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90DEC43399;
	Tue, 23 Jan 2024 00:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970662;
	bh=PZeU2W7ODOrb62O0nrrQDicwh6fLQBs/HQIcfxVfDRE=;
	h=Date:To:From:Subject:From;
	b=iIs2V3+iLzAJWo4ieQ5yDdSj9TT34wBuS/NJkN4wQvazwhRW7IlvTYteHZLy4iYz8
	 9TQiLCLPqnm+MCFloxOT4bFeRlKI6PdUpigSR5sX3kg9eBU6DlIWzIe+0kOd7DVetR
	 bFPifPsjGsILaeEn3KtPkZRbSIoC5Em2tTBiXexo=
Date: Mon, 22 Jan 2024 16:44:18 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004421.B90DEC43399@smtp.kernel.org>
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
Date: Fri, 19 Jan 2024 22:52:37 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on SuperH with some adjustments.

Here wrap up crashkernel reservation code inside CONFIG_CRASH_RESERVE
ifdeffery scope.

Link: https://lkml.kernel.org/r/20240119145241.769622-11-bhe@redhat.com
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
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

