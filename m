From: akpm@linux-foundation.org
Subject: + kexec_file-add-mechanism-to-update-kexec-segments.patch added
 to -mm tree
Date: Fri, 16 Sep 2016 16:19:21 -0700
Message-ID: <57dc7df9.ATwi0mRyJJNki5lt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755524AbcIPXTX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:19:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: add mechanism to update kexec segments
has been added to the -mm tree.  Its filename is
     kexec_file-add-mechanism-to-update-kexec-segments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-add-mechanism-to-update-kexec-segments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-add-mechanism-to-update-kexec-segments.patch

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
Subject: kexec_file: add mechanism to update kexec segments

kexec_update_segment allows a given segment in kexec_image to have its
contents updated.  This is useful if the current kernel wants to send
information to the next kernel that is up-to-date at the time of reboot.

Before modifying the segment the image checksum is verified, and after the
segment is updated the checksum is recalculated and updated in the kexec
image.

Link: http://lkml.kernel.org/r/1473900890-1476-5-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h   |    2 
 kernel/kexec_core.c     |    5 
 kernel/kexec_file.c     |  331 ++++++++++++++++++++++++++++++++++++++
 kernel/kexec_internal.h |    6 
 4 files changed, 339 insertions(+), 5 deletions(-)

diff -puN include/linux/kexec.h~kexec_file-add-mechanism-to-update-kexec-segments include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-add-mechanism-to-update-kexec-segments
+++ a/include/linux/kexec.h
@@ -183,6 +183,8 @@ int __weak arch_kexec_walk_mem(struct ke
 			       int (*func)(u64, u64, void *));
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
+int kexec_update_segment(const char *buffer, size_t bufsz,
+			 unsigned long load_addr, size_t memsz);
 #endif /* CONFIG_KEXEC_FILE */
 
 struct kimage {
diff -puN kernel/kexec_core.c~kexec_file-add-mechanism-to-update-kexec-segments kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec_file-add-mechanism-to-update-kexec-segments
+++ a/kernel/kexec_core.c
@@ -551,11 +551,6 @@ void kimage_terminate(struct kimage *ima
 	*image->entry = IND_DONE;
 }
 
-#define for_each_kimage_entry(image, ptr, entry) \
-	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
-		ptr = (entry & IND_INDIRECTION) ? \
-			boot_phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
-
 static void kimage_free_entry(kimage_entry_t entry)
 {
 	struct page *page;
diff -puN kernel/kexec_file.c~kexec_file-add-mechanism-to-update-kexec-segments kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-add-mechanism-to-update-kexec-segments
+++ a/kernel/kexec_file.c
@@ -18,6 +18,7 @@
 #include <linux/kexec.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/highmem.h>
 #include <linux/fs.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
@@ -591,6 +592,336 @@ int kexec_add_buffer(struct kexec_buf *k
 	return 0;
 }
 
+/**
+ * @kexec_image_visit_segments() - call function on each segment page
+ * @image:	kexec image to inspect.
+ * @func:	Function to call on each page.
+ * @data:	Data pointer to pass to @func.
+ *
+ * Iterate through the @image entries, calling @func with the given @data
+ * on each segment page. dest is the start address of the page in the next
+ * kernel's address space, and addr is the address of the page in this kernel's
+ * address space.
+ *
+ * Stop iterating if @func returns non-zero, and return that value.
+ *
+ * Return: zero if all pages were visited, @func return value if non-zero.
+ */
+static int kexec_image_visit_segments(struct kimage *image,
+				      int (*func)(void *data,
+						  unsigned long dest,
+						  void *addr),
+				      void *data)
+{
+	int ret;
+	unsigned long entry, dest = 0;
+	unsigned long *ptr = NULL;
+
+	for_each_kimage_entry(image, ptr, entry) {
+		void *addr = (void *) (entry & PAGE_MASK);
+
+		switch (entry & IND_FLAGS) {
+		case IND_DESTINATION:
+			dest = (unsigned long) addr;
+			break;
+		case IND_SOURCE:
+			/* Shouldn't happen, but verify just to be safe. */
+			if (WARN_ON(!dest)) {
+				pr_err("Invalid kexec entries list.");
+				return -EINVAL;
+			}
+
+			ret = func(data, dest, addr);
+			if (ret)
+				break;
+
+			dest += PAGE_SIZE;
+		}
+
+		/* Shouldn't happen, but verify just to be safe. */
+		if (WARN_ON(ptr == NULL)) {
+			pr_err("Invalid kexec entries list.");
+			return -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+struct image_digest_data {
+	unsigned long digest_load_addr;
+	struct shash_desc *desc;
+};
+
+static int calculate_image_digest(void *data, unsigned long dest, void *addr)
+{
+	struct image_digest_data *d = (struct image_digest_data *) data;
+	void *page_addr;
+	unsigned long offset;
+	int ret;
+
+	/* Assumption: the digest segment is PAGE_SIZE long. */
+	if (dest == d->digest_load_addr)
+		return 0;
+
+	page_addr = kmap_atomic(kmap_to_page(addr));
+
+	offset = dest & ~PAGE_MASK;
+	ret = crypto_shash_update(d->desc, page_addr + offset,
+				  PAGE_SIZE - offset);
+
+	kunmap_atomic(page_addr);
+
+	return ret;
+}
+
+/**
+ * kexec_calculate_image_digest() - calculate the digest of the kexec image
+ * @image:	kexec image with segments already loaded into it.
+ * @digest:	Buffer of at least SHA256_DIGEST_SIZE bytes.
+ *
+ * This function goes through the @image->head list, calculates the checksum
+ * of the segment contents and puts the result in @digest, which is assumed
+ * to be big enough to hold an SHA256 digest.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static int kexec_calculate_image_digest(struct kimage *image, void *digest)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	int ret;
+	size_t desc_size;
+	struct purgatory_info *pi = &image->purgatory_info;
+	struct image_digest_data d;
+
+	tfm = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	desc->tfm   = tfm;
+	desc->flags = 0;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_desc;
+
+	d.desc = desc;
+	d.digest_load_addr = pi->digest_load_addr;
+	ret = kexec_image_visit_segments(image, calculate_image_digest, &d);
+
+	if (!ret)
+		ret = crypto_shash_final(desc, digest);
+
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	return ret;
+}
+
+struct get_digest_data {
+	void *digest;
+	unsigned long digest_load_addr;
+	size_t bufsz;
+	size_t memsz;
+};
+
+static int get_digest(void *data, unsigned long dest, void *addr)
+{
+	struct get_digest_data *d = (struct get_digest_data *) data;
+	void *page_addr;
+	unsigned long offset;
+	size_t uchunk, mchunk;
+
+	if (dest != d->digest_load_addr)
+		return 0;
+
+	page_addr = kmap_atomic(kmap_to_page(addr));
+
+	offset = dest & ~PAGE_MASK;
+	mchunk = min_t(size_t, d->memsz, PAGE_SIZE - offset);
+	uchunk = min(d->bufsz, mchunk);
+	memcpy(d->digest, page_addr + offset, uchunk);
+
+	kunmap_atomic(page_addr);
+
+	d->digest += mchunk;
+	d->bufsz -= uchunk;
+	d->digest_load_addr += mchunk;
+	d->memsz -= mchunk;
+
+	return d->memsz > 0 ? 0 : 1;
+}
+
+static int kexec_image_get_digest(struct kimage *image, void *digest)
+{
+	int ret;
+	struct get_digest_data d;
+
+	d.digest = digest;
+	d.digest_load_addr = image->purgatory_info.digest_load_addr;
+	d.bufsz = SHA256_DIGEST_SIZE;
+	d.memsz = SHA256_DIGEST_SIZE;
+	ret = kexec_image_visit_segments(image, get_digest, &d);
+
+	return d.bufsz == 0 ? 0 : -ENOENT;
+}
+
+struct update_segment_data {
+	const char *buffer;
+	size_t bufsz;
+	size_t memsz;
+	unsigned long load_addr;
+};
+
+static int update_segment(void *data, unsigned long dest, void *addr)
+{
+	struct update_segment_data *d = (struct update_segment_data *) data;
+	void *page_addr;
+	unsigned long offset;
+	size_t uchunk, mchunk;
+
+	if (dest != d->load_addr)
+		return 0;
+
+	page_addr = kmap_atomic(kmap_to_page(addr));
+
+	offset = d->load_addr & ~PAGE_MASK;
+	mchunk = min_t(size_t, d->memsz, PAGE_SIZE - offset);
+	uchunk = min(d->bufsz, mchunk);
+	memcpy(page_addr + offset, d->buffer, uchunk);
+
+	kunmap_atomic(page_addr);
+
+	d->bufsz -= uchunk;
+	d->load_addr += mchunk;
+	d->buffer += mchunk;
+	d->memsz -= mchunk;
+
+	return d->memsz > 0 ? 0 : 1;
+}
+
+static int do_kexec_update_segment(const char *buffer, size_t bufsz,
+				   unsigned long load_addr, size_t memsz)
+{
+	int i;
+	struct update_segment_data d;
+
+	if (kexec_image == NULL) {
+		pr_err("Can't update segment: no kexec image loaded.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * kexec_add_buffer rounds up segment sizes to PAGE_SIZE, so
+	 * we have to do it here as well.
+	 */
+	memsz = ALIGN(memsz, PAGE_SIZE);
+
+	for (i = 0; i < kexec_image->nr_segments; i++)
+		/* We only support updating whole segments. */
+		if (load_addr == kexec_image->segment[i].mem &&
+		    memsz == kexec_image->segment[i].memsz)
+			break;
+
+	if (WARN_ON(i == kexec_image->nr_segments)) {
+		pr_debug("Couldn't find segment to update: 0x%lx, size 0x%zx\n",
+			 load_addr, memsz);
+		return -EINVAL;
+	}
+
+	d.buffer = buffer;
+	d.bufsz = bufsz;
+	d.load_addr = load_addr;
+	d.memsz = memsz;
+	kexec_image_visit_segments(kexec_image, update_segment, &d);
+
+	return 0;
+}
+
+
+/**
+ * kexec_update_segment() - update the contents of a kimage segment
+ * @buffer:	New contents of the segment.
+ * @bufsz:	@buffer size.
+ * @load_addr:	Segment's physical address in the next kernel.
+ * @memsz:	Segment size.
+ *
+ * This function assumes kexec_mutex is held.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+int kexec_update_segment(const char *buffer, size_t bufsz,
+			 unsigned long load_addr, size_t memsz)
+{
+	int ret;
+	void *digest, *orig_digest;
+	struct purgatory_info *pi = &kexec_image->purgatory_info;
+
+	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!digest)
+		return -ENOMEM;
+
+	orig_digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!orig_digest) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* First, verify the kexec image integrity. */
+	ret = kexec_image_get_digest(kexec_image, orig_digest);
+	if (ret) {
+		pr_debug("Can't get kexec image checksum.\n");
+		goto out;
+	}
+
+	ret = kexec_calculate_image_digest(kexec_image, digest);
+	if (ret) {
+		pr_debug("Can't calculate kexec image checksum.\n");
+		goto out;
+	}
+
+	ret = memcmp(digest, orig_digest, SHA256_DIGEST_SIZE);
+	if (ret) {
+		pr_debug("The kexec image was corrupted in memory.\n");
+		ret = -ENOEXEC;
+		goto out;
+	}
+
+	/* Now, update the segment we were asked to update. */
+	ret = do_kexec_update_segment(buffer, bufsz, load_addr, memsz);
+	if (ret)
+		goto out;
+
+	/* Calculate the new kexec image checksum. */
+	ret = kexec_calculate_image_digest(kexec_image, digest);
+	if (ret) {
+		pr_debug("Can't calculate kexec image checksum.\n");
+		goto out;
+	}
+
+	/* Update the segment containing the kexec image checksum. */
+	ret = do_kexec_update_segment(digest, SHA256_DIGEST_SIZE,
+				      pi->digest_load_addr, SHA256_DIGEST_SIZE);
+
+out:
+	kfree(digest);
+	kfree(orig_digest);
+
+	return ret;
+}
+
 /* Calculate and store the digest of segments */
 static int kexec_calculate_store_digests(struct kimage *image)
 {
diff -puN kernel/kexec_internal.h~kexec_file-add-mechanism-to-update-kexec-segments kernel/kexec_internal.h
--- a/kernel/kexec_internal.h~kexec_file-add-mechanism-to-update-kexec-segments
+++ a/kernel/kexec_internal.h
@@ -14,6 +14,12 @@ int kimage_is_destination_range(struct k
 
 extern struct mutex kexec_mutex;
 
+#define for_each_kimage_entry(image, ptr, entry) \
+	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
+		ptr = (entry & IND_INDIRECTION) ? \
+			boot_phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
+
+
 #ifdef CONFIG_KEXEC_FILE
 struct kexec_sha_region {
 	unsigned long start;
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

