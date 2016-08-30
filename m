From: akpm@linux-foundation.org
Subject: +
 powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
 added to -mm tree
Date: Tue, 30 Aug 2016 14:57:51 -0700
Message-ID: <57c6015f.8nvOIw1jJr56LITG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbcH3V5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 17:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


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

Link: http://lkml.kernel.org/r/1472579105-26296-3-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
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

 arch/powerpc/include/asm/kexec.h       |   12 -
 arch/powerpc/kernel/kexec_elf_64.c     |    2 
 arch/powerpc/kernel/machine_kexec_64.c |  274 +++++++++++++++++++----
 3 files changed, 240 insertions(+), 48 deletions(-)

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
@@ -208,7 +208,7 @@ void *elf64_load(struct kimage *image, c
 		goto out;
 	}
 
-	ret = setup_new_fdt(fdt, initrd_load_addr, initrd_len, cmdline);
+	ret = setup_new_fdt(image, fdt, initrd_load_addr, initrd_len, cmdline);
 	if (ret)
 		goto out;
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -489,6 +489,77 @@ int arch_kimage_file_post_load_cleanup(s
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
+	struct property *prop;
+
+	ret = kexec_get_handover_buffer(&addr, &size);
+	if (ret)
+		return ret;
+
+	ret = memblock_free(__pa(addr), size);
+	if (ret)
+		return ret;
+
+	prop = of_find_property(of_chosen, "linux,kexec-handover-buffer-start",
+				NULL);
+	ret = of_remove_property(of_chosen, prop);
+	if (ret)
+		return ret;
+
+	prop = of_find_property(of_chosen, "linux,kexec-handover-buffer-end",
+				NULL);
+	ret = of_remove_property(of_chosen, prop);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 /**
  * arch_kexec_walk_mem() - call func(data) for each unreserved memory block
  * @kbuf:	Context info for the search. Also passed to @func.
@@ -686,26 +757,16 @@ int setup_purgatory(struct kimage *image
 	return 0;
 }
 
-/*
- * setup_new_fdt() - modify /chosen and memory reservation for the next kernel
- * @fdt:
- * @initrd_load_addr:	Address where the next initrd will be loaded.
- * @initrd_len:		Size of the next initrd, or 0 if there will be none.
- * @cmdline:		Command line for the next kernel, or NULL if there will
- *			be none.
+/**
+ * delete_fdt_mem_rsv() - delete memory reservation with given address and size
  *
  * Return: 0 on success, or negative errno on error.
  */
-int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
-		  unsigned long initrd_len, const char *cmdline)
+static int delete_fdt_mem_rsv(void *fdt, uint64_t start, uint64_t size)
 {
-	uint64_t oldfdt_addr;
-	int i, ret, chosen_node;
-	const void *prop;
+	int i, ret, num_rsvs = fdt_num_mem_rsv(fdt);
 
-	/* Remove memory reservation for the current device tree. */
-	oldfdt_addr = __pa(initial_boot_params);
-	for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
+	for (i = 0; i < num_rsvs; i++) {
 		uint64_t rsv_start, rsv_size;
 
 		ret = fdt_get_mem_rsv(fdt, i, &rsv_start, &rsv_size);
@@ -714,19 +775,152 @@ int setup_new_fdt(void *fdt, unsigned lo
 			return -EINVAL;
 		}
 
-		if (rsv_start == oldfdt_addr &&
-		    rsv_size == fdt_totalsize(initial_boot_params)) {
+		if (rsv_start == start && rsv_size == size) {
 			ret = fdt_del_mem_rsv(fdt, i);
 			if (ret) {
-				pr_err("Error deleting fdt reservation.\n");
+				pr_err("Error deleting device tree reservation.\n");
+				return -EINVAL;
+			}
+
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/**
+ * setup_handover_buffer() - add handover buffer information to the fdt
+ * @image:		kexec image being loaded.
+ * @fdt:		Flattened device tree for the next kernel.
+ * @chosen_node:	Offset to the chosen node.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+static int setup_handover_buffer(const struct kimage *image, void *fdt,
+				 int chosen_node)
+{
+	int ret;
+	const void *prop;
+
+	/* Did we receive a buffer from the previous kernel? */
+	prop = fdt_getprop(fdt, chosen_node,
+			   "linux,kexec-handover-buffer-start", NULL);
+	if (prop) {
+		u64 orig_start, orig_end;
+		unsigned long size;
+		void *addr;
+
+		orig_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		prop = fdt_getprop(fdt, chosen_node,
+				   "linux,kexec-handover-buffer-end", NULL);
+		if (!prop) {
+			pr_err("Malformed device tree.\n");
+			return -EINVAL;
+		}
+		orig_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		/* Did we free the hand-over buffer from the previous kernel? */
+		ret = kexec_get_handover_buffer(&addr, &size);
+		if (ret == -ENOENT)
+			addr = NULL;
+		else if (ret)
+			return ret;
+
+		/*
+		 * If we received a buffer from the previous kernel but deleted
+		 * it from the live DT, or if we have a new buffer for the next
+		 * kernel then we should remove the memory reservation from
+		 * the FDT.
+		 */
+		if (addr == NULL || image->arch.handover_buffer_addr != 0) {
+			ret = delete_fdt_mem_rsv(fdt, orig_start,
+						 orig_end - orig_start);
+			if (ret == 0)
+				pr_debug("Removed old hand-over buffer reservation.\n");
+			else if (ret != -ENOENT)
+				return ret;
+		}
+
+		/*
+		 * If we received a buffer from the previous kernel but deleted
+		 * it from the live DT and we have no buffer for the next kernel
+		 * then we should remove the hand-over buffer properties from
+		 * the FDT.
+		 */
+		if (addr == NULL && image->arch.handover_buffer_addr == 0) {
+			ret = fdt_delprop(fdt, chosen_node,
+					  "linux,kexec-handover-buffer-start");
+			if (ret) {
+				pr_err("Error setting up the new device tree.\n");
 				return -EINVAL;
 			}
 
-			pr_debug("Removed old device tree reservation.\n");
-			break;
+			ret = fdt_delprop(fdt, chosen_node,
+					  "linux,kexec-handover-buffer-end");
+			if (ret) {
+				pr_err("Error setting up the new device tree.\n");
+				return -EINVAL;
+			}
 		}
 	}
 
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
+ * @initrd_load_addr:	Address where the next initrd will be loaded.
+ * @initrd_len:		Size of the next initrd, or 0 if there will be none.
+ * @cmdline:		Command line for the next kernel, or NULL if there will
+ *			be none.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_new_fdt(const struct kimage *image, void *fdt,
+		  unsigned long initrd_load_addr, unsigned long initrd_len,
+		  const char *cmdline)
+{
+	int ret, chosen_node;
+	const void *prop;
+
+	/* Remove memory reservation for the current device tree. */
+	ret = delete_fdt_mem_rsv(fdt, __pa(initial_boot_params),
+				 fdt_totalsize(initial_boot_params));
+	if (ret == 0)
+		pr_debug("Removed old device tree reservation.\n");
+	else if (ret != -ENOENT)
+		return ret;
+
 	chosen_node = fdt_path_offset(fdt, "/chosen");
 	if (chosen_node == -FDT_ERR_NOTFOUND) {
 		chosen_node = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"),
@@ -743,7 +937,7 @@ int setup_new_fdt(void *fdt, unsigned lo
 	/* Did we boot using an initrd? */
 	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
 	if (prop) {
-		uint64_t tmp_start, tmp_end, tmp_size, tmp_sizepg;
+		uint64_t tmp_start, tmp_end, tmp_size;
 
 		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
 
@@ -759,30 +953,14 @@ int setup_new_fdt(void *fdt, unsigned lo
 		 * reserve a multiple of PAGE_SIZE, so check for both.
 		 */
 		tmp_size = tmp_end - tmp_start;
-		tmp_sizepg = round_up(tmp_size, PAGE_SIZE);
-
-		/* Remove memory reservation for the current initrd. */
-		for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
-			uint64_t rsv_start, rsv_size;
-
-			ret = fdt_get_mem_rsv(fdt, i, &rsv_start, &rsv_size);
-			if (ret) {
-				pr_err("Malformed device tree.\n");
-				return -EINVAL;
-			}
-
-			if (rsv_start == tmp_start &&
-			    (rsv_size == tmp_size || rsv_size == tmp_sizepg)) {
-				ret = fdt_del_mem_rsv(fdt, i);
-				if (ret) {
-					pr_err("Error deleting fdt reservation.\n");
-					return -EINVAL;
-				}
-				pr_debug("Removed old initrd reservation.\n");
-
-				break;
-			}
-		}
+		ret = delete_fdt_mem_rsv(fdt, tmp_start, tmp_size);
+		if (ret == -ENOENT)
+			ret = delete_fdt_mem_rsv(fdt, tmp_start,
+						 round_up(tmp_size, PAGE_SIZE));
+		if (ret == 0)
+			pr_debug("Removed old initrd reservation.\n");
+		else if (ret != -ENOENT)
+			return ret;
 
 		/* If there's no new initrd, delete the old initrd's info. */
 		if (initrd_len == 0) {
@@ -840,6 +1018,12 @@ int setup_new_fdt(void *fdt, unsigned lo
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

kexec-fix-double-free-when-failing-to-relocate-the-purgatory.patch
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
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-demonstration-code-for-kexec-buffer-passing.patch

