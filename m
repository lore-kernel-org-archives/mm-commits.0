From: akpm@linux-foundation.org
Subject: + powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch
 added to -mm tree
Date: Thu, 29 Sep 2016 16:15:16 -0700
Message-ID: <57eda084.88n7wn3kQOA+4jo4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50155 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935043AbcI2XPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, dyoung@redhat.com, ebiederm@xmission.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: ima: send the kexec buffer to the next kernel
has been added to the -mm tree.  Its filename is
     powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

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
Subject: powerpc: ima: send the kexec buffer to the next kernel

The IMA kexec buffer allows the currently running kernel to pass the
measurement list via a kexec segment to the kernel that will be kexec'd.

This is the architecture-specific part of setting up the IMA kexec buffer
for the next kernel.  It will be used in the next patch.

Link: http://lkml.kernel.org/r/1474911029-6372-6-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/ima.h         |   16 ++++
 arch/powerpc/include/asm/kexec.h       |   15 +++
 arch/powerpc/kernel/ima_kexec.c        |   91 +++++++++++++++++++++++
 arch/powerpc/kernel/kexec_elf_64.c     |    2 
 arch/powerpc/kernel/machine_kexec_64.c |   12 ++-
 5 files changed, 130 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/include/asm/ima.h~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/include/asm/ima.h
--- a/arch/powerpc/include/asm/ima.h~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/include/asm/ima.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_POWERPC_IMA_H
 #define _ASM_POWERPC_IMA_H
 
+struct kimage;
+
 int ima_get_kexec_buffer(void **addr, size_t *size);
 int ima_free_kexec_buffer(void);
 
@@ -10,4 +12,18 @@ void remove_ima_buffer(void *fdt, int ch
 static inline void remove_ima_buffer(void *fdt, int chosen_node) {}
 #endif
 
+#ifdef CONFIG_IMA_KEXEC
+int arch_ima_add_kexec_buffer(struct kimage *image, unsigned long load_addr,
+			      size_t size);
+
+int setup_ima_buffer(const struct kimage *image, void *fdt, int chosen_node);
+#else
+static inline int setup_ima_buffer(const struct kimage *image, void *fdt,
+				   int chosen_node)
+{
+	remove_ima_buffer(fdt, chosen_node);
+	return 0;
+}
+#endif /* CONFIG_IMA_KEXEC */
+
 #endif /* _ASM_POWERPC_IMA_H */
diff -puN arch/powerpc/include/asm/kexec.h~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/include/asm/kexec.h
@@ -92,12 +92,23 @@ static inline bool kdump_in_progress(voi
 }
 
 #ifdef CONFIG_KEXEC_FILE
+
+#ifdef CONFIG_IMA_KEXEC
+#define ARCH_HAS_KIMAGE_ARCH
+
+struct kimage_arch {
+	phys_addr_t ima_buffer_addr;
+	size_t ima_buffer_size;
+};
+#endif
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
 int delete_fdt_mem_rsv(void *fdt, unsigned long start, unsigned long size);
 #endif /* CONFIG_KEXEC_FILE */
diff -puN arch/powerpc/kernel/ima_kexec.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/kernel/ima_kexec.c
--- a/arch/powerpc/kernel/ima_kexec.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/kernel/ima_kexec.c
@@ -130,3 +130,94 @@ void remove_ima_buffer(void *fdt, int ch
 	if (!ret)
 		pr_debug("Removed old IMA buffer reservation.\n");
 }
+
+#ifdef CONFIG_IMA_KEXEC
+/**
+ * arch_ima_add_kexec_buffer - do arch-specific steps to add the IMA buffer
+ *
+ * Architectures should use this function to pass on the IMA buffer
+ * information to the next kernel.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int arch_ima_add_kexec_buffer(struct kimage *image, unsigned long load_addr,
+			      size_t size)
+{
+	image->arch.ima_buffer_addr = load_addr;
+	image->arch.ima_buffer_size = size;
+
+	return 0;
+}
+
+static int write_number(void *p, u64 value, int cells)
+{
+	if (cells == 1) {
+		u32 tmp;
+
+		if (value > U32_MAX)
+			return -EINVAL;
+
+		tmp = cpu_to_be32(value);
+		memcpy(p, &tmp, sizeof(tmp));
+	} else if (cells == 2) {
+		u64 tmp;
+
+		tmp = cpu_to_be64(value);
+		memcpy(p, &tmp, sizeof(tmp));
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * setup_ima_buffer - add IMA buffer information to the fdt
+ * @image:		kexec image being loaded.
+ * @fdt:		Flattened device tree for the next kernel.
+ * @chosen_node:	Offset to the chosen node.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_ima_buffer(const struct kimage *image, void *fdt, int chosen_node)
+{
+	int ret, addr_cells, size_cells, entry_size;
+	u8 value[16];
+
+	remove_ima_buffer(fdt, chosen_node);
+	if (!image->arch.ima_buffer_size)
+		return 0;
+
+	ret = get_addr_size_cells(&addr_cells, &size_cells);
+	if (ret)
+		return ret;
+
+	entry_size = 4 * (addr_cells + size_cells);
+
+	if (entry_size > sizeof(value))
+		return -EINVAL;
+
+	ret = write_number(value, image->arch.ima_buffer_addr, addr_cells);
+	if (ret)
+		return ret;
+
+	ret = write_number(value + 4 * addr_cells, image->arch.ima_buffer_size,
+			   size_cells);
+	if (ret)
+		return ret;
+
+	ret = fdt_setprop(fdt, chosen_node, "linux,ima-kexec-buffer", value,
+			  entry_size);
+	if (ret < 0)
+		return -EINVAL;
+
+	ret = fdt_add_mem_rsv(fdt, image->arch.ima_buffer_addr,
+			      image->arch.ima_buffer_size);
+	if (ret)
+		return -EINVAL;
+
+	pr_debug("IMA buffer at 0x%llx, size = 0x%zx\n",
+		 image->arch.ima_buffer_addr, image->arch.ima_buffer_size);
+
+	return 0;
+}
+#endif /* CONFIG_IMA_KEXEC */
diff -puN arch/powerpc/kernel/kexec_elf_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/kernel/kexec_elf_64.c
--- a/arch/powerpc/kernel/kexec_elf_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -208,7 +208,7 @@ void *elf64_load(struct kimage *image, c
 		goto out;
 	}
 
-	ret = setup_new_fdt(fdt, initrd_load_addr, initrd_len, cmdline);
+	ret = setup_new_fdt(image, fdt, initrd_load_addr, initrd_len, cmdline);
 	if (ret)
 		goto out;
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -689,6 +689,7 @@ int setup_purgatory(struct kimage *image
 
 /**
  * setup_new_fdt() - modify /chosen and memory reservations for the next kernel
+ * @image:		kexec image being loaded.
  * @fdt:		Flattened device tree for the next kernel.
  * @initrd_load_addr:	Address where the next initrd will be loaded.
  * @initrd_len:		Size of the next initrd, or 0 if there will be none.
@@ -697,8 +698,9 @@ int setup_purgatory(struct kimage *image
  *
  * Return: 0 on success, or negative errno on error.
  */
-int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
-		  unsigned long initrd_len, const char *cmdline)
+int setup_new_fdt(const struct kimage *image, void *fdt,
+		  unsigned long initrd_load_addr, unsigned long initrd_len,
+		  const char *cmdline)
 {
 	int ret, chosen_node;
 	const void *prop;
@@ -808,7 +810,11 @@ int setup_new_fdt(void *fdt, unsigned lo
 		}
 	}
 
-	remove_ima_buffer(fdt, chosen_node);
+	ret = setup_ima_buffer(image, fdt, chosen_node);
+	if (ret) {
+		pr_err("Error setting up the new device tree.\n");
+		return ret;
+	}
 
 	ret = fdt_setprop(fdt, chosen_node, "linux,booted-from-kexec", NULL, 0);
 	if (ret) {
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

