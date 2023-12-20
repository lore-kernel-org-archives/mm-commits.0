Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EC14F211
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPCvaVY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9599EC433C7;
	Wed, 20 Dec 2023 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113412;
	bh=uKJ53Zq2gOvsRLuR89VrOaXFxlhbgF0NfdzuVniOoHo=;
	h=Date:To:From:Subject:From;
	b=EPCvaVY/gPpuzqQe2bk3pJmUMR7dg+CYI+innjctcIlq5D9yW9z2bSv+Nr9U1gyYl
	 6gqw8rwTKFKZKIzfgJQNVn40A/NQmLXhE5gb3pRNasJTyrCvgG279GKGaHLB11SMbS
	 28bdTJ18LGCymh5LilKOhJ6YnfmUpZspOvAjqKCc=
Date: Wed, 20 Dec 2023 15:03:32 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-ricv-print-out-debugging-message-if-required.patch removed from -mm tree
Message-Id: <20231220230332.9599EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file, riscv: print out debugging message if required
has been removed from the -mm tree.  Its filename was
     kexec_file-ricv-print-out-debugging-message-if-required.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file, riscv: print out debugging message if required
Date: Wed, 13 Dec 2023 13:57:45 +0800

Then when specifying '-d' for kexec_file_load interface, loaded locations
of kernel/initrd/cmdline etc can be printed out to help debug.

Here replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

And also replace pr_notice() with kexec_dprintk() in elf_kexec_load()
because loaded location of purgatory and device tree are only printed out
for debugging, it doesn't make sense to always print them out.

And also remove kexec_image_info() because the content has been printed
out in generic code.

Link: https://lkml.kernel.org/r/20231213055747.61826-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/elf_kexec.c     |   11 ++++++-----
 arch/riscv/kernel/machine_kexec.c |   26 --------------------------
 2 files changed, 6 insertions(+), 31 deletions(-)

--- a/arch/riscv/kernel/elf_kexec.c~kexec_file-ricv-print-out-debugging-message-if-required
+++ a/arch/riscv/kernel/elf_kexec.c
@@ -216,7 +216,6 @@ static void *elf_kexec_load(struct kimag
 	if (ret)
 		goto out;
 	kernel_start = image->start;
-	pr_notice("The entry point of kernel at 0x%lx\n", image->start);
 
 	/* Add the kernel binary to the image */
 	ret = riscv_kexec_elf_load(image, &ehdr, &elf_info,
@@ -252,8 +251,8 @@ static void *elf_kexec_load(struct kimag
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
 
-		pr_debug("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
+		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
 
 		/* Setup cmdline for kdump kernel case */
 		modified_cmdline = setup_kdump_cmdline(image, cmdline,
@@ -275,6 +274,8 @@ static void *elf_kexec_load(struct kimag
 		pr_err("Error loading purgatory ret=%d\n", ret);
 		goto out;
 	}
+	kexec_dprintk("Loaded purgatory at 0x%lx\n", kbuf.mem);
+
 	ret = kexec_purgatory_get_set_symbol(image, "riscv_kernel_entry",
 					     &kernel_start,
 					     sizeof(kernel_start), 0);
@@ -293,7 +294,7 @@ static void *elf_kexec_load(struct kimag
 		if (ret)
 			goto out;
 		initrd_pbase = kbuf.mem;
-		pr_notice("Loaded initrd at 0x%lx\n", initrd_pbase);
+		kexec_dprintk("Loaded initrd at 0x%lx\n", initrd_pbase);
 	}
 
 	/* Add the DTB to the image */
@@ -318,7 +319,7 @@ static void *elf_kexec_load(struct kimag
 	}
 	/* Cache the fdt buffer address for memory cleanup */
 	image->arch.fdt = fdt;
-	pr_notice("Loaded device tree at 0x%lx\n", kbuf.mem);
+	kexec_dprintk("Loaded device tree at 0x%lx\n", kbuf.mem);
 	goto out;
 
 out_free_fdt:
--- a/arch/riscv/kernel/machine_kexec.c~kexec_file-ricv-print-out-debugging-message-if-required
+++ a/arch/riscv/kernel/machine_kexec.c
@@ -19,30 +19,6 @@
 #include <linux/irq.h>
 
 /*
- * kexec_image_info - Print received image details
- */
-static void
-kexec_image_info(const struct kimage *image)
-{
-	unsigned long i;
-
-	pr_debug("Kexec image info:\n");
-	pr_debug("\ttype:        %d\n", image->type);
-	pr_debug("\tstart:       %lx\n", image->start);
-	pr_debug("\thead:        %lx\n", image->head);
-	pr_debug("\tnr_segments: %lu\n", image->nr_segments);
-
-	for (i = 0; i < image->nr_segments; i++) {
-		pr_debug("\t    segment[%lu]: %016lx - %016lx", i,
-			image->segment[i].mem,
-			image->segment[i].mem + image->segment[i].memsz);
-		pr_debug("\t\t0x%lx bytes, %lu pages\n",
-			(unsigned long) image->segment[i].memsz,
-			(unsigned long) image->segment[i].memsz /  PAGE_SIZE);
-	}
-}
-
-/*
  * machine_kexec_prepare - Initialize kexec
  *
  * This function is called from do_kexec_load, when the user has
@@ -60,8 +36,6 @@ machine_kexec_prepare(struct kimage *ima
 	unsigned int control_code_buffer_sz = 0;
 	int i = 0;
 
-	kexec_image_info(image);
-
 	/* Find the Flattened Device Tree and save its physical address */
 	for (i = 0; i < image->nr_segments; i++) {
 		if (image->segment[i].memsz <= sizeof(fdt))
_

Patches currently in -mm which might be from bhe@redhat.com are


