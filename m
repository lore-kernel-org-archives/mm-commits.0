From: akpm@linux-foundation.org
Subject: +
 kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch added to -mm tree
Date: Mon, 21 Dec 2015 15:28:02 -0800
Message-ID: <56788b02.CJhodpzR/Up1l9fq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbLUX2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 18:28:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: move some memembers and definitions within the scope of CONFIG_KEXEC_FILE
has been added to the -mm tree.  Its filename is
     kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: move some memembers and definitions within the scope of CONFIG_KEXEC_FILE

Move the stuff currently only used by the kexec file code within
CONFIG_KEXEC_FILE (and CONFIG_KEXEC_VERIFY_SIG).

Also move internal "struct kexec_sha_region" and "struct kexec_buf" into
"kexec_internal.h".

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    2 
 include/linux/kexec.h              |   62 ++++++++++-----------------
 kernel/kexec_file.c                |    2 
 kernel/kexec_internal.h            |   21 +++++++++
 4 files changed, 50 insertions(+), 37 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -385,6 +385,7 @@ int arch_kimage_file_post_load_cleanup(s
 	return image->fops->cleanup(image->image_loader_data);
 }
 
+#ifdef CONFIG_KEXEC_VERIFY_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *kernel,
 				 unsigned long kernel_len)
 {
@@ -395,6 +396,7 @@ int arch_kexec_kernel_verify_sig(struct
 
 	return image->fops->verify_sig(kernel, kernel_len);
 }
+#endif
 
 /*
  * Apply purgatory relocations.
diff -puN include/linux/kexec.h~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file
+++ a/include/linux/kexec.h
@@ -109,11 +109,7 @@ struct compat_kexec_segment {
 };
 #endif
 
-struct kexec_sha_region {
-	unsigned long start;
-	unsigned long len;
-};
-
+#ifdef CONFIG_KEXEC_FILE
 struct purgatory_info {
 	/* Pointer to elf header of read only purgatory */
 	Elf_Ehdr *ehdr;
@@ -130,6 +126,28 @@ struct purgatory_info {
 	unsigned long purgatory_load_addr;
 };
 
+typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
+typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
+			     unsigned long kernel_len, char *initrd,
+			     unsigned long initrd_len, char *cmdline,
+			     unsigned long cmdline_len);
+typedef int (kexec_cleanup_t)(void *loader_data);
+
+#ifdef CONFIG_KEXEC_VERIFY_SIG
+typedef int (kexec_verify_sig_t)(const char *kernel_buf,
+				 unsigned long kernel_len);
+#endif
+
+struct kexec_file_ops {
+	kexec_probe_t *probe;
+	kexec_load_t *load;
+	kexec_cleanup_t *cleanup;
+#ifdef CONFIG_KEXEC_VERIFY_SIG
+	kexec_verify_sig_t *verify_sig;
+#endif
+};
+#endif
+
 struct kimage {
 	kimage_entry_t head;
 	kimage_entry_t *entry;
@@ -161,6 +179,7 @@ struct kimage {
 	struct kimage_arch arch;
 #endif
 
+#ifdef CONFIG_KEXEC_FILE
 	/* Additional fields for file based kexec syscall */
 	void *kernel_buf;
 	unsigned long kernel_buf_len;
@@ -179,38 +198,7 @@ struct kimage {
 
 	/* Information for loading purgatory */
 	struct purgatory_info purgatory_info;
-};
-
-/*
- * Keeps track of buffer parameters as provided by caller for requesting
- * memory placement of buffer.
- */
-struct kexec_buf {
-	struct kimage *image;
-	char *buffer;
-	unsigned long bufsz;
-	unsigned long mem;
-	unsigned long memsz;
-	unsigned long buf_align;
-	unsigned long buf_min;
-	unsigned long buf_max;
-	bool top_down;		/* allocate from top of memory hole */
-};
-
-typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
-typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
-			     unsigned long kernel_len, char *initrd,
-			     unsigned long initrd_len, char *cmdline,
-			     unsigned long cmdline_len);
-typedef int (kexec_cleanup_t)(void *loader_data);
-typedef int (kexec_verify_sig_t)(const char *kernel_buf,
-				 unsigned long kernel_len);
-
-struct kexec_file_ops {
-	kexec_probe_t *probe;
-	kexec_load_t *load;
-	kexec_cleanup_t *cleanup;
-	kexec_verify_sig_t *verify_sig;
+#endif
 };
 
 /* kexec interface functions */
diff -puN kernel/kexec_file.c~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file
+++ a/kernel/kexec_file.c
@@ -109,11 +109,13 @@ int __weak arch_kimage_file_post_load_cl
 	return -EINVAL;
 }
 
+#ifdef CONFIG_KEXEC_VERIFY_SIG
 int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 					unsigned long buf_len)
 {
 	return -EKEYREJECTED;
 }
+#endif
 
 /* Apply relocations of type RELA */
 int __weak
diff -puN kernel/kexec_internal.h~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file kernel/kexec_internal.h
--- a/kernel/kexec_internal.h~kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file
+++ a/kernel/kexec_internal.h
@@ -15,6 +15,27 @@ int kimage_is_destination_range(struct k
 extern struct mutex kexec_mutex;
 
 #ifdef CONFIG_KEXEC_FILE
+struct kexec_sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+/*
+ * Keeps track of buffer parameters as provided by caller for requesting
+ * memory placement of buffer.
+ */
+struct kexec_buf {
+	struct kimage *image;
+	char *buffer;
+	unsigned long bufsz;
+	unsigned long mem;
+	unsigned long memsz;
+	unsigned long buf_align;
+	unsigned long buf_min;
+	unsigned long buf_max;
+	bool top_down;		/* allocate from top of memory hole */
+};
+
 void kimage_file_post_load_cleanup(struct kimage *image);
 #else /* CONFIG_KEXEC_FILE */
 static inline void kimage_file_post_load_cleanup(struct kimage *image) { }
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-set-kexec_type_crash-before-sanity_check_segment_list.patch
kexec-move-some-memembers-and-definitions-within-the-scope-of-config_kexec_file.patch

