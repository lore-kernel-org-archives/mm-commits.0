Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DCB210F59
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220410; cv=none; b=rYqn5mqAkACRpVL7zS5//J8woNlnj6dQao7SV0gLJ9VYD52YkIWn8sDMW/77wnmnl2RyZ7T+qtP1TZ4meU1z10NpnZbnum/9vlSRmmUDO6CVdP/gVnwMFUU51+sXEdUyDbiNek7pM2AEqaX7sZ1ef6pOGUT3jxPr6O5yvUW5UkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220410; c=relaxed/simple;
	bh=0bh+pzeXzdVR7Ms8LQA9+l8O1+8icYeJZM2oQ5sEeyY=;
	h=Date:To:From:Subject:Message-Id; b=in/93SRllJfrSiwwOlgmPhHCSQDB0jwqplwy8Y5Q6q0NtNydKdogiOCiCSExHISjZWBTxOKy1ADUIqsFaX4Zb1uHBkhEbL61IQWG39cVZ1oA8zeAR9BXtazoO4Ns6zx2/RLZmJOgFLnlFuzpn6UhZ9GYlS1X/j/E56ovW2vA0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=igebaTB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="igebaTB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E382EC4CEE7;
	Tue,  4 Nov 2025 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762220410;
	bh=0bh+pzeXzdVR7Ms8LQA9+l8O1+8icYeJZM2oQ5sEeyY=;
	h=Date:To:From:Subject:From;
	b=igebaTB21a98SFQaV7QA6R9XImwLvPvxyXXjzAcH62SG4UptHL3Pj01tx1cZysVbe
	 ElX9LS2Q7O8fLa+ds0AaH7D62kaIeS3GSqjV/ujlWBfhvPwDAE3yRceXlBF1OkIptA
	 yQ73CGeCLm1gcQ7bU34TtGj144f8CJuLVt4tIuCE=
Date: Mon, 03 Nov 2025 17:40:09 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kexec_core-flag-to-control-debug-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20251104014009.E382EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add kexec_core flag to control debug printing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-kexec_core-flag-to-control-debug-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kexec_core-flag-to-control-debug-printing.patch

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
Subject: kexec: add kexec_core flag to control debug printing
Date: Mon, 3 Nov 2025 14:34:38 +0800

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

Since kexec_load and kexec_file_load are not triggered simultaneously, we
can unify the debug flag of kexec and kexec_file as kexec_core_dbg_print.

Next, we need to do four things:

1. rename kexec_file_dbg_print to kexec_core_dbg_print
2. Add KEXEC_DEBUG
3. Initialize kexec_core_dbg_print for kexec
4. Set the reset of kexec_file_dbg_print to kimage_free

Link: https://lkml.kernel.org/r/20251103063440.1681657-3-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h      |    9 +++++----
 include/uapi/linux/kexec.h |    1 +
 kernel/kexec.c             |    1 +
 kernel/kexec_core.c        |    4 +++-
 kernel/kexec_file.c        |    4 +---
 5 files changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/kexec.h~kexec-add-kexec_core-flag-to-control-debug-printing
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
+extern bool kexec_core_dbg_print;
 
 #define kexec_dprintk(fmt, arg...) \
-        do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
+	do { if (kexec_core_dbg_print) pr_info(fmt, ##arg); } while (0)
 
 extern void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size);
 extern void kimage_unmap_segment(void *buffer);
--- a/include/uapi/linux/kexec.h~kexec-add-kexec_core-flag-to-control-debug-printing
+++ a/include/uapi/linux/kexec.h
@@ -14,6 +14,7 @@
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_UPDATE_ELFCOREHDR	0x00000004
 #define KEXEC_CRASH_HOTPLUG_SUPPORT 0x00000008
+#define KEXEC_DEBUG		0x00000010
 #define KEXEC_ARCH_MASK		0xffff0000
 
 /*
--- a/kernel/kexec.c~kexec-add-kexec_core-flag-to-control-debug-printing
+++ a/kernel/kexec.c
@@ -42,6 +42,7 @@ static int kimage_alloc_init(struct kima
 	if (!image)
 		return -ENOMEM;
 
+	kexec_core_dbg_print = !!(flags & KEXEC_DEBUG);
 	image->start = entry;
 	image->nr_segments = nr_segments;
 	memcpy(image->segment, segments, nr_segments * sizeof(*segments));
--- a/kernel/kexec_core.c~kexec-add-kexec_core-flag-to-control-debug-printing
+++ a/kernel/kexec_core.c
@@ -53,7 +53,7 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
-bool kexec_file_dbg_print;
+bool kexec_core_dbg_print;
 
 /*
  * When kexec transitions to the new kernel there is a one-to-one
@@ -576,6 +576,8 @@ void kimage_free(struct kimage *image)
 	kimage_entry_t *ptr, entry;
 	kimage_entry_t ind = 0;
 
+	kexec_core_dbg_print = false;
+
 	if (!image)
 		return;
 
--- a/kernel/kexec_file.c~kexec-add-kexec_core-flag-to-control-debug-printing
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
+	kexec_core_dbg_print = !!(flags & KEXEC_FILE_DEBUG);
 	image->file_mode = 1;
 
 #ifdef CONFIG_CRASH_DUMP
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec_core-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

