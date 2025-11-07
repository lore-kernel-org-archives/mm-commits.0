Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2DA1DE8BB;
	Fri,  7 Nov 2025 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762475404; cv=none; b=LS53SANfxUfNVIDYiTGaoPZ/nTwjSMAvCnw5/YfCfTXNAvQ+08NKuxgKPpn95CbMOkcbZDAlxgysNOGiT9HPJM/c9OuEBELs0Lr748bIg5tWWqLDbnzWefUjAgr/U0RUZJJz3DG5kA7osqnDGp2GDLYeLR3w8dZxc4DWz4SiUPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762475404; c=relaxed/simple;
	bh=ENWf/WaHKFeQ+/30Bpo8P3+g7idfxsSHhsdHGjqtbHI=;
	h=Date:To:From:Subject:Message-Id; b=YYIwUWNjXiRBSLzHe04UWWjzrfuyG/Tr/S1vjxcB6lGTrtI/6N9Xsg8a5sGSYBi9YRB85zd1izC/OC7RnptZRyw27k+/0xzZYBxLaNXTKG/cyA+4LZDFxIM/ri8yTXOkbVfLRCI6yUfX+ZOoId5cXerhCGx3fXy2cy72B7qwnRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFjinwLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFjinwLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909C4C4CEF7;
	Fri,  7 Nov 2025 00:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762475403;
	bh=ENWf/WaHKFeQ+/30Bpo8P3+g7idfxsSHhsdHGjqtbHI=;
	h=Date:To:From:Subject:From;
	b=FFjinwLtTHKa8D9wR2j8SOgYLFcdHp2783gYuKErcORJRmPGm4LDI/LUKgxIvHt5K
	 mzgaeEYfh9jpvHkWIckp2DCaqA1olsU1s9dev8dLosL8pKBlL8qykoJnvpn6XF9XuU
	 rsVQd3ZZAE6jlyX9/E0KXhKH6nLVu+xPcgIRKq80=
Date: Thu, 06 Nov 2025 16:30:01 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,stable@vger.kernel.org,roberto.sassu@huawei.com,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kernel-kexec-change-the-prototype-of-kimage_map_segment.patch removed from -mm tree
Message-Id: <20251107003003.909C4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/kexec: change the prototype of kimage_map_segment()
has been removed from the -mm tree.  Its filename was
     kernel-kexec-change-the-prototype-of-kimage_map_segment.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Pingfan Liu <piliu@redhat.com>
Subject: kernel/kexec: change the prototype of kimage_map_segment()
Date: Wed, 5 Nov 2025 21:09:21 +0800

The kexec segment index will be required to extract the corresponding
information for that segment in kimage_map_segment(). Additionally,
kexec_segment already holds the kexec relocation destination address and
size. Therefore, the prototype of kimage_map_segment() can be changed.

Link: https://lkml.kernel.org/r/20251105130922.13321-1-piliu@redhat.com
Fixes: 0091d9241ea2 ("kexec: define functions to map and unmap segments")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Steven Chen <chenste@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h              |    4 ++--
 kernel/kexec_core.c                |    9 ++++++---
 security/integrity/ima/ima_kexec.c |    4 +---
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/kexec.h~kernel-kexec-change-the-prototype-of-kimage_map_segment
+++ a/include/linux/kexec.h
@@ -530,7 +530,7 @@ extern bool kexec_file_dbg_print;
 #define kexec_dprintk(fmt, arg...) \
         do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
 
-extern void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size);
+extern void *kimage_map_segment(struct kimage *image, int idx);
 extern void kimage_unmap_segment(void *buffer);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
@@ -540,7 +540,7 @@ static inline void __crash_kexec(struct
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 static inline int kexec_crash_loaded(void) { return 0; }
-static inline void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size)
+static inline void *kimage_map_segment(struct kimage *image, int idx)
 { return NULL; }
 static inline void kimage_unmap_segment(void *buffer) { }
 #define kexec_in_progress false
--- a/kernel/kexec_core.c~kernel-kexec-change-the-prototype-of-kimage_map_segment
+++ a/kernel/kexec_core.c
@@ -960,17 +960,20 @@ int kimage_load_segment(struct kimage *i
 	return result;
 }
 
-void *kimage_map_segment(struct kimage *image,
-			 unsigned long addr, unsigned long size)
+void *kimage_map_segment(struct kimage *image, int idx)
 {
+	unsigned long addr, size, eaddr;
 	unsigned long src_page_addr, dest_page_addr = 0;
-	unsigned long eaddr = addr + size;
 	kimage_entry_t *ptr, entry;
 	struct page **src_pages;
 	unsigned int npages;
 	void *vaddr = NULL;
 	int i;
 
+	addr = image->segment[idx].mem;
+	size = image->segment[idx].memsz;
+	eaddr = addr + size;
+
 	/*
 	 * Collect the source pages and map them in a contiguous VA range.
 	 */
--- a/security/integrity/ima/ima_kexec.c~kernel-kexec-change-the-prototype-of-kimage_map_segment
+++ a/security/integrity/ima/ima_kexec.c
@@ -250,9 +250,7 @@ void ima_kexec_post_load(struct kimage *
 	if (!image->ima_buffer_addr)
 		return;
 
-	ima_kexec_buffer = kimage_map_segment(image,
-					      image->ima_buffer_addr,
-					      image->ima_buffer_size);
+	ima_kexec_buffer = kimage_map_segment(image, image->ima_segment_index);
 	if (!ima_kexec_buffer) {
 		pr_err("Could not map measurements buffer.\n");
 		return;
_

Patches currently in -mm which might be from piliu@redhat.com are

kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

