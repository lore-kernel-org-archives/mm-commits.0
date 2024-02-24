Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916138F68
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739400; cv=none; b=FTITOTO5dbQ5NT73whTfTEeN8OkeVNXYSf7xRdRCNevsXSli34k7kZctbcQg4HSa9eKMpSJaHmX9meCnGhPSSErKHE+Q/s1PMPhmo5RkZcCEKudd7nNMXbP0de0rsgc3Y6HsfUDWmJ38jkTP6LBiICIsk1oLAbqtF1I3d8u4KdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739400; c=relaxed/simple;
	bh=IGMKze5kWSunePoZKiZBPBjFy85CZqSJB/r9/qANfnU=;
	h=Date:To:From:Subject:Message-Id; b=VqJzfZJyZ80PVuy6DboyGXP/Ob9YrclIbPFyWcT7kPoWqmrUSk4ZmCYUdfDqmZ+joaulchokQHJZDEOfxW4oHF4TkGKIQNWtoaCaAr5ftlRoiyPyeeqyIcg9DVMZ9o7HIRz9K89f0Fopl/9H4qqgxChwsMwEv5qWVHIAxqSrVQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ok1y0qEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ok1y0qEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B5FC433F1;
	Sat, 24 Feb 2024 01:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739400;
	bh=IGMKze5kWSunePoZKiZBPBjFy85CZqSJB/r9/qANfnU=;
	h=Date:To:From:Subject:From;
	b=Ok1y0qEj9uE/LDOx/V1JHfdcMxidT/hLTwLs9530P5mCT1ADJVIMqY14pk+FsbGOP
	 io0jeQwD2DbcCjpnY9OlgDo8wdqcFRSmAHLXA3V0lxsw3ijRq2rXN0oa2pxy3yan3p
	 gdFe52DBtZhqfBs1eu06o6NUHBpxwlM3EUEnS+N0=
Date: Fri, 23 Feb 2024 17:50:00 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015000.66B5FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
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


