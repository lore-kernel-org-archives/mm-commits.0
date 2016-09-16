From: akpm@linux-foundation.org
Subject: + ima-on-soft-reboot-save-the-measurement-list.patch added to -mm tree
Date: Fri, 16 Sep 2016 16:22:34 -0700
Message-ID: <57dc7eba.BveS319QImzxuuRI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754490AbcIPXWg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: on soft reboot, save the measurement list
has been added to the -mm tree.  Its filename is
     ima-on-soft-reboot-save-the-measurement-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-on-soft-reboot-save-the-measurement-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-on-soft-reboot-save-the-measurement-list.patch

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
Subject: ima: on soft reboot, save the measurement list

This patch uses the kexec buffer passing mechanism to pass the serialized
IMA binary_runtime_measurements to the next kernel.

Link: http://lkml.kernel.org/r/1473938771-2782-6-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
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

 include/linux/ima.h                |   12 +++
 kernel/kexec_file.c                |    4 +
 security/integrity/ima/ima_kexec.c |   96 +++++++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff -puN include/linux/ima.h~ima-on-soft-reboot-save-the-measurement-list include/linux/ima.h
--- a/include/linux/ima.h~ima-on-soft-reboot-save-the-measurement-list
+++ a/include/linux/ima.h
@@ -11,6 +11,7 @@
 #define _LINUX_IMA_H
 
 #include <linux/fs.h>
+#include <linux/kexec.h>
 struct linux_binprm;
 
 #ifdef CONFIG_IMA
@@ -23,6 +24,10 @@ extern int ima_post_read_file(struct fil
 			      enum kernel_read_file_id id);
 extern void ima_post_path_mknod(struct dentry *dentry);
 
+#ifdef CONFIG_IMA_KEXEC
+extern void ima_add_kexec_buffer(struct kimage *image);
+#endif
+
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
 {
@@ -62,6 +67,13 @@ static inline void ima_post_path_mknod(s
 
 #endif /* CONFIG_IMA */
 
+#ifndef CONFIG_IMA_KEXEC
+struct kimage;
+
+static inline void ima_add_kexec_buffer(struct kimage *image)
+{}
+#endif
+
 #ifdef CONFIG_IMA_APPRAISE
 extern void ima_inode_post_setattr(struct dentry *dentry);
 extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
diff -puN kernel/kexec_file.c~ima-on-soft-reboot-save-the-measurement-list kernel/kexec_file.c
--- a/kernel/kexec_file.c~ima-on-soft-reboot-save-the-measurement-list
+++ a/kernel/kexec_file.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <linux/fs.h>
+#include <linux/ima.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <linux/syscalls.h>
@@ -204,6 +205,9 @@ kimage_file_prepare_segments(struct kima
 		return ret;
 	image->kernel_buf_len = size;
 
+	/* IMA needs to pass the measurement list to the next kernel. */
+	ima_add_kexec_buffer(image);
+
 	/* Call arch image probe handlers */
 	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
 					    image->kernel_buf_len);
diff -puN security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list security/integrity/ima/ima_kexec.c
--- a/security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list
+++ a/security/integrity/ima/ima_kexec.c
@@ -23,6 +23,11 @@
 
 #include "ima.h"
 
+#ifdef CONFIG_IMA_KEXEC
+/* Physical address of the measurement buffer in the next kernel. */
+static unsigned long kexec_buffer_load_addr;
+static size_t kexec_segment_size;
+
 static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 				     unsigned long segment_size)
 {
@@ -75,6 +80,97 @@ out:
 }
 
 /*
+ * Called during kexec execute so that IMA can save the measurement list.
+ */
+static int ima_update_kexec_buffer(struct notifier_block *self,
+				   unsigned long action, void *data)
+{
+	void *kexec_buffer = NULL;
+	size_t kexec_buffer_size;
+	int ret;
+
+	if (!kexec_in_progress)
+		return NOTIFY_OK;
+
+	kexec_buffer_size = ima_get_binary_runtime_size();
+	if (kexec_buffer_size > kexec_segment_size) {
+		pr_err("Binary measurement list grew too large.\n");
+		goto out;
+	}
+
+	ima_dump_measurement_list(&kexec_buffer_size, &kexec_buffer,
+				  kexec_segment_size);
+	if (!kexec_buffer) {
+		pr_err("Not enough memory for the kexec measurement buffer.\n");
+		goto out;
+	}
+	ret = kexec_update_segment(kexec_buffer, kexec_buffer_size,
+				   kexec_buffer_load_addr, kexec_segment_size);
+	if (ret)
+		pr_err("Error updating kexec buffer: %d\n", ret);
+out:
+	return NOTIFY_OK;
+}
+
+struct notifier_block update_buffer_nb = {
+	.notifier_call = ima_update_kexec_buffer,
+};
+
+/*
+ * Called during kexec_file_load so that IMA can add a segment to the kexec
+ * image for the measurement list for the next kernel.
+ */
+void ima_add_kexec_buffer(struct kimage *image)
+{
+	static int registered;
+	struct kexec_buf kbuf = { .image = image, .buf_align = PAGE_SIZE,
+				  .buf_min = 0, .buf_max = ULONG_MAX,
+				  .top_down = true };
+	unsigned long binary_runtime_size;
+	int ret;
+
+	if (!kexec_can_hand_over_buffer())
+		return;
+
+	/*
+	 * Reserve at least an extra half page of memory for additional
+	 * measurements between kexec load and execute.
+	 */
+	binary_runtime_size = ima_get_binary_runtime_size();
+	if (binary_runtime_size >= ULONG_MAX - PAGE_SIZE)
+		kexec_segment_size = ULONG_MAX;
+	else
+		kexec_segment_size = ALIGN(ima_get_binary_runtime_size() +
+					   PAGE_SIZE / 2, PAGE_SIZE);
+	if ((kexec_segment_size == ULONG_MAX) ||
+	    ((kexec_segment_size >> PAGE_SHIFT) > totalram_pages / 2)) {
+		pr_err("Binary measurement list too large.\n");
+		return;
+	}
+
+	/* Ask not to checksum the segment, we will update it later. */
+	kbuf.buffer = NULL;
+	kbuf.bufsz = 0;
+	kbuf.memsz = kexec_segment_size;
+	ret = kexec_add_handover_buffer(&kbuf);
+	if (ret) {
+		pr_err("Error passing over kexec measurement buffer.\n");
+		return;
+	}
+	kexec_buffer_load_addr = kbuf.mem;
+
+	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
+		 kexec_buffer_load_addr);
+
+	if (registered)
+		return;
+
+	register_reboot_notifier(&update_buffer_nb);
+	registered = 1;
+}
+#endif /* IMA_KEXEC */
+
+/*
  * Restore the measurement list from the previous kernel.
  */
 void ima_load_kexec_buffer(void)
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
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

