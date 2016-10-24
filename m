From: akpm@linux-foundation.org
Subject: +
 powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch added
 to -mm tree
Date: Mon, 24 Oct 2016 12:42:45 -0700
Message-ID: <580e6435.wU6vN5iC9SvL72oC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56675 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935267AbcJXTmq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: ima: get the kexec buffer passed by the previous kernel
has been added to the -mm tree.  Its filename is
     powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch

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
Subject: powerpc: ima: get the kexec buffer passed by the previous kernel

Patch series "ima: carry the measurement list across kexec", v6.

The TPM PCRs are only reset on a hard reboot.  In order to validate a
TPM's quote after a soft reboot (eg.  kexec -e), the IMA measurement list
of the running kernel must be saved and then restored on the subsequent
boot, possibly of a different architecture.

The existing securityfs binary_runtime_measurements file conveniently
provides a serialized format of the IMA measurement list.  This patch set
serializes the measurement list in this format and restores it.

Up to now, the binary_runtime_measurements was defined as architecture
native format.  The assumption being that userspace could and would handle
any architecture conversions.  With the ability of carrying the
measurement list across kexec, possibly from one architecture to a
different one, the per boot architecture information is lost and with it
the ability of recalculating the template digest hash.  To resolve this
problem, without breaking the existing ABI, this patch set introduces the
boot command line option "ima_canonical_fmt", which is arbitrarily defined
as little endian.

The need for this boot command line option will be limited to the
existing version 1 format of the binary_runtime_measurements.
Subsequent formats will be defined as canonical format (eg. TPM 2.0
support for larger digests).

A simplified method of Thiago Bauermann's "kexec buffer handover" patch
series for carrying the IMA measurement list across kexec is included
in this patch set.  The simplified method requires all file measurements
be taken prior to executing the kexec load, as subsequent measurements
will not be carried across the kexec and restored.



This patch (of 10):

The IMA kexec buffer allows the currently running kernel to pass the
measurement list via a kexec segment to the kernel that will be kexec'd. 
The second kernel can check whether the previous kernel sent the buffer
and retrieve it.

This is the architecture-specific part which enables IMA to receive the
measurement list passed by the previous kernel.  It will be used in the
next patch.

The change in machine_kexec_64.c is to factor out the logic of removing
an FDT memory reservation so that it can be used by remove_ima_buffer.

Link: http://lkml.kernel.org/r/1477017898-10375-2-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                                |    3 
 arch/powerpc/Kconfig                        |    1 
 arch/powerpc/include/asm/ima.h              |   13 +
 arch/powerpc/include/asm/kexec.h            |    1 
 arch/powerpc/kernel/Makefile                |    4 
 arch/powerpc/kernel/ima_kexec.c             |  132 ++++++++++++++++++
 arch/powerpc/kernel/machine_kexec_file_64.c |    5 
 7 files changed, 158 insertions(+), 1 deletion(-)

diff -puN arch/Kconfig~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel arch/Kconfig
--- a/arch/Kconfig~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel
+++ a/arch/Kconfig
@@ -5,6 +5,9 @@
 config KEXEC_CORE
 	bool
 
+config HAVE_IMA_KEXEC
+	bool
+
 config OPROFILE
 	tristate "OProfile system profiling"
 	depends on PROFILING
diff -puN arch/powerpc/Kconfig~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel
+++ a/arch/powerpc/Kconfig
@@ -458,6 +458,7 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
+	select HAVE_IMA_KEXEC
 	select BUILD_BIN2C
 	depends on PPC64
 	depends on CRYPTO=y
diff -puN /dev/null arch/powerpc/include/asm/ima.h
--- /dev/null
+++ a/arch/powerpc/include/asm/ima.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_POWERPC_IMA_H
+#define _ASM_POWERPC_IMA_H
+
+int ima_get_kexec_buffer(void **addr, size_t *size);
+int ima_free_kexec_buffer(void);
+
+#ifdef CONFIG_IMA
+void remove_ima_buffer(void *fdt, int chosen_node);
+#else
+static inline void remove_ima_buffer(void *fdt, int chosen_node) {}
+#endif
+
+#endif /* _ASM_POWERPC_IMA_H */
diff -puN arch/powerpc/include/asm/kexec.h~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel
+++ a/arch/powerpc/include/asm/kexec.h
@@ -101,6 +101,7 @@ int setup_purgatory(struct kimage *image
 int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
 		  unsigned long initrd_len, const char *cmdline);
 bool find_debug_console(const void *fdt);
+int delete_fdt_mem_rsv(void *fdt, unsigned long start, unsigned long size);
 #endif /* CONFIG_KEXEC_FILE */
 
 #else /* !CONFIG_KEXEC_CORE */
diff -puN arch/powerpc/kernel/Makefile~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel
+++ a/arch/powerpc/kernel/Makefile
@@ -111,6 +111,10 @@ obj-$(CONFIG_KEXEC_CORE)	+= machine_kexe
 				   machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file_$(BITS).o elf_util.o \
 				   kexec_elf_$(BITS).o
+ifeq ($(CONFIG_HAVE_IMA_KEXEC)$(CONFIG_IMA),yy)
+obj-y				+= ima_kexec.o
+endif
+
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
diff -puN /dev/null arch/powerpc/kernel/ima_kexec.c
--- /dev/null
+++ a/arch/powerpc/kernel/ima_kexec.c
@@ -0,0 +1,132 @@
+/*
+ * Copyright (C) 2016 IBM Corporation
+ *
+ * Authors:
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/of.h>
+#include <linux/memblock.h>
+#include <linux/libfdt.h>
+
+static int get_addr_size_cells(int *addr_cells, int *size_cells)
+{
+	struct device_node *root;
+
+	root = of_find_node_by_path("/");
+	if (!root)
+		return -EINVAL;
+
+	*addr_cells = of_n_addr_cells(root);
+	*size_cells = of_n_size_cells(root);
+
+	of_node_put(root);
+
+	return 0;
+}
+
+static int do_get_kexec_buffer(const void *prop, int len, unsigned long *addr,
+			       size_t *size)
+{
+	int ret, addr_cells, size_cells;
+
+	ret = get_addr_size_cells(&addr_cells, &size_cells);
+	if (ret)
+		return ret;
+
+	if (len < 4 * (addr_cells + size_cells))
+		return -ENOENT;
+
+	*addr = of_read_number(prop, addr_cells);
+	*size = of_read_number(prop + 4 * addr_cells, size_cells);
+
+	return 0;
+}
+
+/**
+ * ima_get_kexec_buffer - get IMA buffer from the previous kernel
+ * @addr:	On successful return, set to point to the buffer contents.
+ * @size:	On successful return, set to the buffer size.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int ima_get_kexec_buffer(void **addr, size_t *size)
+{
+	int ret, len;
+	unsigned long tmp_addr;
+	size_t tmp_size;
+	const void *prop;
+
+	prop = of_get_property(of_chosen, "linux,ima-kexec-buffer", &len);
+	if (!prop)
+		return -ENOENT;
+
+	ret = do_get_kexec_buffer(prop, len, &tmp_addr, &tmp_size);
+	if (ret)
+		return ret;
+
+	*addr = __va(tmp_addr);
+	*size = tmp_size;
+
+	return 0;
+}
+
+/**
+ * ima_free_kexec_buffer - free memory used by the IMA buffer
+ */
+int ima_free_kexec_buffer(void)
+{
+	int ret;
+	unsigned long addr;
+	size_t size;
+	struct property *prop;
+
+	prop = of_find_property(of_chosen, "linux,ima-kexec-buffer", NULL);
+	if (!prop)
+		return -ENOENT;
+
+	ret = do_get_kexec_buffer(prop->value, prop->length, &addr, &size);
+	if (ret)
+		return ret;
+
+	ret = of_remove_property(of_chosen, prop);
+	if (ret)
+		return ret;
+
+	return memblock_free(addr, size);
+
+}
+
+/**
+ * remove_ima_buffer - remove the IMA buffer property and reservation from @fdt
+ *
+ * The IMA measurement buffer is of no use to a subsequent kernel, so we always
+ * remove it from the device tree.
+ */
+void remove_ima_buffer(void *fdt, int chosen_node)
+{
+	int ret, len;
+	unsigned long addr;
+	size_t size;
+	const void *prop;
+
+	prop = fdt_getprop(fdt, chosen_node, "linux,ima-kexec-buffer", &len);
+	if (!prop)
+		return;
+
+	ret = do_get_kexec_buffer(prop, len, &addr, &size);
+	fdt_delprop(fdt, chosen_node, "linux,ima-kexec-buffer");
+	if (ret)
+		return;
+
+	ret = delete_fdt_mem_rsv(fdt, addr, size);
+	if (!ret)
+		pr_debug("Removed old IMA buffer reservation.\n");
+}
diff -puN arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel arch/powerpc/kernel/machine_kexec_file_64.c
--- a/arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel
+++ a/arch/powerpc/kernel/machine_kexec_file_64.c
@@ -28,6 +28,7 @@
 #include <linux/of_fdt.h>
 #include <linux/libfdt.h>
 #include <asm/elf_util.h>
+#include <asm/ima.h>
 
 #define SLAVE_CODE_SIZE		256
 
@@ -363,7 +364,7 @@ int setup_purgatory(struct kimage *image
  *
  * Return: 0 on success, or negative errno on error.
  */
-static int delete_fdt_mem_rsv(void *fdt, unsigned long start, unsigned long size)
+int delete_fdt_mem_rsv(void *fdt, unsigned long start, unsigned long size)
 {
 	int i, ret, num_rsvs = fdt_num_mem_rsv(fdt);
 
@@ -511,6 +512,8 @@ int setup_new_fdt(void *fdt, unsigned lo
 		}
 	}
 
+	remove_ima_buffer(fdt, chosen_node);
+
 	ret = fdt_setprop(fdt, chosen_node, "linux,booted-from-kexec", NULL, 0);
 	if (ret) {
 		pr_err("Error setting up the new device tree.\n");
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-in-module_64c.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

