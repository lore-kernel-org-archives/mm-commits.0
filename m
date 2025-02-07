Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C39C2417F4
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888212; cv=none; b=cDHuK63LcPU0HDthtbljBblUVQs91RQb/QN2w7dTutGFL+ZUGsMfc7oVYiTdupS6219BUNchb6166GqGDR3Bf/U8N5P2TjBdBwRQReDVh5ubWDtOlKxfBQiZTOteKct7whT/ndNroLpVsTmpUYNQZ84Mf8RcBNFqE4Hqc6GDDw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888212; c=relaxed/simple;
	bh=wQKNvrQZBctNrJfJbSTjKH+zi3DEcNcfr46wxX62XX8=;
	h=Date:To:From:Subject:Message-Id; b=OPfsqAfc/0BJKO7cFbZkWkChjS/zsqM2K4Q9B5c8XNT27zy/XQ05B6ChzymjMjdaO682nIvWsFBn38F5CZRz5tbjN5UsnTT7qzbtbaqefe4vTPL2OKzyLURJZkZJ0t/Nx8AEym3Vhb44AXfXQ/j9LIvli3g6vkNYjLvWaQK19oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oDOB+IYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oDOB+IYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF98C4CEDD;
	Fri,  7 Feb 2025 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888212;
	bh=wQKNvrQZBctNrJfJbSTjKH+zi3DEcNcfr46wxX62XX8=;
	h=Date:To:From:Subject:From;
	b=oDOB+IYC+KN+4BuW+0ej3rqFLaQB8bj5xWVdx5MFyP0FxlCnEaP9e2JhI/kfK+Jnd
	 qSR2tr5Jbz3mY/PIVQ0pcU+HlYc/nB0/lI0Q1mehtMtA4FTRjnaaD6uPt71hxWjqDz
	 Hp8+L4ghwuniej8o/22cX1ZC6sWouw6ukvxVwERk=
Date: Thu, 06 Feb 2025 16:30:11 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kho-support-to-kexec-file-loads.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003011.DBF98C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add KHO support to kexec file loads
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-kho-support-to-kexec-file-loads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kho-support-to-kexec-file-loads.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Graf <graf@amazon.com>
Subject: kexec: add KHO support to kexec file loads
Date: Thu, 6 Feb 2025 15:27:47 +0200

Kexec has 2 modes: A user space driven mode and a kernel driven mode.  For
the kernel driven mode, kernel code determines the physical addresses of
all target buffers that the payload gets copied into.

With KHO, we can only safely copy payloads into the "scratch area".  Teach
the kexec file loader about it, so it only allocates for that area.  In
addition, enlighten it with support to ask the KHO subsystem for its
respective payloads to copy into target memory.  Also teach the KHO
subsystem how to fill the images for file loads.

Link: https://lkml.kernel.org/r/20250206132754.2596694-8-rppt@kernel.org
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h   |    7 ++
 kernel/kexec_file.c     |   19 +++++++
 kernel/kexec_handover.c |   92 ++++++++++++++++++++++++++++++++++++++
 kernel/kexec_internal.h |   16 ++++++
 4 files changed, 134 insertions(+)

--- a/include/linux/kexec.h~kexec-add-kho-support-to-kexec-file-loads
+++ a/include/linux/kexec.h
@@ -373,6 +373,13 @@ struct kimage {
 	size_t ima_buffer_size;
 #endif
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	struct {
+		struct kexec_buf dt;
+		struct kexec_buf scratch;
+	} kho;
+#endif
+
 	/* Core ELF header buffer */
 	void *elf_headers;
 	unsigned long elf_headers_sz;
--- a/kernel/kexec_file.c~kexec-add-kho-support-to-kexec-file-loads
+++ a/kernel/kexec_file.c
@@ -113,6 +113,12 @@ void kimage_file_post_load_cleanup(struc
 	image->ima_buffer = NULL;
 #endif /* CONFIG_IMA_KEXEC */
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	kvfree(image->kho.dt.buffer);
+	image->kho.dt = (struct kexec_buf) {};
+	image->kho.scratch = (struct kexec_buf) {};
+#endif
+
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
 
@@ -253,6 +259,11 @@ kimage_file_prepare_segments(struct kima
 	/* IMA needs to pass the measurement list to the next kernel. */
 	ima_add_kexec_buffer(image);
 
+	/* If KHO is active, add its images to the list */
+	ret = kho_fill_kimage(image);
+	if (ret)
+		goto out;
+
 	/* Call image load handler */
 	ldata = kexec_image_load_default(image);
 
@@ -648,6 +659,14 @@ int kexec_locate_mem_hole(struct kexec_b
 	if (kbuf->mem != KEXEC_BUF_MEM_UNKNOWN)
 		return 0;
 
+	/*
+	 * If KHO is active, only use KHO scratch memory. All other memory
+	 * could potentially be handed over.
+	 */
+	ret = kho_locate_mem_hole(kbuf, locate_mem_hole_callback);
+	if (ret <= 0)
+		return ret;
+
 	if (!IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		ret = kexec_walk_resources(kbuf, locate_mem_hole_callback);
 	else
--- a/kernel/kexec_handover.c~kexec-add-kho-support-to-kexec-file-loads
+++ a/kernel/kexec_handover.c
@@ -16,6 +16,8 @@
 #include <linux/kexec_handover.h>
 #include <linux/page-isolation.h>
 
+#include "kexec_internal.h"
+
 static bool kho_enable __ro_after_init;
 
 static int __init kho_parse_enable(char *p)
@@ -155,6 +157,96 @@ void *kho_claim_mem(const struct kho_mem
 }
 EXPORT_SYMBOL_GPL(kho_claim_mem);
 
+int kho_fill_kimage(struct kimage *image)
+{
+	ssize_t scratch_size;
+	int err = 0;
+	void *dt;
+
+	mutex_lock(&kho_out.lock);
+
+	if (!kho_out.active)
+		goto out;
+
+	/*
+	 * Create a kexec copy of the DT here. We need this because lifetime may
+	 * be different between kho.dt and the kimage
+	 */
+	dt = kvmemdup(kho_out.dt, kho_out.dt_len, GFP_KERNEL);
+	if (!dt) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Allocate target memory for kho dt */
+	image->kho.dt = (struct kexec_buf) {
+		.image = image,
+		.buffer = dt,
+		.bufsz = kho_out.dt_len,
+		.mem = KEXEC_BUF_MEM_UNKNOWN,
+		.memsz = kho_out.dt_len,
+		.buf_align = SZ_64K, /* Makes it easier to map */
+		.buf_max = ULONG_MAX,
+		.top_down = true,
+	};
+	err = kexec_add_buffer(&image->kho.dt);
+	if (err) {
+		pr_info("===> %s: kexec_add_buffer\n", __func__);
+		goto out;
+	}
+
+	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
+	image->kho.scratch = (struct kexec_buf) {
+		.image = image,
+		.buffer = kho_scratch,
+		.bufsz = scratch_size,
+		.mem = KEXEC_BUF_MEM_UNKNOWN,
+		.memsz = scratch_size,
+		.buf_align = SZ_64K, /* Makes it easier to map */
+		.buf_max = ULONG_MAX,
+		.top_down = true,
+	};
+	err = kexec_add_buffer(&image->kho.scratch);
+
+out:
+	mutex_unlock(&kho_out.lock);
+	return err;
+}
+
+static int kho_walk_scratch(struct kexec_buf *kbuf,
+			    int (*func)(struct resource *, void *))
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		struct resource res = {
+			.start = kho_scratch[i].addr,
+			.end = kho_scratch[i].addr + kho_scratch[i].size - 1,
+		};
+
+		/* Try to fit the kimage into our KHO scratch region */
+		ret = func(&res, kbuf);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+int kho_locate_mem_hole(struct kexec_buf *kbuf,
+			int (*func)(struct resource *, void *))
+{
+	int ret;
+
+	if (!kho_out.active || kbuf->image->type == KEXEC_TYPE_CRASH)
+		return 1;
+
+	ret = kho_walk_scratch(kbuf, func);
+
+	return ret == 1 ? 0 : -EADDRNOTAVAIL;
+}
+
 static ssize_t dt_read(struct file *file, struct kobject *kobj,
 		       struct bin_attribute *attr, char *buf,
 		       loff_t pos, size_t count)
--- a/kernel/kexec_internal.h~kexec-add-kho-support-to-kexec-file-loads
+++ a/kernel/kexec_internal.h
@@ -39,4 +39,20 @@ extern size_t kexec_purgatory_size;
 #else /* CONFIG_KEXEC_FILE */
 static inline void kimage_file_post_load_cleanup(struct kimage *image) { }
 #endif /* CONFIG_KEXEC_FILE */
+
+struct kexec_buf;
+
+#ifdef CONFIG_KEXEC_HANDOVER
+int kho_locate_mem_hole(struct kexec_buf *kbuf,
+			int (*func)(struct resource *, void *));
+int kho_fill_kimage(struct kimage *image);
+#else
+static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
+				      int (*func)(struct resource *, void *))
+{
+	return 0;
+}
+
+static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+#endif
 #endif /* LINUX_KEXEC_INTERNAL_H */
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
kexec-add-documentation-for-kho.patch
arm64-add-kho-support.patch
x86-add-kho-support.patch
memblock-add-kho-support-for-reserve_mem.patch

