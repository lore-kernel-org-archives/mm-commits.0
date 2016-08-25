From: akpm@linux-foundation.org
Subject: +
 kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:13:48 -0700
Message-ID: <57bf5f8c.j8q06XPiC2xfojpf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58423 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756968AbcHYVOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: allow skipping checksum calculation for some segments
has been added to the -mm tree.  Its filename is
     kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch

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
Subject: kexec_file: allow skipping checksum calculation for some segments

Add skip_checksum member to struct kexec_buf to specify whether the
corresponding segment should be part of the checksum calculation.

The next patch will add a way to update segments after a kimage is loaded.
Segments that will be updated in this way should not be checksummed,
otherwise they will cause the purgatory checksum verification to fail
when the machine is rebooted.

As a bonus, we don't need to special-case the purgatory segment anymore
to avoid checksumming it.

Places using struct kexec_buf get false as the default value for
skip_checksum since they all use designated initializers.  Therefore,
there is no behavior change with this patch and all segments except the
purgatory are checksummed.

Link: http://lkml.kernel.org/r/1472149111-30598-4-git-send-email-bauerman@linux.vnet.ibm.com
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

 include/linux/kexec.h |   23 ++++++++++++++---------
 kernel/kexec_file.c   |   15 +++++++--------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff -puN include/linux/kexec.h~kexec_file-allow-skipping-checksum-calculation-for-some-segments include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-allow-skipping-checksum-calculation-for-some-segments
+++ a/include/linux/kexec.h
@@ -100,6 +100,9 @@ struct kexec_segment {
 	size_t bufsz;
 	unsigned long mem;
 	size_t memsz;
+
+	/* Whether this segment is ignored in the checksum calculation. */
+	bool skip_checksum;
 };
 
 #ifdef CONFIG_COMPAT
@@ -151,15 +154,16 @@ struct kexec_file_ops {
 
 /**
  * struct kexec_buf - parameters for finding a place for a buffer in memory
- * @image:	kexec image in which memory to search.
- * @buffer:	Contents which will be copied to the allocated memory.
- * @bufsz:	Size of @buffer.
- * @mem:	On return will have address of the buffer in memory.
- * @memsz:	Size for the buffer in memory.
- * @buf_align:	Minimum alignment needed.
- * @buf_min:	The buffer can't be placed below this address.
- * @buf_max:	The buffer can't be placed above this address.
- * @top_down:	Allocate from top of memory.
+ * @image:		kexec image in which memory to search.
+ * @buffer:		Contents which will be copied to the allocated memory.
+ * @bufsz:		Size of @buffer.
+ * @mem:		On return will have address of the buffer in memory.
+ * @memsz:		Size for the buffer in memory.
+ * @buf_align:		Minimum alignment needed.
+ * @buf_min:		The buffer can't be placed below this address.
+ * @buf_max:		The buffer can't be placed above this address.
+ * @top_down:		Allocate from top of memory.
+ * @skip_checksum:	Don't verify checksum for this buffer in purgatory.
  */
 struct kexec_buf {
 	struct kimage *image;
@@ -171,6 +175,7 @@ struct kexec_buf {
 	unsigned long buf_min;
 	unsigned long buf_max;
 	bool top_down;
+	bool skip_checksum;
 };
 
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
diff -puN kernel/kexec_file.c~kexec_file-allow-skipping-checksum-calculation-for-some-segments kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-allow-skipping-checksum-calculation-for-some-segments
+++ a/kernel/kexec_file.c
@@ -584,6 +584,7 @@ int kexec_add_buffer(struct kexec_buf *k
 	ksegment->bufsz = kbuf->bufsz;
 	ksegment->mem = kbuf->mem;
 	ksegment->memsz = kbuf->memsz;
+	ksegment->skip_checksum = kbuf->skip_checksum;
 	kbuf->image->nr_segments++;
 	return 0;
 }
@@ -598,7 +599,6 @@ static int kexec_calculate_store_digests
 	char *digest;
 	void *zero_buf;
 	struct kexec_sha_region *sha_regions;
-	struct purgatory_info *pi = &image->purgatory_info;
 
 	zero_buf = __va(page_to_pfn(ZERO_PAGE(0)) << PAGE_SHIFT);
 	zero_buf_sz = PAGE_SIZE;
@@ -638,11 +638,7 @@ static int kexec_calculate_store_digests
 		struct kexec_segment *ksegment;
 
 		ksegment = &image->segment[i];
-		/*
-		 * Skip purgatory as it will be modified once we put digest
-		 * info in purgatory.
-		 */
-		if (ksegment->kbuf == pi->purgatory_buf)
+		if (ksegment->skip_checksum)
 			continue;
 
 		ret = crypto_shash_update(desc, ksegment->kbuf,
@@ -714,7 +710,7 @@ static int __kexec_load_purgatory(struct
 	Elf_Shdr *sechdrs = NULL;
 	struct kexec_buf kbuf = { .image = image, .bufsz = 0, .buf_align = 1,
 				  .buf_min = min, .buf_max = max,
-				  .top_down = top_down };
+				  .top_down = top_down, .skip_checksum = true };
 
 	/*
 	 * sechdrs_c points to section headers in purgatory and are read
@@ -819,7 +815,10 @@ static int __kexec_load_purgatory(struct
 	if (kbuf.buf_align < bss_align)
 		kbuf.buf_align = bss_align;
 
-	/* Add buffer to segment list */
+	/*
+	 * Add buffer to segment list. Don't checksum the segment as
+	 * it will be modified once we put digest info in purgatory.
+	 */
 	ret = kexec_add_buffer(&kbuf);
 	if (ret)
 		goto out;
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

