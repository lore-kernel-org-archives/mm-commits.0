Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C49D281376
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764179682; cv=none; b=JmrTmk1LJHNx2f+m11wIcv1j0SALQnB8NvMPbp6OH5WVcuXNajP3FTe5JY6fr01MkoCc9YfpZi4xOWQ+SXehQPsNEvgpEF7LXReoBUYuLKMKD8pMPlyTiRqM2MhaaNfDvERyT05k3GWaRbssphoLGpvItfOjD2+F/wUv4UCkQuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764179682; c=relaxed/simple;
	bh=E5rBs/vSaX8eL2Dn4FxhCSc52GbFUxnkEh7Z5k+o5/0=;
	h=Date:To:From:Subject:Message-Id; b=PFjIjs9ASegyGIb0mOs0I/4HHY7ef5jo01XXdpdlBD7SKYLiUVOdr+x8MrOXJe1+lXuysd7lXfOyjvzgd/XZZ35MvX0uSrGyp4uotPBn25Wb2MXz7aEHnDRUwlAdsmjGgy/VLOyOIG6raQ+1scqsNbynZf6Fw1d3pmqBCLu1Sus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0zyyES/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0zyyES/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAC1C4CEF7;
	Wed, 26 Nov 2025 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764179681;
	bh=E5rBs/vSaX8eL2Dn4FxhCSc52GbFUxnkEh7Z5k+o5/0=;
	h=Date:To:From:Subject:From;
	b=0zyyES/YKjzUiCp6z2ieUVKQAl44qRYWHz6Yi5vjNSOtgQ46JM4wurO4K7wU4s0eP
	 tQsZQD/s3PPMy0JMeoKy8IcPSZWF3PA6kpzEq2pV3nGsn1Rz1JRF2CdjrAnsSIShpD
	 dOpuF6yXoWyGwn/Fs2Km1fQfmOIlpRNnJGfNl2qg=
Date: Wed, 26 Nov 2025 09:54:41 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kexec-flag-to-control-debug-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20251126175441.DBAC1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add kexec flag to control debug printing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-kexec-flag-to-control-debug-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kexec-flag-to-control-debug-printing.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: add kexec flag to control debug printing
Date: Wed, 26 Nov 2025 16:44:26 +0800

commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

Since kexec_load and kexec_file_load are not triggered simultaneously, we
can unify the debug flag of kexec and kexec_file as kexec_dbg_print.

Next, we need to do four things:

1. rename kexec_file_dbg_print to kexec_dbg_print
2. Add KEXEC_DEBUG
3. Initialize kexec_dbg_print for kexec
4. Set the reset of kexec_dbg_print to kimage_free

Link: https://lkml.kernel.org/r/20251126084427.3222212-3-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h      |    9 +++++----
 include/uapi/linux/kexec.h |    1 +
 kernel/kexec.c             |    1 +
 kernel/kexec_core.c        |    4 +++-
 kernel/kexec_file.c        |    4 +---
 5 files changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/kexec.h~kexec-add-kexec-flag-to-control-debug-printing
+++ a/include/linux/kexec.h
@@ -455,10 +455,11 @@ bool kexec_load_permitted(int kexec_imag
 
 /* List of defined/legal kexec flags */
 #ifndef CONFIG_KEXEC_JUMP
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_UPDATE_ELFCOREHDR | KEXEC_CRASH_HOTPLUG_SUPPORT)
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_UPDATE_ELFCOREHDR | KEXEC_CRASH_HOTPLUG_SUPPORT | \
+			KEXEC_DEBUG)
 #else
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT | KEXEC_UPDATE_ELFCOREHDR | \
-			KEXEC_CRASH_HOTPLUG_SUPPORT)
+			KEXEC_CRASH_HOTPLUG_SUPPORT | KEXEC_DEBUG)
 #endif
 
 /* List of defined/legal kexec file flags */
@@ -525,10 +526,10 @@ static inline int arch_kexec_post_alloc_
 static inline void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages) { }
 #endif
 
-extern bool kexec_file_dbg_print;
+extern bool kexec_dbg_print;
 
 #define kexec_dprintk(fmt, arg...) \
-        do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
+	do { if (kexec_dbg_print) pr_info(fmt, ##arg); } while (0)
 
 extern void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size);
 extern void kimage_unmap_segment(void *buffer);
--- a/include/uapi/linux/kexec.h~kexec-add-kexec-flag-to-control-debug-printing
+++ a/include/uapi/linux/kexec.h
@@ -14,6 +14,7 @@
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_UPDATE_ELFCOREHDR	0x00000004
 #define KEXEC_CRASH_HOTPLUG_SUPPORT 0x00000008
+#define KEXEC_DEBUG		0x00000010
 #define KEXEC_ARCH_MASK		0xffff0000
 
 /*
--- a/kernel/kexec.c~kexec-add-kexec-flag-to-control-debug-printing
+++ a/kernel/kexec.c
@@ -42,6 +42,7 @@ static int kimage_alloc_init(struct kima
 	if (!image)
 		return -ENOMEM;
 
+	kexec_dbg_print = !!(flags & KEXEC_DEBUG);
 	image->start = entry;
 	image->nr_segments = nr_segments;
 	memcpy(image->segment, segments, nr_segments * sizeof(*segments));
--- a/kernel/kexec_core.c~kexec-add-kexec-flag-to-control-debug-printing
+++ a/kernel/kexec_core.c
@@ -55,7 +55,7 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
-bool kexec_file_dbg_print;
+bool kexec_dbg_print;
 
 /*
  * When kexec transitions to the new kernel there is a one-to-one
@@ -578,6 +578,8 @@ void kimage_free(struct kimage *image)
 	kimage_entry_t *ptr, entry;
 	kimage_entry_t ind = 0;
 
+	kexec_dbg_print = false;
+
 	if (!image)
 		return;
 
--- a/kernel/kexec_file.c~kexec-add-kexec-flag-to-control-debug-printing
+++ a/kernel/kexec_file.c
@@ -138,8 +138,6 @@ void kimage_file_post_load_cleanup(struc
 	 */
 	kfree(image->image_loader_data);
 	image->image_loader_data = NULL;
-
-	kexec_file_dbg_print = false;
 }
 
 #ifdef CONFIG_KEXEC_SIG
@@ -314,7 +312,7 @@ kimage_file_alloc_init(struct kimage **r
 	if (!image)
 		return -ENOMEM;
 
-	kexec_file_dbg_print = !!(flags & KEXEC_FILE_DEBUG);
+	kexec_dbg_print = !!(flags & KEXEC_FILE_DEBUG);
 	image->file_mode = 1;
 
 #ifdef CONFIG_CRASH_DUMP
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch

