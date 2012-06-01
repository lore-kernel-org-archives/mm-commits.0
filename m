From: akpm@linux-foundation.org
Subject: [merged] kexec-export-kexech-to-user-space.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:32 -0700
Message-ID: <20120601193432.7A6D0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49326 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:33 -0400
Received: by ggeh3 with SMTP id h3so246087gge.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, ebiederm@xmission.com, hbabu@us.ibm.com, horms@verge.net.au, schwidefsky@de.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export kexec.h to user space
has been removed from the -mm tree.  Its filename was
     kexec-export-kexech-to-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: maximilian attems <max@stro.at>
Subject: kexec: export kexec.h to user space

Add userspace definitions, guard all relevant kernel structures.  While at
it document stuff and remove now useless userspace hint.

It is easy to add the relevant system call to respective libc's, but it
seems pointless to have to duplicate the data structures.

This is based on the kexec-tools headers, with the exception of just using
int on return (succes or failure) and using size_t instead of 'unsigned
long int' for the number of segments argument of kexec_load().

Signed-off-by: maximilian attems <max@stro.at>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild  |    1 
 include/linux/kexec.h |   75 ++++++++++++++++++++++++++++------------
 2 files changed, 54 insertions(+), 22 deletions(-)

diff -puN include/linux/Kbuild~kexec-export-kexech-to-user-space include/linux/Kbuild
--- a/include/linux/Kbuild~kexec-export-kexech-to-user-space
+++ a/include/linux/Kbuild
@@ -226,6 +226,7 @@ header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
 header-y += kernel-page-flags.h
+header-y += kexec.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
diff -puN include/linux/kexec.h~kexec-export-kexech-to-user-space include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-export-kexech-to-user-space
+++ a/include/linux/kexec.h
@@ -1,8 +1,58 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
-#ifdef CONFIG_KEXEC
+/* kexec system call -  It loads the new kernel to boot into.
+ * kexec does not sync, or unmount filesystems so if you need
+ * that to happen you need to do that yourself.
+ */
+
 #include <linux/types.h>
+
+/* kexec flags for different usage scenarios */
+#define KEXEC_ON_CRASH		0x00000001
+#define KEXEC_PRESERVE_CONTEXT	0x00000002
+#define KEXEC_ARCH_MASK		0xffff0000
+
+/* These values match the ELF architecture values.
+ * Unless there is a good reason that should continue to be the case.
+ */
+#define KEXEC_ARCH_DEFAULT ( 0 << 16)
+#define KEXEC_ARCH_386     ( 3 << 16)
+#define KEXEC_ARCH_X86_64  (62 << 16)
+#define KEXEC_ARCH_PPC     (20 << 16)
+#define KEXEC_ARCH_PPC64   (21 << 16)
+#define KEXEC_ARCH_IA_64   (50 << 16)
+#define KEXEC_ARCH_ARM     (40 << 16)
+#define KEXEC_ARCH_S390    (22 << 16)
+#define KEXEC_ARCH_SH      (42 << 16)
+#define KEXEC_ARCH_MIPS_LE (10 << 16)
+#define KEXEC_ARCH_MIPS    ( 8 << 16)
+
+/* The artificial cap on the number of segments passed to kexec_load. */
+#define KEXEC_SEGMENT_MAX 16
+
+#ifndef __KERNEL__
+/*
+ * This structure is used to hold the arguments that are used when
+ * loading  kernel binaries.
+ */
+struct kexec_segment {
+	const void *buf;
+	size_t bufsz;
+	const void *mem;
+	size_t memsz;
+};
+
+/* Load a new kernel image as described by the kexec_segment array
+ * consisting of passed number of segments at the entry-point address.
+ * The flags allow different useage types.
+ */
+extern int kexec_load(void *, size_t, struct kexec_segment *,
+		unsigned long int);
+#endif /* __KERNEL__ */
+
+#ifdef __KERNEL__
+#ifdef CONFIG_KEXEC
 #include <linux/list.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
@@ -67,11 +117,10 @@ typedef unsigned long kimage_entry_t;
 #define IND_DONE         0x4
 #define IND_SOURCE       0x8
 
-#define KEXEC_SEGMENT_MAX 16
 struct kexec_segment {
 	void __user *buf;
 	size_t bufsz;
-	unsigned long mem;	/* User space sees this as a (void *) ... */
+	unsigned long mem;
 	size_t memsz;
 };
 
@@ -175,25 +224,6 @@ extern struct kimage *kexec_crash_image;
 #define kexec_flush_icache_page(page)
 #endif
 
-#define KEXEC_ON_CRASH		0x00000001
-#define KEXEC_PRESERVE_CONTEXT	0x00000002
-#define KEXEC_ARCH_MASK		0xffff0000
-
-/* These values match the ELF architecture values.
- * Unless there is a good reason that should continue to be the case.
- */
-#define KEXEC_ARCH_DEFAULT ( 0 << 16)
-#define KEXEC_ARCH_386     ( 3 << 16)
-#define KEXEC_ARCH_X86_64  (62 << 16)
-#define KEXEC_ARCH_PPC     (20 << 16)
-#define KEXEC_ARCH_PPC64   (21 << 16)
-#define KEXEC_ARCH_IA_64   (50 << 16)
-#define KEXEC_ARCH_ARM     (40 << 16)
-#define KEXEC_ARCH_S390    (22 << 16)
-#define KEXEC_ARCH_SH      (42 << 16)
-#define KEXEC_ARCH_MIPS_LE (10 << 16)
-#define KEXEC_ARCH_MIPS    ( 8 << 16)
