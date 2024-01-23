Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D6A5C80
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970669; cv=none; b=YlzrhjCIcFuhyfQVk4BY40lLJkziqcSMVxa7FCbW9AmYyuCo2wygh8UWG0kF7aAmDOhiUMbxgdKtkldanqVAILfy/Ja9X1hqbYZKVsM3oBRaOEs+8fv2CY5rN7Ph40MxpmySUfFtrsWGXCgUPFaGbqkmDQaTJ8dxIJR/jY371P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970669; c=relaxed/simple;
	bh=+fBuDDchFkOruYUDeoj8tX++h92GV0pOD9XgdsiVHmI=;
	h=Date:To:From:Subject:Message-Id; b=mezn3iQgI9gbAGz8xKdtWCjp+0DlAV65yXSdDFQHyI98Dt5ybD1oSmsVAfbnaO0RxqM1YV+2zyMwWNwuS+1wiJ4hWrL19eRLWXRevmyTuOPDmoZzErzyYVwsIokkCKgqIemNCf9BX2tDaXrtRg+z3fv+N2z/+38CXwN2sIU++7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UXga4YAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UXga4YAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208DDC433F1;
	Tue, 23 Jan 2024 00:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970669;
	bh=+fBuDDchFkOruYUDeoj8tX++h92GV0pOD9XgdsiVHmI=;
	h=Date:To:From:Subject:From;
	b=UXga4YAO5oXOpDeMLnzxXaAPO763UpaMVVUSSvVhtGE5N9yDiywk1LzwkNpzcZxe3
	 vOfbZgYmS6N0j6/UqHamioSKa34hrqiea+5A2+/1Uq3hxEu6DWnFT2giDYslKSs3GB
	 kBauEF8KHWfi1vtfg5sePw+WSslXYcrd9FfoRM/I=
Date: Mon, 22 Jan 2024 16:44:26 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004429.208DDC433F1@smtp.kernel.org>
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
Date: Fri, 19 Jan 2024 22:52:39 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on mips with some adjustments.

Here use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240119145241.769622-13-bhe@redhat.com
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
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

