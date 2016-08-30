From: akpm@linux-foundation.org
Subject: + ima-demonstration-code-for-kexec-buffer-passing.patch added to
 -mm tree
Date: Tue, 30 Aug 2016 14:57:54 -0700
Message-ID: <57c60162.yJQ9L6MtFFIMoypY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbcH3V54 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 17:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IMA: demonstration code for kexec buffer passing
has been added to the -mm tree.  Its filename is
     ima-demonstration-code-for-kexec-buffer-passing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-demonstration-code-for-kexec-buffer-passing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-demonstration-code-for-kexec-buffer-passing.patch

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
Subject: IMA: demonstration code for kexec buffer passing

This shows how kernel code can use the kexec buffer passing mechanism
to pass information to the next kernel.

This patch is not intended to be committed.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1472579105-26296-6-git-send-email-bauerman@linux.vnet.ibm.com
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

 include/linux/ima.h                   |   11 +++
 kernel/kexec_file.c                   |    4 +
 security/integrity/ima/ima.h          |    5 +
 security/integrity/ima/ima_init.c     |   26 +++++++
 security/integrity/ima/ima_template.c |   85 ++++++++++++++++++++++++
 5 files changed, 131 insertions(+)

diff -puN include/linux/ima.h~ima-demonstration-code-for-kexec-buffer-passing include/linux/ima.h
--- a/include/linux/ima.h~ima-demonstration-code-for-kexec-buffer-passing
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
 
+#ifdef CONFIG_KEXEC_FILE
+extern void ima_add_kexec_buffer(struct kimage *image);
+#endif
+
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
 {
@@ -60,6 +65,12 @@ static inline void ima_post_path_mknod(s
 	return;
 }
 
+#ifdef CONFIG_KEXEC_FILE
+static inline void ima_add_kexec_buffer(struct kimage *image)
+{
+}
+#endif
+
 #endif /* CONFIG_IMA */
 
 #ifdef CONFIG_IMA_APPRAISE
diff -puN kernel/kexec_file.c~ima-demonstration-code-for-kexec-buffer-passing kernel/kexec_file.c
--- a/kernel/kexec_file.c~ima-demonstration-code-for-kexec-buffer-passing
+++ a/kernel/kexec_file.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/fs.h>
+#include <linux/ima.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <linux/syscalls.h>
@@ -248,6 +249,9 @@ kimage_file_prepare_segments(struct kima
 		}
 	}
 
+	/* IMA needs to pass the measurement list to the next kernel. */
+	ima_add_kexec_buffer(image);
+
 	/* Call arch image load handlers */
 	ldata = arch_kexec_kernel_image_load(image);
 
diff -puN security/integrity/ima/ima.h~ima-demonstration-code-for-kexec-buffer-passing security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-demonstration-code-for-kexec-buffer-passing
+++ a/security/integrity/ima/ima.h
@@ -102,6 +102,11 @@ struct ima_queue_entry {
 };
 extern struct list_head ima_measurements;	/* list of all measurements */
 
+#ifdef CONFIG_KEXEC_FILE
+extern void *kexec_buffer;
+extern size_t kexec_buffer_size;
+#endif
+
 /* Internal IMA function definitions */
 int ima_init(void);
 int ima_fs_init(void);
diff -puN security/integrity/ima/ima_init.c~ima-demonstration-code-for-kexec-buffer-passing security/integrity/ima/ima_init.c
--- a/security/integrity/ima/ima_init.c~ima-demonstration-code-for-kexec-buffer-passing
+++ a/security/integrity/ima/ima_init.c
@@ -21,6 +21,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/kexec.h>
 
 #include "ima.h"
 
@@ -104,6 +105,29 @@ void __init ima_load_x509(void)
 }
 #endif
 
+#ifdef CONFIG_KEXEC_FILE
+static void ima_load_kexec_buffer(void)
+{
+	int rc;
+
+	/* Fetch the buffer from the previous kernel, if any. */
+	rc = kexec_get_handover_buffer(&kexec_buffer, &kexec_buffer_size);
+	if (rc == 0) {
+		/* Demonstrate that buffer handover works. */
+		pr_err("kexec buffer contents: %s\n", (char *) kexec_buffer);
+		pr_err("kexec buffer contents after update: %s\n",
+		       (char *) kexec_buffer + 4 * PAGE_SIZE + 10);
+
+		kexec_free_handover_buffer();
+	} else if (rc == -ENOENT)
+		pr_debug("No kexec buffer from the previous kernel.\n");
+	else
+		pr_debug("Error restoring kexec buffer: %d\n", rc);
+}
+#else
+static void ima_load_kexec_buffer(void) { }
+#endif
+
 int __init ima_init(void)
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
@@ -134,5 +158,7 @@ int __init ima_init(void)
 
 	ima_init_policy();
 
+	ima_load_kexec_buffer();
+
 	return ima_fs_init();
 }
diff -puN security/integrity/ima/ima_template.c~ima-demonstration-code-for-kexec-buffer-passing security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-demonstration-code-for-kexec-buffer-passing
+++ a/security/integrity/ima/ima_template.c
@@ -15,6 +15,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kexec.h>
+#include <linux/reboot.h>
 #include "ima.h"
 #include "ima_template_lib.h"
 
@@ -182,6 +184,89 @@ static int template_desc_init_fields(con
 	return 0;
 }
 
+#ifdef CONFIG_KEXEC_FILE
+void *kexec_buffer;
+size_t kexec_buffer_size;
+
+/* Physical address of the measurement buffer in the next kernel. */
+unsigned long kexec_buffer_load_addr;
+
+/*
+ * Called during reboot. IMA can add here new events that were generated after
+ * the kexec image was loaded.
+ */
+static int ima_update_kexec_buffer(struct notifier_block *self,
+				   unsigned long action, void *data)
+{
+	int ret;
+
+	if (!kexec_in_progress)
+		return NOTIFY_OK;
+
+	/*
+	 * Add content deep in the buffer to show that we can update
+	 * all of it.
+	 */
+	strcpy(kexec_buffer + 4 * PAGE_SIZE + 10,
+	       "Updated kexec buffer contents.");
+
+	ret = kexec_update_segment(kexec_buffer, kexec_buffer_size,
+				   kexec_buffer_load_addr, kexec_buffer_size);
+	if (ret)
+		pr_err("Error updating kexec buffer: %d\n", ret);
+
+	return NOTIFY_OK;
+}
+
+struct notifier_block update_buffer_nb = {
+	.notifier_call = ima_update_kexec_buffer,
+};
+
+/*
+ * Called during kexec_file_load so that IMA can add a segment to the kexec
+ * image with the measurement event log for the next kernel.
+ */
+void ima_add_kexec_buffer(struct kimage *image)
+{
+	/* Ask not to checksum the segment, we may have to update it later. */
+	struct kexec_buf kbuf = { .image = image, .buf_align = PAGE_SIZE,
+				  .buf_min = 0, .buf_max = ULONG_MAX,
+				  .top_down = true, .skip_checksum = true };
+	bool first_kexec_load = kexec_buffer_load_addr == 0;
+	int ret;
+
+	if (!kexec_can_hand_over_buffer())
+		return;
+
+	if (!first_kexec_load)
+		kfree(kexec_buffer);
+
+	/* Create a relatively big buffer, for testing. */
+	kexec_buffer_size = kbuf.bufsz = kbuf.memsz = 5 * PAGE_SIZE;
+	kexec_buffer = kbuf.buffer = kzalloc(kexec_buffer_size, GFP_KERNEL);
+	if (!kexec_buffer) {
+		pr_err("Not enough memory for the kexec measurement buffer.\n");
+		return;
+	}
+
+	/* Add some content for demonstration purposes. */
+	strcpy(kexec_buffer, "Buffer contents at kexec load time.");
+
+	ret = kexec_add_handover_buffer(&kbuf);
+	if (ret) {
+		pr_err("Error passing over kexec measurement buffer.\n");
+		return;
+	}
+	kexec_buffer_load_addr = kbuf.mem;
+
+	if (first_kexec_load)
+		register_reboot_notifier(&update_buffer_nb);
+
+	pr_debug("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
+		 kexec_buffer_load_addr);
+}
+#endif /* CONFIG_KEXEC_FILE */
+
 struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
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

