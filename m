From: akpm@linux-foundation.org
Subject: +
 powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch added
 to -mm tree
Date: Fri, 16 Sep 2016 16:34:55 -0700
Message-ID: <57dc819f.nabfoxAMWCehuYJl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59813 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbcIPXe5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add code to work with device trees in kexec_file_load
has been added to the -mm tree.  Its filename is
     powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch

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
Subject: powerpc: add code to work with device trees in kexec_file_load

kexec_file_load needs to set up the device tree that will be used
by the next kernel and check whether it provides a console
that can be used by the purgatory.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1472579041-26033-11-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/kexec.h       |    3 
 arch/powerpc/kernel/machine_kexec_64.c |  221 +++++++++++++++++++++++
 2 files changed, 224 insertions(+)

diff -puN arch/powerpc/include/asm/kexec.h~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load
+++ a/arch/powerpc/include/asm/kexec.h
@@ -96,6 +96,9 @@ int setup_purgatory(struct kimage *image
 		    const void *fdt, unsigned long kernel_load_addr,
 		    unsigned long fdt_load_addr, unsigned long stack_top,
 		    int debug);
+int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
+		  unsigned long initrd_len, const char *cmdline);
+bool find_debug_console(const void *fdt);
 #endif /* CONFIG_KEXEC_FILE */
 
 #else /* !CONFIG_KEXEC_CORE */
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -683,4 +683,225 @@ int setup_purgatory(struct kimage *image
 	return 0;
 }
 
+/*
+ * setup_new_fdt() - modify /chosen and memory reservation for the next kernel
+ * @fdt:
+ * @initrd_load_addr:	Address where the next initrd will be loaded.
+ * @initrd_len:		Size of the next initrd, or 0 if there will be none.
+ * @cmdline:		Command line for the next kernel, or NULL if there will
+ *			be none.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
+		  unsigned long initrd_len, const char *cmdline)
+{
+	uint64_t oldfdt_addr;
+	int i, ret, chosen_node;
+	const void *prop;
+
+	/* Remove memory reservation for the current device tree. */
+	oldfdt_addr = __pa(initial_boot_params);
+	for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
+		uint64_t rsv_start, rsv_size;
+
+		ret = fdt_get_mem_rsv(fdt, i, &rsv_start, &rsv_size);
+		if (ret) {
+			pr_err("Malformed device tree.\n");
+			return -EINVAL;
+		}
+
+		if (rsv_start == oldfdt_addr &&
+		    rsv_size == fdt_totalsize(initial_boot_params)) {
+			ret = fdt_del_mem_rsv(fdt, i);
+			if (ret) {
+				pr_err("Error deleting fdt reservation.\n");
+				return -EINVAL;
+			}
+
+			pr_debug("Removed old device tree reservation.\n");
+			break;
+		}
+	}
+
+	chosen_node = fdt_path_offset(fdt, "/chosen");
+	if (chosen_node == -FDT_ERR_NOTFOUND) {
+		chosen_node = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"),
+					      "chosen");
+		if (chosen_node < 0) {
+			pr_err("Error creating /chosen.\n");
+			return -EINVAL;
+		}
+	} else if (chosen_node < 0) {
+		pr_err("Malformed device tree: error reading /chosen.\n");
+		return -EINVAL;
+	}
+
+	/* Did we boot using an initrd? */
+	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
+	if (prop) {
+		uint64_t tmp_start, tmp_end, tmp_size, tmp_sizepg;
+
+		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", NULL);
+		if (!prop) {
+			pr_err("Malformed device tree.\n");
+			return -EINVAL;
+		}
+		tmp_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		/*
+		 * kexec reserves exact initrd size, while firmware may
+		 * reserve a multiple of PAGE_SIZE, so check for both.
+		 */
+		tmp_size = tmp_end - tmp_start;
+		tmp_sizepg = round_up(tmp_size, PAGE_SIZE);
+
+		/* Remove memory reservation for the current initrd. */
+		for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
+			uint64_t rsv_start, rsv_size;
+
+			ret = fdt_get_mem_rsv(fdt, i, &rsv_start, &rsv_size);
+			if (ret) {
+				pr_err("Malformed device tree.\n");
+				return -EINVAL;
+			}
+
+			if (rsv_start == tmp_start &&
+			    (rsv_size == tmp_size || rsv_size == tmp_sizepg)) {
+				ret = fdt_del_mem_rsv(fdt, i);
+				if (ret) {
+					pr_err("Error deleting fdt reservation.\n");
+					return -EINVAL;
+				}
+				pr_debug("Removed old initrd reservation.\n");
+
+				break;
+			}
+		}
+
+		/* If there's no new initrd, delete the old initrd's info. */
+		if (initrd_len == 0) {
+			ret = fdt_delprop(fdt, chosen_node,
+					  "linux,initrd-start");
+			if (ret) {
+				pr_err("Error deleting linux,initrd-start.\n");
+				return -EINVAL;
+			}
+
+			ret = fdt_delprop(fdt, chosen_node, "linux,initrd-end");
+			if (ret) {
+				pr_err("Error deleting linux,initrd-end.\n");
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (initrd_len) {
+		ret = fdt_setprop_u64(fdt, chosen_node,
+				      "linux,initrd-start",
+				      initrd_load_addr);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+
+		/* initrd-end is the first address after the initrd image. */
+		ret = fdt_setprop_u64(fdt, chosen_node, "linux,initrd-end",
+				      initrd_load_addr + initrd_len);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+
+		ret = fdt_add_mem_rsv(fdt, initrd_load_addr, initrd_len);
+		if (ret) {
+			pr_err("Error reserving initrd memory: %s\n",
+			       fdt_strerror(ret));
+			return -EINVAL;
+		}
+	}
+
+	if (cmdline != NULL) {
+		ret = fdt_setprop_string(fdt, chosen_node, "bootargs", cmdline);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+	} else {
+		ret = fdt_delprop(fdt, chosen_node, "bootargs");
+		if (ret && ret != -FDT_ERR_NOTFOUND) {
+			pr_err("Error deleting bootargs.\n");
+			return -EINVAL;
+		}
+	}
+
+	ret = fdt_setprop(fdt, chosen_node, "linux,booted-from-kexec", NULL, 0);
+	if (ret) {
+		pr_err("Error setting up the new device tree.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * find_debug_console() - find out whether there is a console for the purgatory
+ * @fdt:		Flattened device tree to search.
+ */
+bool find_debug_console(const void *fdt)
+{
+	int len;
+	int console_node, chosen_node;
+	const void *prop, *colon;
+
+	chosen_node = fdt_path_offset(fdt, "/chosen");
+	if (chosen_node < 0) {
+		pr_err("Malformed device tree: /chosen not found.\n");
+		return false;
+	}
+
+	prop = fdt_getprop(fdt, chosen_node, "stdout-path", &len);
+	if (prop == NULL) {
+		if (len == -FDT_ERR_NOTFOUND) {
+			prop = fdt_getprop(fdt, chosen_node,
+					   "linux,stdout-path", &len);
+			if (prop == NULL) {
+				pr_debug("Unable to find [linux,]stdout-path.\n");
+				return false;
+			}
+		} else {
+			pr_debug("Error finding console: %s\n",
+				 fdt_strerror(len));
+			return false;
+		}
+	}
+
+	/*
+	 * stdout-path can have a ':' separating the path from device-specific
+	 * information, so we should only consider what's before it.
+	 */
+	colon = strchr(prop, ':');
+	if (colon != NULL)
+		len = colon - prop;
+	else
+		len -= 1;	/* Ignore the terminating NUL. */
+
+	console_node = fdt_path_offset_namelen(fdt, prop, len);
+	if (console_node < 0) {
+		pr_debug("Error finding console: %s\n",
+			 fdt_strerror(console_node));
+		return false;
+	}
+
+	if (fdt_node_check_compatible(fdt, console_node, "hvterm1") == 0)
+		return true;
+	else if (fdt_node_check_compatible(fdt, console_node,
+					   "hvterm-protocol") == 0)
+		return true;
+
+	return false;
+}
+
 #endif /* CONFIG_KEXEC_FILE */
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
kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

