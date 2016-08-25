From: akpm@linux-foundation.org
Subject: +
 kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch added to
 -mm tree
Date: Thu, 25 Aug 2016 14:13:42 -0700
Message-ID: <57bf5f86.32zMdt3oIQjNl/fv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58421 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756306AbcHYVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


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

Patch series "kexec_file: Add buffer hand-over for the next kernel", v3.

This patch series implements a mechanism which allows the kernel to pass
on a buffer to the kernel that will be kexec'd.  This buffer is passed as
a segment which is added to the kimage when it is being prepared by
kexec_file_load.

How the second kernel is informed of this buffer is architecture-specific.
On powerpc, this is done via the device tree, by checking the properties
/chosen/linux,kexec-handover-buffer-start and
/chosen/linux,kexec-handover-buffer-end, which is analogous to how the
kernel finds the initrd.

This is needed because the Integrity Measurement Architecture subsystem
needs to preserve its measurement list accross the kexec reboot.  The
following patch series for the IMA subsystem uses this feature for that
purpose:

https://lists.infradead.org/pipermail/kexec/2016-August/016745.html

This is so that IMA can implement trusted boot support on the OpenPower
platform, because on such systems an intermediary Linux instance running
as part of the firmware is used to boot the target operating system via
kexec.  Using this mechanism, IMA on this intermediary instance can hand
over to the target OS the measurements of the components that were used to
boot it.

Because there could be additional measurement events between the
kexec_file_load call and the actual reboot, IMA needs a way to update the
buffer with those additional events before rebooting.  One can minimize
the interval between the kexec_file_load and the reboot syscalls, but as
small as it can be, there is always the possibility that the measurement
list will be out of date at the time of reboot.

To address this issue, this patch series also introduces
kexec_update_segment, which allows a reboot notifier to change the
contents of the image segment during the reboot process.

The last patch is not intended to be merged, it just demonstrates how this
feature can be used.


This patch (of 5):

The buffer hand-over mechanism allows the currently running kernel to pass
data to kernel that will be kexec'd via a kexec segment. The second kernel
can check whether the previous kernel sent data and retrieve it.

This is the architecture-independent part of the feature.

Link: http://lkml.kernel.org/r/1472149111-30598-2-git-send-email-bauerman@linux.vnet.ibm.com
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

 include/linux/kexec.h |   31 ++++++++++++++++++
 kernel/kexec_file.c   |   68 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN include/linux/kexec.h~kexec_file-add-buffer-hand-over-support-for-the-next-kernel include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-add-buffer-hand-over-support-for-the-next-kernel
+++ a/include/linux/kexec.h
@@ -383,6 +383,37 @@ static inline void *boot_phys_to_virt(un
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
@@ -113,6 +113,74 @@ void kimage_file_post_load_cleanup(struc
 	image->image_loader_data = NULL;
 }
 
+/**
+ * kexec_can_hand_over_buffer - can we pass data to the kexec'd kernel?
+ */
+bool __weak kexec_can_hand_over_buffer(void)
+{
+	return false;
+}
+
+/**
+ * arch_kexec_add_handover_buffer - do arch-specific steps to handover buffer
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
+ * kexec_add_handover_buffer - add buffer to be used by the next kernel
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
+ * kexec_get_handover_buffer - get the handover buffer from the previous kernel
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
+ * kexec_free_handover_buffer - free memory used by the handover buffer
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

