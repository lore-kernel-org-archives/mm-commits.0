Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73927CCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jul 2022 23:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiGOXMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Jul 2022 19:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiGOXMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2022 19:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0634752FDD
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 16:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D6D61AE1
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 23:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91CAC34115;
        Fri, 15 Jul 2022 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657926734;
        bh=O7taLVJnJKlw1E7hKehtmI4ALch12iC3662gsKGV/Xk=;
        h=Date:To:From:Subject:From;
        b=OwwZBHo2RllcJsE15F33TX0pLLOsYYyf1JA5y3S6GQ7yWEVVQPUpEjjVENyk2oo1J
         Eju/xaJFUg3xxQIydR055Lw26fB3IBcW9raiHizOZpz7RYRCyC4z2Nsx7InWRqdU6B
         Fyqn6FKr+Wu/UCxqUY3UjCgTf5euIv95KxyFDBT8=
Date:   Fri, 15 Jul 2022 16:12:13 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        naveen.n.rao@linux.vnet.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kexec_file-drop-weak-attribute-from-functions.patch removed from -mm tree
Message-Id: <20220715231213.E91CAC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec_file: drop weak attribute from functions
has been removed from the -mm tree.  Its filename was
     kexec_file-drop-weak-attribute-from-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: kexec_file: drop weak attribute from functions
Date: Fri, 1 Jul 2022 13:04:04 +0530

As requested
(http://lkml.kernel.org/r/87ee0q7b92.fsf@email.froward.int.ebiederm.org),
this series converts weak functions in kexec to use the #ifdef approach. 

Quoting the 3e35142ef99fe ("kexec_file: drop weak attribute from
arch_kexec_apply_relocations[_add]") changelog:

: Since commit d1bcae833b32f1 ("ELF: Don't generate unused section symbols")
: [1], binutils (v2.36+) started dropping section symbols that it thought
: were unused.  This isn't an issue in general, but with kexec_file.c, gcc
: is placing kexec_arch_apply_relocations[_add] into a separate
: .text.unlikely section and the section symbol ".text.unlikely" is being
: dropped.  Due to this, recordmcount is unable to find a non-weak symbol in
: .text.unlikely to generate a relocation record against.


This patch (of 2);

Drop __weak attribute from functions in kexec_file.c:
- arch_kexec_kernel_image_probe()
- arch_kimage_file_post_load_cleanup()
- arch_kexec_kernel_image_load()
- arch_kexec_locate_mem_hole()
- arch_kexec_kernel_verify_sig()

arch_kexec_kernel_image_load() calls into kexec_image_load_default(), so
drop the static attribute for the latter.

arch_kexec_kernel_verify_sig() is not overridden by any architecture, so
drop the __weak attribute.

Link: https://lkml.kernel.org/r/cover.1656659357.git.naveen.n.rao@linux.vnet.ibm.com
Link: https://lkml.kernel.org/r/2cd7ca1fe4d6bb6ca38e3283c717878388ed6788.1656659357.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Suggested-by: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kexec.h   |    4 +-
 arch/powerpc/include/asm/kexec.h |    9 +++++
 arch/s390/include/asm/kexec.h    |    3 +
 arch/x86/include/asm/kexec.h     |    6 +++
 include/linux/kexec.h            |   44 +++++++++++++++++++++++++----
 kernel/kexec_file.c              |   35 +----------------------
 6 files changed, 61 insertions(+), 40 deletions(-)

--- a/arch/arm64/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-functions
+++ a/arch/arm64/include/asm/kexec.h
@@ -115,7 +115,9 @@ extern const struct kexec_file_ops kexec
 
 struct kimage;
 
-extern int arch_kimage_file_post_load_cleanup(struct kimage *image);
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
+
 extern int load_other_segments(struct kimage *image,
 		unsigned long kernel_load_addr, unsigned long kernel_size,
 		char *initrd, unsigned long initrd_len,
--- a/arch/powerpc/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-functions
+++ a/arch/powerpc/include/asm/kexec.h
@@ -120,6 +120,15 @@ int setup_purgatory(struct kimage *image
 #ifdef CONFIG_PPC64
 struct kexec_buf;
 
+int arch_kexec_kernel_image_probe(struct kimage *image, void *buf, unsigned long buf_len);
+#define arch_kexec_kernel_image_probe arch_kexec_kernel_image_probe
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
+
+int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
+#define arch_kexec_locate_mem_hole arch_kexec_locate_mem_hole
+
 int load_crashdump_segments_ppc64(struct kimage *image,
 				  struct kexec_buf *kbuf);
 int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
--- a/arch/s390/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-functions
+++ a/arch/s390/include/asm/kexec.h
@@ -92,5 +92,8 @@ int arch_kexec_apply_relocations_add(str
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 #endif /*_S390_KEXEC_H */
--- a/arch/x86/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-functions
+++ a/arch/x86/include/asm/kexec.h
@@ -193,6 +193,12 @@ int arch_kexec_apply_relocations_add(str
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+void *arch_kexec_kernel_image_load(struct kimage *image);
+#define arch_kexec_kernel_image_load arch_kexec_kernel_image_load
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 #endif
 
--- a/include/linux/kexec.h~kexec_file-drop-weak-attribute-from-functions
+++ a/include/linux/kexec.h
@@ -188,21 +188,53 @@ int kexec_purgatory_get_set_symbol(struc
 				   void *buf, unsigned int size,
 				   bool get_value);
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name);
+void *kexec_image_load_default(struct kimage *image);
+
+#ifndef arch_kexec_kernel_image_probe
+static inline int
+arch_kexec_kernel_image_probe(struct kimage *image, void *buf, unsigned long buf_len)
+{
+	return kexec_image_probe_default(image, buf, buf_len);
+}
+#endif
+
+#ifndef arch_kimage_file_post_load_cleanup
+static inline int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	return kexec_image_post_load_cleanup_default(image);
+}
+#endif
+
+#ifndef arch_kexec_kernel_image_load
+static inline void *arch_kexec_kernel_image_load(struct kimage *image)
+{
+	return kexec_image_load_default(image);
+}
+#endif
 
-/* Architectures may override the below functions */
-int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
-				  unsigned long buf_len);
-void *arch_kexec_kernel_image_load(struct kimage *image);
-int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #ifdef CONFIG_KEXEC_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 				 unsigned long buf_len);
 #endif
-int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
+#ifndef arch_kexec_locate_mem_hole
+/**
+ * arch_kexec_locate_mem_hole - Find free memory to place the segments.
+ * @kbuf:                       Parameters for the memory search.
+ *
+ * On success, kbuf->mem will have the start address of the memory region found.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
+{
+	return kexec_locate_mem_hole(kbuf);
+}
+#endif
+
 /* Alignment required for elf header segment */
 #define ELF_CORE_HEADER_ALIGN   4096
 
--- a/kernel/kexec_file.c~kexec_file-drop-weak-attribute-from-functions
+++ a/kernel/kexec_file.c
@@ -56,14 +56,7 @@ int kexec_image_probe_default(struct kim
 	return ret;
 }
 
-/* Architectures can provide this probe function */
-int __weak arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
-					 unsigned long buf_len)
-{
-	return kexec_image_probe_default(image, buf, buf_len);
-}
-
-static void *kexec_image_load_default(struct kimage *image)
+void *kexec_image_load_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
@@ -74,11 +67,6 @@ static void *kexec_image_load_default(st
 				 image->cmdline_buf_len);
 }
 
-void * __weak arch_kexec_kernel_image_load(struct kimage *image)
-{
-	return kexec_image_load_default(image);
-}
-
 int kexec_image_post_load_cleanup_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->cleanup)
@@ -87,11 +75,6 @@ int kexec_image_post_load_cleanup_defaul
 	return image->fops->cleanup(image->image_loader_data);
 }
 
-int __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
-{
-	return kexec_image_post_load_cleanup_default(image);
-}
-
 #ifdef CONFIG_KEXEC_SIG
 static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
 					  unsigned long buf_len)
@@ -104,8 +87,7 @@ static int kexec_image_verify_sig_defaul
 	return image->fops->verify_sig(buf, buf_len);
 }
 
-int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-					unsigned long buf_len)
+int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf, unsigned long buf_len)
 {
 	return kexec_image_verify_sig_default(image, buf, buf_len);
 }
@@ -617,19 +599,6 @@ int kexec_locate_mem_hole(struct kexec_b
 }
 
 /**
- * arch_kexec_locate_mem_hole - Find free memory to place the segments.
- * @kbuf:                       Parameters for the memory search.
- *
- * On success, kbuf->mem will have the start address of the memory region found.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
-{
-	return kexec_locate_mem_hole(kbuf);
-}
-
-/**
  * kexec_add_buffer - place a buffer in a kexec segment
  * @kbuf:	Buffer contents and memory parameters.
  *
_

Patches currently in -mm which might be from naveen.n.rao@linux.vnet.ibm.com are

kexec-drop-weak-attribute-from-functions.patch

