From: akpm@linux-foundation.org
Subject: +
 kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
 added to -mm tree
Date: Fri, 16 Sep 2016 16:19:11 -0700
Message-ID: <57dc7def.YmdnoDwxaao7qD+v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbcIPXTN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: include the purgatory segment in the kexec image checksum
has been added to the -mm tree.  Its filename is
     kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch

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
Subject: kexec_file: include the purgatory segment in the kexec image checksum

Patch series "kexec_file: Add buffer hand-over for the next kernel", v5.

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



This patch (of 4):

Currently, the purgatory segment is skipped from the kexec image checksum
because it is modified to include the calculated digest.

By putting the digest in a separate kexec segment, we can include the
purgatory segment in the kexec image verification since it won't need to
be modified anymore.

With this change, the only part of the kexec image that is not covered by
the checksum is the digest itself.

Even with the digest stored separately, x86 needs to leave the purgatory
segment out of the checksum calculation because it modifies the purgatory
code in relocate_kernel.  We use CONFIG_ARCH_MODIFIES_KEXEC_PURGATORY to
allow the powerpc purgatory to be protected by the checksum while still
preserving x86 behavior.

Link: http://lkml.kernel.org/r/3000835.2VCEnkym2S@hactar
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

 arch/Kconfig                       |    8 ++
 arch/powerpc/purgatory/purgatory.c |    4 -
 arch/x86/Kconfig                   |    1 
 arch/x86/purgatory/purgatory.c     |    2 
 include/linux/kexec.h              |    6 +
 kernel/kexec_file.c                |  100 ++++++++++++++++++---------
 6 files changed, 87 insertions(+), 34 deletions(-)

diff -puN arch/Kconfig~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum arch/Kconfig
--- a/arch/Kconfig~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/arch/Kconfig
@@ -5,6 +5,14 @@
 config KEXEC_CORE
 	bool
 
+#
+# Architectures that need to modify the purgatory segment after the
+# checksum is calculated need to select this option so that it won't
+# be part of the kexec image checksum.
+#
+config ARCH_MODIFIES_KEXEC_PURGATORY
+	bool
+
 config OPROFILE
 	tristate "OProfile system profiling"
 	depends on PROFILING
diff -puN arch/powerpc/purgatory/purgatory.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum arch/powerpc/purgatory/purgatory.c
--- a/arch/powerpc/purgatory/purgatory.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/arch/powerpc/purgatory/purgatory.c
@@ -17,7 +17,7 @@
 #include "kexec-sha256.h"
 
 struct kexec_sha_region sha_regions[SHA256_REGIONS] = {};
-u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
+u8 *sha256_digest = NULL;
 
 int verify_sha256_digest(void)
 {
@@ -40,7 +40,7 @@ int verify_sha256_digest(void)
 		printf("\n");
 
 		printf("sha256_digest: ");
-		for (i = 0; i < sizeof(sha256_digest); i++)
+		for (i = 0; i < SHA256_DIGEST_SIZE; i++)
 			printf("%hhx ", sha256_digest[i]);
 
 		printf("\n");
diff -puN arch/x86/Kconfig~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/arch/x86/Kconfig
@@ -1811,6 +1811,7 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
+	select ARCH_MODIFIES_KEXEC_PURGATORY
 	select BUILD_BIN2C
 	depends on X86_64
 	depends on CRYPTO=y
diff -puN arch/x86/purgatory/purgatory.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum arch/x86/purgatory/purgatory.c
--- a/arch/x86/purgatory/purgatory.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/arch/x86/purgatory/purgatory.c
@@ -22,7 +22,7 @@ unsigned long backup_dest = 0;
 unsigned long backup_src = 0;
 unsigned long backup_sz = 0;
 
-u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
+u8 *sha256_digest = NULL;
 
 struct sha_region sha_regions[16] = {};
 
diff -puN include/linux/kexec.h~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/include/linux/kexec.h
@@ -124,8 +124,14 @@ struct purgatory_info {
 	 */
 	void *purgatory_buf;
 
+	/* Digest of the contents of segments. */
+	void *digest_buf;
+
 	/* Address where purgatory is finally loaded and is executed from */
 	unsigned long purgatory_load_addr;
+
+	/* Address where the digest is loaded. */
+	unsigned long digest_load_addr;
 };
 
 typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
diff -puN kernel/kexec_file.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum
+++ a/kernel/kexec_file.c
@@ -98,6 +98,9 @@ void kimage_file_post_load_cleanup(struc
 	vfree(pi->purgatory_buf);
 	pi->purgatory_buf = NULL;
 
+	kfree(pi->digest_buf);
+	pi->digest_buf = NULL;
+
 	vfree(pi->sechdrs);
 	pi->sechdrs = NULL;
 
@@ -527,7 +530,6 @@ static int kexec_calculate_store_digests
 	struct shash_desc *desc;
 	int ret = 0, i, j, zero_buf_sz, sha_region_sz;
 	size_t desc_size, nullsz;
-	char *digest;
 	void *zero_buf;
 	struct kexec_sha_region *sha_regions;
 	struct purgatory_info *pi = &image->purgatory_info;
@@ -553,6 +555,37 @@ static int kexec_calculate_store_digests
 	if (!sha_regions)
 		goto out_free_desc;
 
+	/*
+	 * Set sha_regions early so that we can write it to the purgatory
+	 * and include it in the checksum.
+	 */
+	for (j = i = 0; i < image->nr_segments; i++) {
+		struct kexec_segment *ksegment = &image->segment[i];
+
+		if (ksegment->kbuf == pi->digest_buf)
+			continue;
+
+		if (IS_ENABLED(CONFIG_ARCH_MODIFIES_KEXEC_PURGATORY) &&
+		    ksegment->kbuf == pi->purgatory_buf)
+			continue;
+
+		sha_regions[j].start = ksegment->mem;
+		sha_regions[j].len = ksegment->memsz;
+		j++;
+	}
+
+	ret = kexec_purgatory_get_set_symbol(image, "sha_regions", sha_regions,
+					     sha_region_sz, false);
+	if (ret)
+		goto out_free_sha_regions;
+
+	ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
+					     &pi->digest_load_addr,
+					     sizeof(pi->digest_load_addr),
+					     false);
+	if (ret)
+		goto out_free_sha_regions;
+
 	desc->tfm   = tfm;
 	desc->flags = 0;
 
@@ -560,21 +593,24 @@ static int kexec_calculate_store_digests
 	if (ret < 0)
 		goto out_free_sha_regions;
 
-	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
-	if (!digest) {
-		ret = -ENOMEM;
-		goto out_free_sha_regions;
-	}
-
-	for (j = i = 0; i < image->nr_segments; i++) {
+	for (i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
 		ksegment = &image->segment[i];
 		/*
-		 * Skip purgatory as it will be modified once we put digest
-		 * info in purgatory.
+		 * Skip the digest segment as it will be modified with the
+		 * result of the checksum calculation.
 		 */
-		if (ksegment->kbuf == pi->purgatory_buf)
+		if (ksegment->kbuf == pi->digest_buf)
+			continue;
+
+		/*
+		 * Some architectures need to modify the purgatory before
+		 * jumping into it, so in those cases we need to skip the
+		 * purgatory from the checksum calculation.
+		 */
+		if (IS_ENABLED(CONFIG_ARCH_MODIFIES_KEXEC_PURGATORY) &&
+		    ksegment->kbuf == pi->purgatory_buf)
 			continue;
 
 		ret = crypto_shash_update(desc, ksegment->kbuf,
@@ -600,29 +636,11 @@ static int kexec_calculate_store_digests
 
 		if (ret)
 			break;
-
-		sha_regions[j].start = ksegment->mem;
-		sha_regions[j].len = ksegment->memsz;
-		j++;
 	}
 
-	if (!ret) {
-		ret = crypto_shash_final(desc, digest);
-		if (ret)
-			goto out_free_digest;
-		ret = kexec_purgatory_get_set_symbol(image, "sha_regions",
-						sha_regions, sha_region_sz, 0);
-		if (ret)
-			goto out_free_digest;
-
-		ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
-						digest, SHA256_DIGEST_SIZE, 0);
-		if (ret)
-			goto out_free_digest;
-	}
+	if (!ret)
+		ret = crypto_shash_final(desc, pi->digest_buf);
 
-out_free_digest:
-	kfree(digest);
 out_free_sha_regions:
 	vfree(sha_regions);
 out_free_desc:
@@ -875,6 +893,10 @@ int kexec_load_purgatory(struct kimage *
 			 unsigned long *load_addr)
 {
 	struct purgatory_info *pi = &image->purgatory_info;
+	struct kexec_buf kbuf = { .image = image, .bufsz = SHA256_DIGEST_SIZE,
+				  .memsz = SHA256_DIGEST_SIZE, .buf_align = 1,
+				  .buf_min = min, .buf_max = max,
+				  .top_down = top_down };
 	int ret;
 
 	if (kexec_purgatory_size <= 0)
@@ -900,6 +922,22 @@ int kexec_load_purgatory(struct kimage *
 	if (ret)
 		return ret;
 
+	pi->digest_buf = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!pi->digest_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Add a separate segment for the digest so that we don't have to modify
+	 * the purgatory segment after we calculate the kexec image checksum.
+	 */
+	kbuf.buffer = pi->digest_buf;
+	ret = kexec_add_buffer(&kbuf);
+	if (ret)
+		goto out;
+	pi->digest_load_addr = kbuf.mem;
+
 	ret = kexec_apply_relocations(image);
 	if (ret)
 		goto out;
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

