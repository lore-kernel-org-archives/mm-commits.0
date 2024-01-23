Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869663CB
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970680; cv=none; b=Y1FWxv0UbceJDZOeMRI9t8AqKgLKZmcTZrce9J1q3WUm5YEBGON0rXJQhNFpPwAyjObM25zgOfPTM9wn0zX74e6RGOwgOgr7J4tqZruXEY20mIh8STc4zLrT+b4ybDsjkN4A4J29SyunYnU5oZ+k3Qa98LVPHZ1mnf6jhpIxnCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970680; c=relaxed/simple;
	bh=GwUDINDsWJC6kt9KSyE/FIZFYR+vuIH4UIHwHT2BS6I=;
	h=Date:To:From:Subject:Message-Id; b=OkAItbQbl6WEVxH4vEQ49py2IvlXcZV8qwBZbKpF0xcQY6axrIzo/5QVL3UIH8MzXcaw9aErho7whaOhnYymVCVTttJuV7MUrY6ZkErazF3OiTUK9eScSRxGwrMom4+r2x7BpB4IoKy9x3pl03qDqjoBBocQmeUSiJ9sf+nIVUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pk+hB4QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pk+hB4QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012C6C433F1;
	Tue, 23 Jan 2024 00:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970680;
	bh=GwUDINDsWJC6kt9KSyE/FIZFYR+vuIH4UIHwHT2BS6I=;
	h=Date:To:From:Subject:From;
	b=pk+hB4QJ6whU25Q6A3iuYAF47f1Eif4C7qw/z/Jibb3Ln46d83ywJCEqzSzHr9y56
	 UDscIKjzH7riKxib/qQhk1jUrjwA5lTpLw1+jJpzQgFdo5wHmf8CYae7CuLXduow3N
	 AqW49+50xPSZrezUvCBoXjsHiyAxHzK5VSBx41p8=
Date: Mon, 22 Jan 2024 16:44:37 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004440.012C6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: riscv, crash: wrap crash dumping code into crash related ifdefs
Date: Fri, 19 Jan 2024 22:52:40 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on risc-v with some adjustments.

Here wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery, and
use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240119145241.769622-14-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/elf_kexec.c |    9 +++++++--
 arch/riscv/mm/init.c          |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/elf_kexec.c~riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/riscv/kernel/elf_kexec.c
@@ -117,6 +117,7 @@ static int elf_find_pbase(struct kimage
 	return ret;
 }
 
+#ifdef CONFIG_CRASH_DUMP
 static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 {
 	unsigned int *nr_ranges = arg;
@@ -189,6 +190,7 @@ static char *setup_kdump_cmdline(struct
 	cmdline_ptr[COMMAND_LINE_SIZE - 1] = '\0';
 	return cmdline_ptr;
 }
+#endif
 
 static void *elf_kexec_load(struct kimage *image, char *kernel_buf,
 			    unsigned long kernel_len, char *initrd,
@@ -196,12 +198,11 @@ static void *elf_kexec_load(struct kimag
 			    unsigned long cmdline_len)
 {
 	int ret;
+	void *fdt;
 	unsigned long old_kernel_pbase = ULONG_MAX;
 	unsigned long new_kernel_pbase = 0UL;
 	unsigned long initrd_pbase = 0UL;
-	unsigned long headers_sz;
 	unsigned long kernel_start;
-	void *fdt, *headers;
 	struct elfhdr ehdr;
 	struct kexec_buf kbuf;
 	struct kexec_elf_info elf_info;
@@ -227,8 +228,11 @@ static void *elf_kexec_load(struct kimag
 	kbuf.buf_min = new_kernel_pbase + kernel_len;
 	kbuf.buf_max = ULONG_MAX;
 
+#ifdef CONFIG_CRASH_DUMP
 	/* Add elfcorehdr */
 	if (image->type == KEXEC_TYPE_CRASH) {
+		void *headers;
+		unsigned long headers_sz;
 		ret = prepare_elf_headers(&headers, &headers_sz);
 		if (ret) {
 			pr_err("Preparing elf core header failed\n");
@@ -264,6 +268,7 @@ static void *elf_kexec_load(struct kimag
 		}
 		cmdline = modified_cmdline;
 	}
+#endif
 
 #ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
 	/* Add purgatory to the image */
--- a/arch/riscv/mm/init.c~riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/riscv/mm/init.c
@@ -1354,7 +1354,7 @@ static void __init arch_reserve_crashker
 	bool high = false;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
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

