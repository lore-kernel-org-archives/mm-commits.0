Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9033F8C08
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091404; cv=none; b=iEkWA8lidN8sNB77krUo7Sgi/eD5ijeXr4P52IWkmrUfhMllJO80nvxaFtJetOrzS0c9WzVQ1/x6moHKlp1o3E+N6oHGJ7D1zvFak4M2NdzENB9xg9WaDxKuhsNfnVdQZOuYRKIZDiToZi8iZJLphcVeBkqqqKe9oKOnJDWaRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091404; c=relaxed/simple;
	bh=i7RIZgzxNjaF+bRZ9r38d42y2m6IdFsOmz7zf5Dx/I0=;
	h=Date:To:From:Subject:Message-Id; b=Xoirn8bYVYZdmHhi6jW/FuzFFemH0fJV3DrPK7DNf1zrMp8FG37YnkscPTAk5AcYka5aE6XXdNWWbjMF7dRLK2mWNnIimBxF2kN30Ug2/82hLBRnr8RhZ0/aJGuKbUW2EBEbj0vgXJ0J9Db7GmyV661E3JQtqjGqpH3Xj/0MmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BkUkIlNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BkUkIlNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB185C43390;
	Wed, 24 Jan 2024 10:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091404;
	bh=i7RIZgzxNjaF+bRZ9r38d42y2m6IdFsOmz7zf5Dx/I0=;
	h=Date:To:From:Subject:From;
	b=BkUkIlNBo1i/gt6eXOS0C/lM/3MUFPDBPX9HkA3pXY0uNP9tSe5a6v0O0bi7xo9TI
	 uR+6GUj2SLZ9QG30Nu1bBrgLXhQ+I53+b3SRdKGkhMRAdV7PaCAXOVWrYNuZaHPmDo
	 7mMKroIBtVqjFNARyzzbdTDNo11NKEnIoLJgt5to=
Date: Wed, 24 Jan 2024 02:16:41 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240124101643.DB185C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: mips, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:51 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on mips with some adjustments.

Here use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-12-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/setup.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/mips/kernel/setup.c~mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/mips/kernel/setup.c
@@ -442,8 +442,6 @@ static void __init mips_reserve_vmcore(v
 #endif
 }
 
-#ifdef CONFIG_KEXEC
-
 /* 64M alignment for crash kernel regions */
 #define CRASH_ALIGN	SZ_64M
 #define CRASH_ADDR_MAX	SZ_512M
@@ -454,6 +452,9 @@ static void __init mips_parse_crashkerne
 	unsigned long long crash_size, crash_base;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	total_mem = memblock_phys_mem_size();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base,
@@ -489,6 +490,9 @@ static void __init request_crashkernel(s
 {
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	if (crashk_res.start == crashk_res.end)
 		return;
 
@@ -498,15 +502,6 @@ static void __init request_crashkernel(s
 			(unsigned long)(resource_size(&crashk_res) >> 20),
 			(unsigned long)(crashk_res.start  >> 20));
 }
-#else /* !defined(CONFIG_KEXEC)		*/
-static void __init mips_parse_crashkernel(void)
-{
-}
-
-static void __init request_crashkernel(struct resource *res)
-{
-}
-#endif /* !defined(CONFIG_KEXEC)  */
 
 static void __init check_kernel_sections_mem(void)
 {
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

