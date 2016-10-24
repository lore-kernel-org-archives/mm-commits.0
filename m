From: akpm@linux-foundation.org
Subject: +
 kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
 added to -mm tree
Date: Mon, 24 Oct 2016 12:42:38 -0700
Message-ID: <580e642e.+dKvVFSHTtnPVmaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56675 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935267AbcJXTmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: factor out kexec_locate_mem_hole from kexec_add_buffer
has been added to the -mm tree.  Its filename is
     kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch

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
Subject: kexec_file: factor out kexec_locate_mem_hole from kexec_add_buffer

kexec_locate_mem_hole will be used by the PowerPC kexec_file_load
implementation to find free memory for the purgatory stack.

Link: http://lkml.kernel.org/r/1477017617-8540-4-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    1 +
 kernel/kexec_file.c   |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN include/linux/kexec.h~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer
+++ a/include/linux/kexec.h
@@ -176,6 +176,7 @@ struct kexec_buf {
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
 			       int (*func)(u64, u64, void *));
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
+int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 #endif /* CONFIG_KEXEC_FILE */
 
 struct kimage {
diff -puN kernel/kexec_file.c~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer
+++ a/kernel/kexec_file.c
@@ -450,6 +450,23 @@ int __weak arch_kexec_walk_mem(struct ke
 }
 
 /**
+ * kexec_locate_mem_hole - find free memory for the purgatory or the next kernel
+ * @kbuf:	Parameters for the memory search.
+ *
+ * On success, kbuf->mem will have the start address of the memory region found.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int kexec_locate_mem_hole(struct kexec_buf *kbuf)
+{
+	int ret;
+
+	ret = arch_kexec_walk_mem(kbuf, locate_mem_hole_callback);
+
+	return ret == 1 ? 0 : -EADDRNOTAVAIL;
+}
+
+/**
  * kexec_add_buffer - place a buffer in a kexec segment
  * @kbuf:	Buffer contents and memory parameters.
  *
@@ -489,11 +506,9 @@ int kexec_add_buffer(struct kexec_buf *k
 	kbuf->buf_align = max(kbuf->buf_align, PAGE_SIZE);
 
 	/* Walk the RAM ranges and allocate a suitable range for the buffer */
-	ret = arch_kexec_walk_mem(kbuf, locate_mem_hole_callback);
-	if (ret != 1) {
-		/* A suitable memory range could not be found for buffer */
-		return -EADDRNOTAVAIL;
-	}
+	ret = kexec_locate_mem_hole(kbuf);
+	if (ret)
+		return ret;
 
 	/* Found a suitable memory range */
 	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
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

