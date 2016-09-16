From: akpm@linux-foundation.org
Subject: +
 kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch added to
 -mm tree
Date: Fri, 16 Sep 2016 16:19:15 -0700
Message-ID: <57dc7df3.lniY7lk0D5ZhlA2q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59081 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbcIPXTR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: add buffer hand-over support for the next kernel
has been added to the -mm tree.  Its filename is
     kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch

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
Subject: kexec_file: add buffer hand-over support for the next kernel

The buffer hand-over mechanism allows the currently running kernel to pass
data to kernel that will be kexec'd via a kexec segment.  The second
kernel can check whether the previous kernel sent data and retrieve it.

This is the architecture-independent part of the feature.

Link: http://lkml.kernel.org/r/1473900890-1476-3-git-send-email-bauerman@linux.vnet.ibm.com
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

 include/linux/kexec.h |   31 ++++++++++++++++++
 kernel/kexec_file.c   |   68 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN include/linux/kexec.h~kexec_file-add-buffer-hand-over-support-for-the-next-kernel include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/include/linux/kexec.h
@@ -389,6 +389,37 @@ static inline void *boot_phys_to_virt(un
 	return phys_to_virt(boot_phys_to_phys(entry));
 }
 
+#ifdef CONFIG_KEXEC_FILE
+bool __weak kexec_can_hand_over_buffer(void);
+int __weak arch_kexec_add_handover_buffer(struct kimage *image,
+					  unsigned long load_addr,
+					  unsigned long size);
+int kexec_add_handover_buffer(struct kexec_buf *kbuf);
+int __weak kexec_get_handover_buffer(void **addr, unsigned long *size);
+int __weak kexec_free_handover_buffer(void);
+#else
+struct kexec_buf;
+
+static inline bool kexec_can_hand_over_buffer(void)
+{
+	return false;
+}
+
+static inline int kexec_add_handover_buffer(struct kexec_buf *kbuf)
+{
+	return -ENOTSUPP;
+}
+
+static inline int kexec_get_handover_buffer(void **addr, unsigned long *size)
+{
+	return -ENOTSUPP;
+}
+
+static inline int kexec_free_handover_buffer(void)
+{
+	return -ENOTSUPP;
+}
+#endif /* CONFIG_KEXEC_FILE */
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
diff -puN kernel/kexec_file.c~kexec_file-add-buffer-hand-over-support-for-the-next-kernel kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/kernel/kexec_file.c
@@ -116,6 +116,74 @@ void kimage_file_post_load_cleanup(struc
 	image->image_loader_data = NULL;
 }
 
+/**
+ * kexec_can_hand_over_buffer() - can we pass data to the kexec'd kernel?
+ */
+bool __weak kexec_can_hand_over_buffer(void)
+{
+	return false;
+}
+
+/**
+ * arch_kexec_add_handover_buffer() - do arch-specific steps to handover buffer
+ *
+ * Architectures should use this function to pass on the handover buffer
+ * information to the next kernel.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int __weak arch_kexec_add_handover_buffer(struct kimage *image,
+					  unsigned long load_addr,
+					  unsigned long size)
+{
+	return -ENOTSUPP;
+}
+
+/**
+ * kexec_add_handover_buffer() - add buffer to be used by the next kernel
+ * @kbuf:	Buffer contents and memory parameters.
+ *
+ * This function assumes that kexec_mutex is held.
+ * On successful return, @kbuf->mem will have the physical address of
+ * the buffer in the next kernel.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int kexec_add_handover_buffer(struct kexec_buf *kbuf)
+{
+	int ret;
+
+	if (!kexec_can_hand_over_buffer())
+		return -ENOTSUPP;
+
+	ret = kexec_add_buffer(kbuf);
+	if (ret)
+		return ret;
+
+	return arch_kexec_add_handover_buffer(kbuf->image, kbuf->mem,
+					      kbuf->memsz);
+}
+
+/**
+ * kexec_get_handover_buffer() - get handover buffer from the previous kernel
+ * @addr:	On successful return, set to point to the buffer contents.
+ * @size:	On successful return, set to the buffer size.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int __weak kexec_get_handover_buffer(void **addr, unsigned long *size)
+{
+	return -ENOTSUPP;
+}
+
+/**
+ * kexec_free_handover_buffer() - free memory used by the handover buffer
+ */
+int __weak kexec_free_handover_buffer(void)
+{
+	return -ENOTSUPP;
+}
+
 /*
  * In file mode list of segments is prepared by kernel. Copy relevant
  * data from user space, do error checking, prepare segment list
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

