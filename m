From: akpm@linux-foundation.org
Subject: +
 kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:13:05 -0700
Message-ID: <57bf5f61.MHddmLPwdZZxENLx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753912AbcHYVN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: change kexec_add_buffer to take kexec_buf as argument
has been added to the -mm tree.  Its filename is
     kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch

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
Subject: kexec_file: change kexec_add_buffer to take kexec_buf as argument

This is done to simplify the kexec_add_buffer argument list.
Adapt all callers to set up a kexec_buf to pass to kexec_add_buffer.

In addition, change the type of kexec_buf.buffer from char * to void *.
There is no particular reason for it to be a char *, and the change
allows us to get rid of 3 existing casts to char * in the code.

Link: http://lkml.kernel.org/r/1471652242-14436-3-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c           |   37 ++++++-----
 arch/x86/kernel/kexec-bzimage64.c |   48 ++++++++-------
 include/linux/kexec.h             |    8 --
 kernel/kexec_file.c               |   88 ++++++++++++----------------
 4 files changed, 87 insertions(+), 94 deletions(-)

diff -puN arch/x86/kernel/crash.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument
+++ a/arch/x86/kernel/crash.c
@@ -615,9 +615,9 @@ static int determine_backup_region(u64 s
 
 int crash_load_segments(struct kimage *image)
 {
-	unsigned long src_start, src_sz, elf_sz;
-	void *elf_addr;
 	int ret;
+	struct kexec_buf kbuf = { .image = image, .buf_min = 0,
+				  .buf_max = ULONG_MAX, .top_down = false };
 
 	/*
 	 * Determine and load a segment for backup area. First 640K RAM
@@ -631,43 +631,44 @@ int crash_load_segments(struct kimage *i
 	if (ret < 0)
 		return ret;
 
-	src_start = image->arch.backup_src_start;
-	src_sz = image->arch.backup_src_sz;
-
 	/* Add backup segment. */
-	if (src_sz) {
+	if (image->arch.backup_src_sz) {
+		kbuf.buffer = &crash_zero_bytes;
+		kbuf.bufsz = sizeof(crash_zero_bytes);
+		kbuf.memsz = image->arch.backup_src_sz;
+		kbuf.buf_align = PAGE_SIZE;
 		/*
 		 * Ideally there is no source for backup segment. This is
 		 * copied in purgatory after crash. Just add a zero filled
 		 * segment for now to make sure checksum logic works fine.
 		 */
-		ret = kexec_add_buffer(image, (char *)&crash_zero_bytes,
-				       sizeof(crash_zero_bytes), src_sz,
-				       PAGE_SIZE, 0, -1, 0,
-				       &image->arch.backup_load_addr);
+		ret = kexec_add_buffer(&kbuf);
 		if (ret)
 			return ret;
+		image->arch.backup_load_addr = kbuf.mem;
 		pr_debug("Loaded backup region at 0x%lx backup_start=0x%lx memsz=0x%lx\n",
-			 image->arch.backup_load_addr, src_start, src_sz);
+			 image->arch.backup_load_addr,
+			 image->arch.backup_src_start, kbuf.memsz);
 	}
 
 	/* Prepare elf headers and add a segment */
-	ret = prepare_elf_headers(image, &elf_addr, &elf_sz);
+	ret = prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz);
 	if (ret)
 		return ret;
 
-	image->arch.elf_headers = elf_addr;
-	image->arch.elf_headers_sz = elf_sz;
+	image->arch.elf_headers = kbuf.buffer;
+	image->arch.elf_headers_sz = kbuf.bufsz;
 
-	ret = kexec_add_buffer(image, (char *)elf_addr, elf_sz, elf_sz,
-			ELF_CORE_HEADER_ALIGN, 0, -1, 0,
-			&image->arch.elf_load_addr);
+	kbuf.memsz = kbuf.bufsz;
+	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
+	ret = kexec_add_buffer(&kbuf);
 	if (ret) {
 		vfree((void *)image->arch.elf_headers);
 		return ret;
 	}
+	image->arch.elf_load_addr = kbuf.mem;
 	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 image->arch.elf_load_addr, elf_sz, elf_sz);
+		 image->arch.elf_load_addr, kbuf.bufsz, kbuf.bufsz);
 
 	return ret;
 }
diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -331,17 +331,17 @@ static void *bzImage64_load(struct kimag
 
 	struct setup_header *header;
 	int setup_sects, kern16_size, ret = 0;
-	unsigned long setup_header_size, params_cmdline_sz, params_misc_sz;
+	unsigned long setup_header_size, params_cmdline_sz;
 	struct boot_params *params;
 	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
 	unsigned long purgatory_load_addr;
-	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
-	char *kernel_buf;
 	struct bzimage64_data *ldata;
 	struct kexec_entry64_regs regs64;
 	void *stack;
 	unsigned int setup_hdr_offset = offsetof(struct boot_params, hdr);
 	unsigned int efi_map_offset, efi_map_sz, efi_setup_data_offset;
+	struct kexec_buf kbuf = { .image = image, .buf_max = ULONG_MAX,
+				  .top_down = true };
 
 	header = (struct setup_header *)(kernel + setup_hdr_offset);
 	setup_sects = header->setup_sects;
@@ -402,11 +402,11 @@ static void *bzImage64_load(struct kimag
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
 	params_cmdline_sz = ALIGN(params_cmdline_sz, 16);
-	params_misc_sz = params_cmdline_sz + efi_map_sz +
+	kbuf.bufsz = params_cmdline_sz + efi_map_sz +
 				sizeof(struct setup_data) +
 				sizeof(struct efi_setup_data);
 
-	params = kzalloc(params_misc_sz, GFP_KERNEL);
+	params = kzalloc(kbuf.bufsz, GFP_KERNEL);
 	if (!params)
 		return ERR_PTR(-ENOMEM);
 	efi_map_offset = params_cmdline_sz;
@@ -418,37 +418,41 @@ static void *bzImage64_load(struct kimag
 	/* Is there a limit on setup header size? */
 	memcpy(&params->hdr, (kernel + setup_hdr_offset), setup_header_size);
 
-	ret = kexec_add_buffer(image, (char *)params, params_misc_sz,
-			       params_misc_sz, 16, MIN_BOOTPARAM_ADDR,
-			       ULONG_MAX, 1, &bootparam_load_addr);
+	kbuf.buffer = params;
+	kbuf.memsz = kbuf.bufsz;
+	kbuf.buf_align = 16;
+	kbuf.buf_min = MIN_BOOTPARAM_ADDR;
+	ret = kexec_add_buffer(&kbuf);
 	if (ret)
 		goto out_free_params;
+	bootparam_load_addr = kbuf.mem;
 	pr_debug("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 bootparam_load_addr, params_misc_sz, params_misc_sz);
+		 bootparam_load_addr, kbuf.bufsz, kbuf.bufsz);
 
 	/* Load kernel */
-	kernel_buf = kernel + kern16_size;
-	kernel_bufsz =  kernel_len - kern16_size;
-	kernel_memsz = PAGE_ALIGN(header->init_size);
-	kernel_align = header->kernel_alignment;
-
-	ret = kexec_add_buffer(image, kernel_buf,
-			       kernel_bufsz, kernel_memsz, kernel_align,
-			       MIN_KERNEL_LOAD_ADDR, ULONG_MAX, 1,
-			       &kernel_load_addr);
+	kbuf.buffer = kernel + kern16_size;
+	kbuf.bufsz =  kernel_len - kern16_size;
+	kbuf.memsz = PAGE_ALIGN(header->init_size);
+	kbuf.buf_align = header->kernel_alignment;
+	kbuf.buf_min = MIN_KERNEL_LOAD_ADDR;
+	ret = kexec_add_buffer(&kbuf);
 	if (ret)
 		goto out_free_params;
+	kernel_load_addr = kbuf.mem;
 
 	pr_debug("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 kernel_load_addr, kernel_memsz, kernel_memsz);
+		 kernel_load_addr, kbuf.bufsz, kbuf.memsz);
 
 	/* Load initrd high */
 	if (initrd) {
-		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
-				       PAGE_SIZE, MIN_INITRD_LOAD_ADDR,
-				       ULONG_MAX, 1, &initrd_load_addr);
+		kbuf.buffer = initrd;
+		kbuf.bufsz = kbuf.memsz = initrd_len;
+		kbuf.buf_align = PAGE_SIZE;
+		kbuf.buf_min = MIN_INITRD_LOAD_ADDR;
+		ret = kexec_add_buffer(&kbuf);
 		if (ret)
 			goto out_free_params;
+		initrd_load_addr = kbuf.mem;
 
 		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 				initrd_load_addr, initrd_len, initrd_len);
diff -puN include/linux/kexec.h~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument include/linux/kexec.h
--- a/include/linux/kexec.h~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument
+++ a/include/linux/kexec.h
@@ -163,7 +163,7 @@ struct kexec_file_ops {
  */
 struct kexec_buf {
 	struct kimage *image;
-	char *buffer;
+	void *buffer;
 	unsigned long bufsz;
 	unsigned long mem;
 	unsigned long memsz;
@@ -175,6 +175,7 @@ struct kexec_buf {
 
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
 			       int (*func)(u64, u64, void *));
+extern int kexec_add_buffer(struct kexec_buf *kbuf);
 #endif /* CONFIG_KEXEC_FILE */
 
 struct kimage {
@@ -239,11 +240,6 @@ extern asmlinkage long sys_kexec_load(un
 					struct kexec_segment __user *segments,
 					unsigned long flags);
 extern int kernel_kexec(void);
-extern int kexec_add_buffer(struct kimage *image, char *buffer,
-			    unsigned long bufsz, unsigned long memsz,
-			    unsigned long buf_align, unsigned long buf_min,
-			    unsigned long buf_max, bool top_down,
-			    unsigned long *load_addr);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
 extern int kexec_load_purgatory(struct kimage *image, unsigned long min,
diff -puN kernel/kexec_file.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument
+++ a/kernel/kexec_file.c
@@ -449,25 +449,27 @@ int __weak arch_kexec_walk_mem(struct ke
 		return walk_system_ram_res(0, ULONG_MAX, kbuf, func);
 }
 
-/*
- * Helper function for placing a buffer in a kexec segment. This assumes
- * that kexec_mutex is held.
+/**
+ * kexec_add_buffer - place a buffer in a kexec segment
+ * @kbuf:	Buffer contents and memory parameters.
+ *
+ * This function assumes that kexec_mutex is held.
+ * On successful return, @kbuf->mem will have the physical address of
+ * the buffer in memory.
+ *
+ * Return: 0 on success, negative errno on error.
  */
-int kexec_add_buffer(struct kimage *image, char *buffer, unsigned long bufsz,
-		     unsigned long memsz, unsigned long buf_align,
-		     unsigned long buf_min, unsigned long buf_max,
-		     bool top_down, unsigned long *load_addr)
+int kexec_add_buffer(struct kexec_buf *kbuf)
 {
 
 	struct kexec_segment *ksegment;
-	struct kexec_buf buf, *kbuf;
 	int ret;
 
 	/* Currently adding segment this way is allowed only in file mode */
-	if (!image->file_mode)
+	if (!kbuf->image->file_mode)
 		return -EINVAL;
 
-	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
+	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -477,22 +479,14 @@ int kexec_add_buffer(struct kimage *imag
 	 * logic goes through list of segments to make sure there are
 	 * no destination overlaps.
 	 */
-	if (!list_empty(&image->control_pages)) {
+	if (!list_empty(&kbuf->image->control_pages)) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	memset(&buf, 0, sizeof(struct kexec_buf));
-	kbuf = &buf;
-	kbuf->image = image;
-	kbuf->buffer = buffer;
-	kbuf->bufsz = bufsz;
-
-	kbuf->memsz = ALIGN(memsz, PAGE_SIZE);
-	kbuf->buf_align = max(buf_align, PAGE_SIZE);
-	kbuf->buf_min = buf_min;
-	kbuf->buf_max = buf_max;
-	kbuf->top_down = top_down;
+	/* Ensure minimum alignment needed for segments. */
+	kbuf->memsz = ALIGN(kbuf->memsz, PAGE_SIZE);
+	kbuf->buf_align = max(kbuf->buf_align, PAGE_SIZE);
 
 	/* Walk the RAM ranges and allocate a suitable range for the buffer */
 	ret = arch_kexec_walk_mem(kbuf, locate_mem_hole_callback);
@@ -502,13 +496,12 @@ int kexec_add_buffer(struct kimage *imag
 	}
 
 	/* Found a suitable memory range */
-	ksegment = &image->segment[image->nr_segments];
+	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
 	ksegment->kbuf = kbuf->buffer;
 	ksegment->bufsz = kbuf->bufsz;
 	ksegment->mem = kbuf->mem;
 	ksegment->memsz = kbuf->memsz;
-	image->nr_segments++;
-	*load_addr = ksegment->mem;
+	kbuf->image->nr_segments++;
 	return 0;
 }
 
@@ -630,13 +623,15 @@ static int __kexec_load_purgatory(struct
 				  unsigned long max, int top_down)
 {
 	struct purgatory_info *pi = &image->purgatory_info;
-	unsigned long align, buf_align, bss_align, buf_sz, bss_sz, bss_pad;
-	unsigned long memsz, entry, load_addr, curr_load_addr, bss_addr, offset;
+	unsigned long align, bss_align, bss_sz, bss_pad;
+	unsigned long entry, load_addr, curr_load_addr, bss_addr, offset;
 	unsigned char *buf_addr, *src;
 	int i, ret = 0, entry_sidx = -1;
 	const Elf_Shdr *sechdrs_c;
 	Elf_Shdr *sechdrs = NULL;
-	void *purgatory_buf = NULL;
+	struct kexec_buf kbuf = { .image = image, .bufsz = 0, .buf_align = 1,
+				  .buf_min = min, .buf_max = max,
+				  .top_down = top_down };
 
 	/*
 	 * sechdrs_c points to section headers in purgatory and are read
@@ -702,9 +697,7 @@ static int __kexec_load_purgatory(struct
 	}
 
 	/* Determine how much memory is needed to load relocatable object. */
-	buf_align = 1;
 	bss_align = 1;
-	buf_sz = 0;
 	bss_sz = 0;
 
 	for (i = 0; i < pi->ehdr->e_shnum; i++) {
@@ -713,10 +706,10 @@ static int __kexec_load_purgatory(struct
 
 		align = sechdrs[i].sh_addralign;
 		if (sechdrs[i].sh_type != SHT_NOBITS) {
-			if (buf_align < align)
-				buf_align = align;
-			buf_sz = ALIGN(buf_sz, align);
-			buf_sz += sechdrs[i].sh_size;
+			if (kbuf.buf_align < align)
+				kbuf.buf_align = align;
+			kbuf.bufsz = ALIGN(kbuf.bufsz, align);
+			kbuf.bufsz += sechdrs[i].sh_size;
 		} else {
 			/* bss section */
 			if (bss_align < align)
@@ -728,32 +721,31 @@ static int __kexec_load_purgatory(struct
 
 	/* Determine the bss padding required to align bss properly */
 	bss_pad = 0;
-	if (buf_sz & (bss_align - 1))
-		bss_pad = bss_align - (buf_sz & (bss_align - 1));
+	if (kbuf.bufsz & (bss_align - 1))
+		bss_pad = bss_align - (kbuf.bufsz & (bss_align - 1));
 
-	memsz = buf_sz + bss_pad + bss_sz;
+	kbuf.memsz = kbuf.bufsz + bss_pad + bss_sz;
 
 	/* Allocate buffer for purgatory */
-	purgatory_buf = vzalloc(buf_sz);
-	if (!purgatory_buf) {
+	kbuf.buffer = vzalloc(kbuf.bufsz);
+	if (!kbuf.buffer) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	if (buf_align < bss_align)
-		buf_align = bss_align;
+	if (kbuf.buf_align < bss_align)
+		kbuf.buf_align = bss_align;
 
 	/* Add buffer to segment list */
-	ret = kexec_add_buffer(image, purgatory_buf, buf_sz, memsz,
-				buf_align, min, max, top_down,
-				&pi->purgatory_load_addr);
+	ret = kexec_add_buffer(&kbuf);
 	if (ret)
 		goto out;
+	pi->purgatory_load_addr = kbuf.mem;
 
 	/* Load SHF_ALLOC sections */
-	buf_addr = purgatory_buf;
+	buf_addr = kbuf.buffer;
 	load_addr = curr_load_addr = pi->purgatory_load_addr;
-	bss_addr = load_addr + buf_sz + bss_pad;
+	bss_addr = load_addr + kbuf.bufsz + bss_pad;
 
 	for (i = 0; i < pi->ehdr->e_shnum; i++) {
 		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
@@ -799,11 +791,11 @@ static int __kexec_load_purgatory(struct
 	 * Used later to identify which section is purgatory and skip it
 	 * from checksumming.
 	 */
-	pi->purgatory_buf = purgatory_buf;
+	pi->purgatory_buf = kbuf.buffer;
 	return ret;
 out:
 	vfree(sechdrs);
-	vfree(purgatory_buf);
+	vfree(kbuf.buffer);
 	return ret;
 }
 
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

