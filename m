Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E223D4F21B
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eArOVhkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56FAC433C7;
	Wed, 20 Dec 2023 23:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113411;
	bh=pdUj/ObRx4f17lN0q4s+oMOlLkUcINZH4cuWhBRW6NM=;
	h=Date:To:From:Subject:From;
	b=eArOVhkI7CSHsoY3wqiXxqhVFXR1vhmoXyTPYJNurklSlwdAErPzgzTGEHl15f0YF
	 DFtcjyJqQrHln35Hzb0VOUmRLvOqFZ8QUd0yUFYajJuNpzs0p8vEPQKDYvQ138LRKg
	 7vO9jR6GCa1Sx+ozp0xCaJEB/PxSqgHuzvMIY4Ig=
Date: Wed, 20 Dec 2023 15:03:31 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-arm64-print-out-debugging-message-if-required.patch removed from -mm tree
Message-Id: <20231220230331.A56FAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file, arm64: print out debugging message if required
has been removed from the -mm tree.  Its filename was
     kexec_file-arm64-print-out-debugging-message-if-required.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file, arm64: print out debugging message if required
Date: Wed, 13 Dec 2023 13:57:44 +0800

Then when specifying '-d' for kexec_file_load interface, loaded locations
of kernel/initrd/cmdline etc can be printed out to help debug.

Here replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also remove the kimage->segment[] printing because the generic code
has done the printing.

Link: https://lkml.kernel.org/r/20231213055747.61826-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c        |    6 ++---
 arch/arm64/kernel/machine_kexec.c      |   26 +++++------------------
 arch/arm64/kernel/machine_kexec_file.c |   12 +++++-----
 3 files changed, 15 insertions(+), 29 deletions(-)

--- a/arch/arm64/kernel/kexec_image.c~kexec_file-arm64-print-out-debugging-message-if-required
+++ a/arch/arm64/kernel/kexec_image.c
@@ -122,9 +122,9 @@ static void *image_load(struct kimage *i
 	kernel_segment->memsz -= text_offset;
 	image->start = kernel_segment->mem;
 
-	pr_debug("Loaded kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-				kernel_segment->mem, kbuf.bufsz,
-				kernel_segment->memsz);
+	kexec_dprintk("Loaded kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      kernel_segment->mem, kbuf.bufsz,
+		      kernel_segment->memsz);
 
 	return NULL;
 }
--- a/arch/arm64/kernel/machine_kexec.c~kexec_file-arm64-print-out-debugging-message-if-required
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -32,26 +32,12 @@
 static void _kexec_image_info(const char *func, int line,
 	const struct kimage *kimage)
 {
-	unsigned long i;
-
-	pr_debug("%s:%d:\n", func, line);
-	pr_debug("  kexec kimage info:\n");
-	pr_debug("    type:        %d\n", kimage->type);
-	pr_debug("    start:       %lx\n", kimage->start);
-	pr_debug("    head:        %lx\n", kimage->head);
-	pr_debug("    nr_segments: %lu\n", kimage->nr_segments);
-	pr_debug("    dtb_mem: %pa\n", &kimage->arch.dtb_mem);
-	pr_debug("    kern_reloc: %pa\n", &kimage->arch.kern_reloc);
-	pr_debug("    el2_vectors: %pa\n", &kimage->arch.el2_vectors);
-
-	for (i = 0; i < kimage->nr_segments; i++) {
-		pr_debug("      segment[%lu]: %016lx - %016lx, 0x%lx bytes, %lu pages\n",
-			i,
-			kimage->segment[i].mem,
-			kimage->segment[i].mem + kimage->segment[i].memsz,
-			kimage->segment[i].memsz,
-			kimage->segment[i].memsz /  PAGE_SIZE);
-	}
+	kexec_dprintk("%s:%d:\n", func, line);
+	kexec_dprintk("  kexec kimage info:\n");
+	kexec_dprintk("    type:        %d\n", kimage->type);
+	kexec_dprintk("    head:        %lx\n", kimage->head);
+	kexec_dprintk("    kern_reloc: %pa\n", &kimage->arch.kern_reloc);
+	kexec_dprintk("    el2_vectors: %pa\n", &kimage->arch.el2_vectors);
 }
 
 void machine_kexec_cleanup(struct kimage *kimage)
--- a/arch/arm64/kernel/machine_kexec_file.c~kexec_file-arm64-print-out-debugging-message-if-required
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -127,8 +127,8 @@ int load_other_segments(struct kimage *i
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
 
-		pr_debug("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
+		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load initrd */
@@ -148,8 +148,8 @@ int load_other_segments(struct kimage *i
 			goto out_err;
 		initrd_load_addr = kbuf.mem;
 
-		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-				initrd_load_addr, kbuf.bufsz, kbuf.memsz);
+		kexec_dprintk("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+			      initrd_load_addr, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load dtb */
@@ -179,8 +179,8 @@ int load_other_segments(struct kimage *i
 	image->arch.dtb = dtb;
 	image->arch.dtb_mem = kbuf.mem;
 
-	pr_debug("Loaded dtb at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			kbuf.mem, kbuf.bufsz, kbuf.memsz);
+	kexec_dprintk("Loaded dtb at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      kbuf.mem, kbuf.bufsz, kbuf.memsz);
 
 	return 0;
 
_

Patches currently in -mm which might be from bhe@redhat.com are


