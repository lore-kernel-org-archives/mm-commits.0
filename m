From: akpm@linux-foundation.org
Subject: [to-be-updated]
 powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch removed from -mm tree
Date: Fri, 02 Dec 2016 17:13:47 -0800
Message-ID: <58421c4b.IPVy+KJtqZ1drEYT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932835AbcLCBN1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 20:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dmitry.kasatkin@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: ima: send the kexec buffer to the next kernel
has been removed from the -mm tree.  Its filename was
     powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: powerpc: ima: send the kexec buffer to the next kernel

From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>

The IMA kexec buffer allows the currently running kernel to pass
the measurement list via a kexec segment to the kernel that will be
kexec'd.

This is the architecture-specific part of setting up the IMA kexec
buffer for the next kernel. It will be used in the next patch.

Link: http://lkml.kernel.org/r/1478789780-17719-6-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/ima.h              |   16 +++
 arch/powerpc/include/asm/kexec.h            |   14 ++
 arch/powerpc/kernel/ima_kexec.c             |   91 ++++++++++++++++++
 arch/powerpc/kernel/kexec_elf_64.c          |    2 
 arch/powerpc/kernel/machine_kexec_file_64.c |   12 +-
 5 files changed, 129 insertions(+), 6 deletions(-)

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
@@ -94,11 +94,21 @@ static inline bool kdump_in_progress(voi
 #ifdef CONFIG_KEXEC_FILE
 extern struct kexec_file_ops kexec_elf64_ops;
 
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
 		    unsigned long fdt_load_addr);
-int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
-		  unsigned long initrd_len, const char *cmdline);
+int setup_new_fdt(const struct kimage *image, void *fdt,
+		  unsigned long initrd_load_addr, unsigned long initrd_len,
+		  const char *cmdline);
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
@@ -627,7 +627,7 @@ static void *elf64_load(struct kimage *i
 		goto out;
 	}
 
-	ret = setup_new_fdt(fdt, initrd_load_addr, initrd_len, cmdline);
+	ret = setup_new_fdt(image, fdt, initrd_load_addr, initrd_len, cmdline);
 	if (ret)
 		goto out;
 
diff -puN arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel arch/powerpc/kernel/machine_kexec_file_64.c
--- a/arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-ima-send-the-kexec-buffer-to-the-next-kernel
+++ a/arch/powerpc/kernel/machine_kexec_file_64.c
@@ -210,6 +210,7 @@ int delete_fdt_mem_rsv(void *fdt, unsign
 
 /*
  * setup_new_fdt - modify /chosen and memory reservation for the next kernel
+ * @image:		kexec image being loaded.
  * @fdt:		Flattened device tree for the next kernel.
  * @initrd_load_addr:	Address where the next initrd will be loaded.
  * @initrd_len:		Size of the next initrd, or 0 if there will be none.
@@ -218,8 +219,9 @@ int delete_fdt_mem_rsv(void *fdt, unsign
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
@@ -329,7 +331,11 @@ int setup_new_fdt(void *fdt, unsigned lo
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

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-save-the-measurement-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

