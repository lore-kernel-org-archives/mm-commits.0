Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7824418643
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091392; cv=none; b=pPZCmQLMs0Cieqh20jWtE3Tuy/6t5Zwd041UXAXCwh/lfIpWHB+hsvDNqaqPoiY/XHLLe/FIsjbnhuxgDi6sAXT48Vgd9N4eEGddKi8CWejdq0nyHC/9msFX4SKIZdJA4hRaPLDEhPoMv1YvX9FLf13mCY6trrhSI8giYCUp2Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091392; c=relaxed/simple;
	bh=SnLcP/BV9CuCOXJE5NQoxFhYSMv+7WBl5IFtHy0RjHM=;
	h=Date:To:From:Subject:Message-Id; b=tUpqRudcQWN7V6xYqAOjHgNwa7tcKQEVGoj1uHgYsEmQR9woPJ/VcKVsOiQYT4Ht0hn18KiW+Wr7lD9EpKcRjfVM6TA5WRPtTU25rcYDa7OdQRXy6L7ijDvpAaVgjt+ImEqXi/KK24iiQj+iNrk+8UzIECY3j8Pp6nn7EfBAE8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=scgjaSy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="scgjaSy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58756C433F1;
	Wed, 24 Jan 2024 10:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091392;
	bh=SnLcP/BV9CuCOXJE5NQoxFhYSMv+7WBl5IFtHy0RjHM=;
	h=Date:To:From:Subject:From;
	b=scgjaSy3iweBIqUqAfuxcqVtNzqXKGkm8XsjpTGKORh0JZYKNeznY35uOe0nSA4zs
	 SKjDSYtFAgKSL5UGNGJZ25dxyQZJcboWB3hSAr55DoarRlGlhniN56m58qKMN3/8Pg
	 LyDHajsYRZhLBkEqB8qY2riycOpj90gLzdxriOaY=
Date: Wed, 24 Jan 2024 02:16:29 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240124101631.58756C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: s390, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:49 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on s390 with some adjustments.

Here wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery.

Link: https://lkml.kernel.org/r/20240124051254.67105-10-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/kexec_elf.c          |    2 ++
 arch/s390/kernel/kexec_image.c        |    2 ++
 arch/s390/kernel/machine_kexec_file.c |   10 ++++++++++
 3 files changed, 14 insertions(+)

--- a/arch/s390/kernel/kexec_elf.c~s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/s390/kernel/kexec_elf.c
@@ -40,8 +40,10 @@ static int kexec_file_add_kernel_elf(str
 		buf.bufsz = phdr->p_filesz;
 
 		buf.mem = ALIGN(phdr->p_paddr, phdr->p_align);
+#ifdef CONFIG_CRASH_DUMP
 		if (image->type == KEXEC_TYPE_CRASH)
 			buf.mem += crashk_res.start;
+#endif
 		buf.memsz = phdr->p_memsz;
 		data->memsz = ALIGN(data->memsz, phdr->p_align) + buf.memsz;
 
--- a/arch/s390/kernel/kexec_image.c~s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/s390/kernel/kexec_image.c
@@ -24,8 +24,10 @@ static int kexec_file_add_kernel_image(s
 	buf.bufsz = image->kernel_buf_len;
 
 	buf.mem = 0;
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH)
 		buf.mem += crashk_res.start;
+#endif
 	buf.memsz = buf.bufsz;
 
 	data->kernel_buf = image->kernel_buf;
--- a/arch/s390/kernel/machine_kexec_file.c~s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/s390/kernel/machine_kexec_file.c
@@ -105,6 +105,7 @@ static int kexec_file_update_purgatory(s
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH) {
 		u64 crash_size;
 
@@ -121,6 +122,7 @@ static int kexec_file_update_purgatory(s
 						     sizeof(crash_size),
 						     false);
 	}
+#endif
 	return ret;
 }
 
@@ -134,8 +136,10 @@ static int kexec_file_add_purgatory(stru
 
 	data->memsz = ALIGN(data->memsz, PAGE_SIZE);
 	buf.mem = data->memsz;
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH)
 		buf.mem += crashk_res.start;
+#endif
 
 	ret = kexec_load_purgatory(image, &buf);
 	if (ret)
@@ -158,8 +162,10 @@ static int kexec_file_add_initrd(struct
 
 	data->memsz = ALIGN(data->memsz, PAGE_SIZE);
 	buf.mem = data->memsz;
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH)
 		buf.mem += crashk_res.start;
+#endif
 	buf.memsz = buf.bufsz;
 
 	data->parm->initrd_start = data->memsz;
@@ -223,8 +229,10 @@ static int kexec_file_add_ipl_report(str
 		data->kernel_buf + offsetof(struct lowcore, ipl_parmblock_ptr);
 	*lc_ipl_parmblock_ptr = (__u32)buf.mem;
 
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH)
 		buf.mem += crashk_res.start;
+#endif
 
 	ret = kexec_add_buffer(&buf);
 out:
@@ -268,10 +276,12 @@ void *kexec_file_add_components(struct k
 	memcpy(data.parm->command_line, image->cmdline_buf,
 	       image->cmdline_buf_len);
 
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH) {
 		data.parm->oldmem_base = crashk_res.start;
 		data.parm->oldmem_size = crashk_res.end - crashk_res.start + 1;
 	}
+#endif
 
 	if (image->initrd_buf) {
 		ret = kexec_file_add_initrd(image, &data);
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

