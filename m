From: akpm@linux-foundation.org
Subject: + ima-on-soft-reboot-save-the-measurement-list.patch added to -mm tree
Date: Thu, 29 Sep 2016 16:15:19 -0700
Message-ID: <57eda087.pFVQJXFcTLGnBRXg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50159 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935043AbcI2XPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 19:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


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
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: on soft reboot, save the measurement list

The TPM PCRs are only reset on a hard reboot.  In order to validate a
TPM's quote after a soft reboot (eg.  kexec -e), the IMA measurement list
of the running kernel must be saved and restored on boot.

This patch uses the kexec buffer passing mechanism to pass the
serialized IMA binary_runtime_measurements to the next kernel.

Link: http://lkml.kernel.org/r/1474911029-6372-7-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ima.h                |   12 ++
 kernel/kexec_file.c                |    4 
 security/integrity/ima/ima.h       |    1 
 security/integrity/ima/ima_fs.c    |    2 
 security/integrity/ima/ima_kexec.c |  117 +++++++++++++++++++++++++++
 5 files changed, 135 insertions(+), 1 deletion(-)

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
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/fs.h>
+#include <linux/ima.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <linux/syscalls.h>
@@ -132,6 +133,9 @@ kimage_file_prepare_segments(struct kima
 		return ret;
 	image->kernel_buf_len = size;
 
+	/* IMA needs to pass the measurement list to the next kernel. */
+	ima_add_kexec_buffer(image);
+
 	/* Call arch image probe handlers */
 	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
 					    image->kernel_buf_len);
diff -puN security/integrity/ima/ima.h~ima-on-soft-reboot-save-the-measurement-list security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-on-soft-reboot-save-the-measurement-list
+++ a/security/integrity/ima/ima.h
@@ -143,6 +143,7 @@ void ima_print_digest(struct seq_file *m
 struct ima_template_desc *ima_template_desc_current(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
+int ima_measurements_show(struct seq_file *m, void *v);
 unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
 
diff -puN security/integrity/ima/ima_fs.c~ima-on-soft-reboot-save-the-measurement-list security/integrity/ima/ima_fs.c
--- a/security/integrity/ima/ima_fs.c~ima-on-soft-reboot-save-the-measurement-list
+++ a/security/integrity/ima/ima_fs.c
@@ -116,7 +116,7 @@ void ima_putc(struct seq_file *m, void *
  *       [eventdata length]
  *       eventdata[n]=template specific data
  */
-static int ima_measurements_show(struct seq_file *m, void *v)
+int ima_measurements_show(struct seq_file *m, void *v)
 {
 	/* the list never shrinks, so we don't need a lock here */
 	struct ima_queue_entry *qe = v;
diff -puN security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list security/integrity/ima/ima_kexec.c
--- a/security/integrity/ima/ima_kexec.c~ima-on-soft-reboot-save-the-measurement-list
+++ a/security/integrity/ima/ima_kexec.c
@@ -10,8 +10,125 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+#include <linux/seq_file.h>
+#include <linux/vmalloc.h>
+#include <linux/kexec.h>
 #include "ima.h"
 
+#ifdef CONFIG_IMA_KEXEC
+static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
+				     unsigned long segment_size)
+{
+	struct ima_queue_entry *qe;
+	struct seq_file file;
+	struct ima_kexec_hdr khdr = {
+		.version = 1, .buffer_size = 0, .count = 0};
+	int ret = 0;
+
+	/* segment size can't change between kexec load and execute */
+	file.buf = vmalloc(segment_size);
+	if (!file.buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	file.size = segment_size;
+	file.read_pos = 0;
+	file.count = sizeof(khdr);	/* reserved space */
+
+	list_for_each_entry_rcu(qe, &ima_measurements, later) {
+		if (file.count < file.size) {
+			khdr.count++;
+			ima_measurements_show(&file, qe);
+		} else {
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * fill in reserved space with some buffer details
+	 * (eg. version, buffer size, number of measurements)
+	 */
+	khdr.buffer_size = file.count;
+	memcpy(file.buf, &khdr, sizeof(khdr));
+	print_hex_dump(KERN_DEBUG, "ima dump: ", DUMP_PREFIX_NONE,
+			16, 1, file.buf,
+			file.count < 100 ? file.count : 100, true);
+
+	*buffer_size = file.count;
+	*buffer = file.buf;
+out:
+	if (ret == -EINVAL)
+		vfree(file.buf);
+	return ret;
+}
+
+/*
+ * Called during kexec_file_load so that IMA can add a segment to the kexec
+ * image for the measurement list for the next kernel.
+ *
+ * This function assumes that kexec_mutex is held.
+ */
+void ima_add_kexec_buffer(struct kimage *image)
+{
+	struct kexec_buf kbuf = { .image = image, .buf_align = PAGE_SIZE,
+				  .buf_min = 0, .buf_max = ULONG_MAX,
+				  .top_down = true };
+	unsigned long binary_runtime_size;
+
+	/* use more understandable variable names than defined in kbuf */
+	void *kexec_buffer = NULL;
+	size_t kexec_buffer_size;
+	size_t kexec_segment_size;
+	int ret;
+
+	/*
+	 * Reserve an extra half page of memory for additional measurements
+	 * added during the kexec load.
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
+	ima_dump_measurement_list(&kexec_buffer_size, &kexec_buffer,
+				  kexec_segment_size);
+	if (!kexec_buffer) {
+		pr_err("Not enough memory for the kexec measurement buffer.\n");
+		return;
+	}
+
+	kbuf.buffer = kexec_buffer;
+	kbuf.bufsz = kexec_buffer_size;
+	kbuf.memsz = kexec_segment_size;
+	ret = kexec_add_buffer(&kbuf);
+	if (ret) {
+		pr_err("Error passing over kexec measurement buffer.\n");
+		return;
+	}
+
+	ret = arch_ima_add_kexec_buffer(image, kbuf.mem, kexec_segment_size);
+	if (ret) {
+		pr_err("Error passing over kexec measurement buffer.\n");
+		return;
+	}
+
+	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
+		 kbuf.mem);
+}
+#endif /* IMA_KEXEC */
+
 /*
  * Restore the measurement list from the previous kernel.
  */
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-on-soft-reboot-save-the-measurement-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

