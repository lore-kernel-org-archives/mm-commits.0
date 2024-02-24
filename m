Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5954A3C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739396; cv=none; b=VCDQbt6XRI6W/h7xMXmP0AWyJNyjnPS98BAvkNUU+WlVU1sMdejDmBTpVtvwCOCRxht5hqNLQf/H6eCe2xN3XRtpwMoI1Sfvv6/Gf690sxV3+mO8TIH7E9oruKOu4PCCr1AW9x6Bjgds8s/JOqQPd9kxsTOP7VCPu9K/jvL9ArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739396; c=relaxed/simple;
	bh=SNmAb8adC7iWOUSb5VnlJbuOCssnV9RmLv7l1/OCilE=;
	h=Date:To:From:Subject:Message-Id; b=DI1ONjxM35W1WMPgWlsk3ezNc0YNxXzA5umkIDViRWk+6BXWrMKxv4V4zuFkuQakp19ukK4XtG15kfYoYUv9+uyNncVYqFRcG+Oo79tHEBiIbTZaeTkVI0tFNq0Kd2zWRZFjbCyEFW/2CAfMKPw1g4ahsC3mRi6IxkDDExRdITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JGehHXLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JGehHXLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C78C433C7;
	Sat, 24 Feb 2024 01:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739396;
	bh=SNmAb8adC7iWOUSb5VnlJbuOCssnV9RmLv7l1/OCilE=;
	h=Date:To:From:Subject:From;
	b=JGehHXLH217c0RnC4/Cj1kW9RApc8sHdPxMfbayE3m0vbZss+i4t1VsiUAo8NenNf
	 zDFiGc8mPrnYU3xsTNZjJwN3+qP+GyTDbWSh5ont/2T1EvDSL45QH3k2OPIds7dhdE
	 /HHk3edrXw8J4W5qS9x/VlK0/Fxs4DHiwcAYqKLg=
Date: Fri, 23 Feb 2024 17:49:55 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224014956.20C78C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arm64, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:47 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on arm64 with some adjustments.

Here wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery.

[bhe@redhat.com: fix building error in generic codes]
  Link: https://lkml.kernel.org/r/20240129135033.157195-2-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240124051254.67105-8-bhe@redhat.com
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

 arch/arm64/include/asm/kexec.h         |    2 +-
 arch/arm64/kernel/machine_kexec.c      |    2 +-
 arch/arm64/kernel/machine_kexec_file.c |   10 ++++++++--
 arch/arm64/mm/init.c                   |    2 +-
 drivers/of/kexec.c                     |    2 ++
 kernel/kexec_file.c                    |    2 ++
 6 files changed, 15 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/kexec.h~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm64/include/asm/kexec.h
@@ -80,7 +80,7 @@ static inline void crash_setup_regs(stru
 	}
 }
 
-#if defined(CONFIG_KEXEC_CORE) && defined(CONFIG_HIBERNATION)
+#if defined(CONFIG_CRASH_DUMP) && defined(CONFIG_HIBERNATION)
 extern bool crash_is_nosave(unsigned long pfn);
 extern void crash_prepare_suspend(void);
 extern void crash_post_resume(void);
--- a/arch/arm64/kernel/machine_kexec.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -255,7 +255,7 @@ void machine_crash_shutdown(struct pt_re
 	pr_info("Starting crashdump kernel...\n");
 }
 
-#ifdef CONFIG_HIBERNATION
+#if defined(CONFIG_CRASH_DUMP) && defined(CONFIG_HIBERNATION)
 /*
  * To preserve the crash dump kernel image, the relevant memory segments
  * should be mapped again around the hibernation.
--- a/arch/arm64/kernel/machine_kexec_file.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -39,6 +39,7 @@ int arch_kimage_file_post_load_cleanup(s
 	return kexec_image_post_load_cleanup_default(image);
 }
 
+#ifdef CONFIG_CRASH_DUMP
 static int prepare_elf_headers(void **addr, unsigned long *sz)
 {
 	struct crash_mem *cmem;
@@ -80,6 +81,7 @@ out:
 	kfree(cmem);
 	return ret;
 }
+#endif
 
 /*
  * Tries to add the initrd and DTB to the image. If it is not possible to find
@@ -93,8 +95,8 @@ int load_other_segments(struct kimage *i
 			char *cmdline)
 {
 	struct kexec_buf kbuf;
-	void *headers, *dtb = NULL;
-	unsigned long headers_sz, initrd_load_addr = 0, dtb_len,
+	void *dtb = NULL;
+	unsigned long initrd_load_addr = 0, dtb_len,
 		      orig_segments = image->nr_segments;
 	int ret = 0;
 
@@ -102,7 +104,10 @@ int load_other_segments(struct kimage *i
 	/* not allocate anything below the kernel */
 	kbuf.buf_min = kernel_load_addr + kernel_size;
 
+#ifdef CONFIG_CRASH_DUMP
 	/* load elf core header */
+	void *headers;
+	unsigned long headers_sz;
 	if (image->type == KEXEC_TYPE_CRASH) {
 		ret = prepare_elf_headers(&headers, &headers_sz);
 		if (ret) {
@@ -130,6 +135,7 @@ int load_other_segments(struct kimage *i
 		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
 	}
+#endif
 
 	/* load initrd */
 	if (initrd) {
--- a/arch/arm64/mm/init.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm64/mm/init.c
@@ -100,7 +100,7 @@ static void __init arch_reserve_crashker
 	bool high = false;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
--- a/drivers/of/kexec.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/drivers/of/kexec.c
@@ -395,6 +395,7 @@ void *of_kexec_alloc_and_setup_fdt(const
 		if (ret)
 			goto out;
 
+#ifdef CONFIG_CRASH_DUMP
 		/* add linux,usable-memory-range */
 		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
 				"linux,usable-memory-range", crashk_res.start,
@@ -410,6 +411,7 @@ void *of_kexec_alloc_and_setup_fdt(const
 			if (ret)
 				goto out;
 		}
+#endif
 	}
 
 	/* add bootargs */
--- a/kernel/kexec_file.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/kernel/kexec_file.c
@@ -540,8 +540,10 @@ static int kexec_walk_memblock(struct ke
 	phys_addr_t mstart, mend;
 	struct resource res = { };
 
+#ifdef CONFIG_CRASH_DUMP
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return func(&crashk_res, kbuf);
+#endif
 
 	/*
 	 * Using MEMBLOCK_NONE will properly skip MEMBLOCK_DRIVER_MANAGED. See
_

Patches currently in -mm which might be from bhe@redhat.com are


