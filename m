Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6200C28C87D;
	Tue, 16 Dec 2025 02:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851322; cv=none; b=YrdDPKFcwPiFbiuHeaXcvZmWj0v+pocm+gECsJu6VlYPOoWcJHbjeqOoFm//kIOG1i6ZuzobBja3vu4+8fc3n/DlSCRTpcSDJNIPjAF0Eurs+GgK3PRT+N2wDhICByu71yyvtb7K6TXsK1DlvTOgb/aG/bD5UlCz7qJhkjNlgRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851322; c=relaxed/simple;
	bh=eb16KSUvuCScgGWO6rxafVihCvwAPgakNgRO9khqLkU=;
	h=Date:To:From:Subject:Message-Id; b=TpXERbrjoM12Rdol6VsUgF9WLxnxEPbuFxSLtRTX4JenalGUx7+xCGMzwP4YGhasMN5MfkYK5vFpGTcChysbISdItDVUi5ckRrG+8VPMWo7mResBhNWS7TwwouGFrSFKC/WuwfK0Beb7+LgL4VvNEDYEH99VpWtuHfA+ijNu79k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MGULiOOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MGULiOOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D494BC4CEFB;
	Tue, 16 Dec 2025 02:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851321;
	bh=eb16KSUvuCScgGWO6rxafVihCvwAPgakNgRO9khqLkU=;
	h=Date:To:From:Subject:From;
	b=MGULiOOmiDUrSE0hc0d13WZ8cCxzGuj1xF9uJzujrmvrRw2neXkxjxKiJBe1fNquj
	 juYm4FdO6GQTebFLEjq/srrfeB6GX9DyoLo792tc/Z3oCjdIm35RQe3wJj0l1R9+QB
	 s+Df/uMRJ2wbnH8ZonIbAB4jJU0hJe7L1mZT7UBs=
Date: Mon, 15 Dec 2025 18:15:21 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,stable@vger.kernel.org,roberto.sassu@huawei.com,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kexec-change-the-prototype-of-kimage_map_segment.patch added to mm-hotfixes-unstable branch
Message-Id: <20251216021521.D494BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/kexec: change the prototype of kimage_map_segment()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kernel-kexec-change-the-prototype-of-kimage_map_segment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-kexec-change-the-prototype-of-kimage_map_segment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pingfan Liu <piliu@redhat.com>
Subject: kernel/kexec: change the prototype of kimage_map_segment()
Date: Tue, 16 Dec 2025 09:48:51 +0800

The kexec segment index will be required to extract the corresponding
information for that segment in kimage_map_segment().  Additionally,
kexec_segment already holds the kexec relocation destination address and
size.  Therefore, the prototype of kimage_map_segment() can be changed.

Link: https://lkml.kernel.org/r/20251216014852.8737-1-piliu@redhat.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
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
@@ -953,17 +953,20 @@ int kimage_load_segment(struct kimage *i
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

kernel-kexec-change-the-prototype-of-kimage_map_segment.patch
kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

