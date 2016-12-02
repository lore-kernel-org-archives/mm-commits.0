From: akpm@linux-foundation.org
Subject: [merged]
 kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
 removed from -mm tree
Date: Fri, 02 Dec 2016 15:45:37 -0800
Message-ID: <584207a1.stO6ofvlE3iO9lgv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753399AbcLBXpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: factor out kexec_locate_mem_hole from kexec_add_buffer
has been removed from the -mm tree.  Its filename was
     kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: kexec_file: factor out kexec_locate_mem_hole from kexec_add_buffer

kexec_locate_mem_hole will be used by the PowerPC kexec_file_load
implementation to find free memory for the purgatory stack.

Link: http://lkml.kernel.org/r/1480423554-6411-4-git-send-email-mpe@ellerman.id.au
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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

powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-add-support-code-for-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-kexec-enable-kexec_file_load-syscall.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

