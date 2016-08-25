From: akpm@linux-foundation.org
Subject: +
 powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:13:45 -0700
Message-ID: <57bf5f89.nYRE0Hv4T9x5zBrx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756403AbcHYVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: kexec_file: add buffer hand-over support for the next kernel
has been added to the -mm tree.  Its filename is
     powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: kexec_file: add buffer hand-over support for the next kernel

The buffer hand-over mechanism allows the currently running kernel to pass
data to kernel that will be kexec'd via a kexec segment. The second kernel
can check whether the previous kernel sent data and retrieve it.

This is the architecture-specific part.

Link: http://lkml.kernel.org/r/1472149111-30598-3-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/kexec.h       |   12 ++
 arch/powerpc/kernel/kexec_elf_64.c     |    2 
 arch/powerpc/kernel/machine_kexec_64.c |  114 +++++++++++++++++++++--
 3 files changed, 120 insertions(+), 8 deletions(-)

diff -puN arch/powerpc/include/asm/kexec.h~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/arch/powerpc/include/asm/kexec.h
@@ -92,12 +92,20 @@ static inline bool kdump_in_progress(voi
 }
 
 #ifdef CONFIG_KEXEC_FILE
+#define ARCH_HAS_KIMAGE_ARCH
+
+struct kimage_arch {
+	phys_addr_t handover_buffer_addr;
+	unsigned long handover_buffer_size;
+};
+
 int setup_purgatory(struct kimage *image, const void *slave_code,
 		    const void *fdt, unsigned long kernel_load_addr,
 		    unsigned long fdt_load_addr, unsigned long stack_top,
 		    int debug);
-int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
-		  unsigned long initrd_len, const char *cmdline);
+int setup_new_fdt(const struct kimage *image, void *fdt,
+		  unsigned long initrd_load_addr, unsigned long initrd_len,
+		  const char *cmdline);
 bool find_debug_console(const void *fdt);
 #endif /* CONFIG_KEXEC_FILE */
 
diff -puN arch/powerpc/kernel/kexec_elf_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel arch/powerpc/kernel/kexec_elf_64.c
--- a/arch/powerpc/kernel/kexec_elf_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -209,7 +209,7 @@ void *elf64_load(struct kimage *image, c
 		goto out;
 	}
 
-	ret = setup_new_fdt(fdt, initrd_load_addr, initrd_len, cmdline);
+	ret = setup_new_fdt(image, fdt, initrd_load_addr, initrd_len, cmdline);
 	if (ret)
 		goto out;
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -489,6 +489,60 @@ int arch_kimage_file_post_load_cleanup(s
 	return image->fops->cleanup(image->image_loader_data);
 }
 
+bool kexec_can_hand_over_buffer(void)
+{
+	return true;
+}
+
+int arch_kexec_add_handover_buffer(struct kimage *image,
+				   unsigned long load_addr, unsigned long size)
+{
+	image->arch.handover_buffer_addr = load_addr;
+	image->arch.handover_buffer_size = size;
+
+	return 0;
+}
+
+int kexec_get_handover_buffer(void **addr, unsigned long *size)
+{
+	int ret;
+	u64 start_addr, end_addr;
+
+	ret = of_property_read_u64(of_chosen,
+				   "linux,kexec-handover-buffer-start",
+				   &start_addr);
+	if (ret == -EINVAL)
+		return -ENOENT;
+	else if (ret)
+		return -EINVAL;
+
+	ret = of_property_read_u64(of_chosen, "linux,kexec-handover-buffer-end",
+				   &end_addr);
+	if (ret == -EINVAL)
+		return -ENOENT;
+	else if (ret)
+		return -EINVAL;
+
+	*addr =  __va(start_addr);
+	/* -end is the first address after the buffer. */
+	*size = end_addr - start_addr;
+
+	return 0;
+}
+
+int kexec_free_handover_buffer(void)
+{
+	int ret;
+	void *addr;
+	unsigned long size;
+
+	ret = kexec_get_handover_buffer(&addr, &size);
+	if (ret)
+		return ret;
+
+	return memblock_free((phys_addr_t) addr, size);
+}
+
 /**
  * arch_kexec_walk_mem() - call func(data) for each unreserved memory block
  * @kbuf:	Context info for the search. Also passed to @func.
@@ -686,9 +740,52 @@ int setup_purgatory(struct kimage *image
 	return 0;
 }
 
-/*
- * setup_new_fdt() - modify /chosen and memory reservation for the next kernel
- * @fdt:
+/**
+ * setup_handover_buffer() - add properties and reservation for the handover buffer
+ * @image:		kexec image being loaded.
+ * @fdt:		Flattened device tree for the next kernel.
+ * @chosen_node:	Offset to the chosen node.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static int setup_handover_buffer(const struct kimage *image, void *fdt,
+				 int chosen_node)
+{
+	int ret;
+
+	if (image->arch.handover_buffer_addr == 0)
+		return 0;
+
+	ret = fdt_setprop_u64(fdt, chosen_node,
+			      "linux,kexec-handover-buffer-start",
+			      image->arch.handover_buffer_addr);
+	if (ret < 0)
+		return -EINVAL;
+
+	/* -end is the first address after the buffer. */
+	ret = fdt_setprop_u64(fdt, chosen_node,
+			      "linux,kexec-handover-buffer-end",
+			      image->arch.handover_buffer_addr +
+			      image->arch.handover_buffer_size);
+	if (ret < 0)
+		return -EINVAL;
+
+	ret = fdt_add_mem_rsv(fdt, image->arch.handover_buffer_addr,
+			      image->arch.handover_buffer_size);
+	if (ret)
+		return -EINVAL;
+
+	pr_debug("kexec handover buffer at 0x%llx, size = 0x%lx\n",
+		 image->arch.handover_buffer_addr,
+		 image->arch.handover_buffer_size);
+
+	return 0;
+}
+
+/**
+ * setup_new_fdt() - modify /chosen and memory reservations for the next kernel
+ * @image:		kexec image being loaded.
+ * @fdt:		Flattened device tree for the next kernel.
  * @initrd_load_addr:	Address where the next initrd will be loaded.
  * @initrd_len:		Size of the next initrd, or 0 if there will be none.
  * @cmdline:		Command line for the next kernel, or NULL if there will
@@ -696,8 +793,9 @@ int setup_purgatory(struct kimage *image
  *
  * Return: 0 on success, or negative errno on error.
  */
-int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
-		  unsigned long initrd_len, const char *cmdline)
+int setup_new_fdt(const struct kimage *image, void *fdt,
+		  unsigned long initrd_load_addr, unsigned long initrd_len,
+		  const char *cmdline)
 {
 	uint64_t oldfdt_addr;
 	int i, ret, chosen_node;
@@ -839,6 +937,12 @@ int setup_new_fdt(void *fdt, unsigned lo
 		}
 	}
 
+	ret = setup_handover_buffer(image, fdt, chosen_node);
+	if (ret) {
+		pr_err("Error setting up the new device tree.\n");
+		return ret;
+	}
+
 	ret = fdt_setprop(fdt, chosen_node, "linux,booted-from-kexec", NULL, 0);
 	if (ret) {
 		pr_err("Error setting up the new device tree.\n");
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-demonstration-code-for-kexec-buffer-passing.patch

