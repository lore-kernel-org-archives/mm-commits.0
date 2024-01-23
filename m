Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A45732A
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970658; cv=none; b=CTTCcF4oF2B18SlG3ox4Sk1VagQamuKcI0gki62+gjoW95J+UXB2AFAg/1713zTB2w4sfAkPy9JCGFItm535KuWEpXD95N8EDyUR3Pesrht9vilqH12+ppv2EwJg90vTcGpjHpDu5T5aOTbf9M5/C+Svq1mvQZ6X1tTIASr1lN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970658; c=relaxed/simple;
	bh=FTyiv81DO9KZ3xBYb46p4g+vlv2XZNRsLl3gyTDVimo=;
	h=Date:To:From:Subject:Message-Id; b=aj/Nuv8s4R/EytPLw/lME8t6gldXAxhCm7ttI3acS2FoQOGRFS7Z7IBgQ3Z+NbuemRbBLpfzy9ASQhT0pMaWAUDXmzpPlwwzXBgAQfI3OpRQjoTxEq0W1g+8t3SBikQDFWXBcgczMswPDF9P5JdcgbfxcUCkd2FIpoc5AHH/bTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h88kllfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h88kllfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE446C43390;
	Tue, 23 Jan 2024 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970658;
	bh=FTyiv81DO9KZ3xBYb46p4g+vlv2XZNRsLl3gyTDVimo=;
	h=Date:To:From:Subject:From;
	b=h88kllfHG2sh43Uh4oPQcGcljD5QucyXDZ6y8KCvzoDnQX3tM2jTSbJm88FdsI41w
	 0UcUoNEcbZhzBFSzOIZyJ5QizizbODe1FBAX65ooY11gauLZzzgOW0ZFXj/9DPzZ53
	 Pm9A93zyWPYTJfI69XAhTO9hSVHoR3uCLhjW1bek=
Date: Mon, 22 Jan 2024 16:44:15 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004417.EE446C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: arm64, crash: wrap crash dumping code into crash related ifdefs
Date: Fri, 19 Jan 2024 22:52:34 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on arm64 with some adjustments.

Here wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery.

Link: https://lkml.kernel.org/r/20240119145241.769622-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kexec.h         |    2 +-
 arch/arm64/kernel/machine_kexec.c      |    2 +-
 arch/arm64/kernel/machine_kexec_file.c |   10 ++++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

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

