Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196D8F68
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739404; cv=none; b=tJNF0PMk8yfyYUBGm9VWPtE5OjpLEks3xobrVK1PTevuEK4fvRvv01T4tmQJPr7mCnyXJPs0hFwqOwq+XbhVD2rMDC1Ui1BpTfcYkcGzbXo3+nlawNfb6MUZ1uRlTSCYEL6nSmzpANOqFS5Gk+j4HX8IRLHLhdItUrbdqf8KqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739404; c=relaxed/simple;
	bh=lsx3Sg6SX/arXwAGmAmvWUgiyvPzMHiSLD4VRluAtkY=;
	h=Date:To:From:Subject:Message-Id; b=BQmvBrksws6eU4ZW3qpArzi4CQToqjQMSBwKYuIH1XKSgB0xMYg/bR7Zpy3WLZUihBl5Y6vsVRVXiUWSULayWRLV9MctXO5nrf5rD6oi/CgNk4A/Z4Li3qkXufmxfJjBu1a0HXdTvsXUYVST3XCGp8M9Qv12pdgolp+wYPkrjF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPk6jVUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPk6jVUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C31C433F1;
	Sat, 24 Feb 2024 01:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739404;
	bh=lsx3Sg6SX/arXwAGmAmvWUgiyvPzMHiSLD4VRluAtkY=;
	h=Date:To:From:Subject:From;
	b=xPk6jVUr5IyVGCVy1dfd+G0McNE/Mid34v6OH/A1LB3CbT1ks2aPdMq0KFkK0PS0R
	 UXSZf22j/2QU9GC9fs+ToqM1HgVD2IILhhf0U8MuyTvgytAWKaZC1zpFefeLhjffrp
	 XOTRHFHIAFtiuOr+37H6Z2ZRD55hBj+4EK+S4ybE=
Date: Fri, 23 Feb 2024 17:50:03 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015004.34C31C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: riscv, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:52 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on risc-v with some adjustments.

Here wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery, and
use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-13-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
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
@@ -1355,7 +1355,7 @@ static void __init arch_reserve_crashker
 	bool high = false;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
_

Patches currently in -mm which might be from bhe@redhat.com are


