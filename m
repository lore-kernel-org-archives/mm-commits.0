Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7992430AD10
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769487912; cv=none; b=RkQwZ2geJ7pzLQp9mV8UQoUYZWJ1DCKt8u7MI4F1ufJ0BkVJVLE/zpG5fhU5ASc2IhU70FcZY+uNdYOqFE4DXqWhOg3a9sJAq3JNa9cVI+MFgYrXovdHuwPd9CX+z+b6z5kKH6Uj06wugiH85NPactCWygqPisGlhavTP0N0nQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769487912; c=relaxed/simple;
	bh=FobT0MJtxvBVBOLOPhlXPGhmeK2HFQzsqvYCXy2r2RE=;
	h=Date:To:From:Subject:Message-Id; b=plUy/B0Av2oueNcSRhU9ucsSI/AaOhuTEmM//I9hAw7uwqh+MhR67CE/vOhHiNBMdpdLyi6NO2TWkanOAjCaf0FTGSOGmsk7finjyXirsxGC5rQlPM9X7FUxibdKIdEKI6OgMES/DjE5aocwT3u9Fv/0tHy2t94LeRkWU6A+8js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXUxUOXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXUxUOXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13110C116C6;
	Tue, 27 Jan 2026 04:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769487912;
	bh=FobT0MJtxvBVBOLOPhlXPGhmeK2HFQzsqvYCXy2r2RE=;
	h=Date:To:From:Subject:From;
	b=iXUxUOXsszE/eDM79QYFHr4xDL6Gtov/oSw6nHOX6BjfpNiW6xzmmUP6X7sJNPNuB
	 X5s3uVf41JRzm60/1kGoqHqV7xZf1qp3NkdD/R9iH15otVfidZa1siLjEflNTXxEFN
	 mE31nnnJpI/Kwqq8aMWBMo9zyDMsLUwt5XTKS33Q=
Date: Mon, 26 Jan 2026 20:25:11 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kexec-add-kexec-flag-to-control-debug-printing.patch removed from -mm tree
Message-Id: <20260127042512.13110C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: add kexec flag to control debug printing
has been removed from the -mm tree.  Its filename was
     kexec-add-kexec-flag-to-control-debug-printing.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: add kexec flag to control debug printing
Date: Fri, 19 Dec 2025 17:31:32 +0800

commit cbc2fe9d9cb2 ("kexec_file: add kexec_file flag to control debug
printing") added the kexec_file flag to control debug printing.  However,
for arm64, after commit 6f8c1da071a4 ("kexec_file, arm64: print out
debugging message if required"), when using the kexec_load interface, the
kexec_image_info function is called to print debug message, but it uses
kexec_dprintk, which is only available under kexec_file, then when
specifying 'kexec -d', kexec_load interface will print nothing.

For riscv, commit eb7622d908a09 ("kexec_file, riscv: print out debugging
message if required") remove kexec_image_info(), because the content has
been printed out in generic code in kexec_file_load, but not in
kexec_load.

Therefore, in order to solve the two problems mentioned above, for this
patchset, several things need to be done:

1. Enabling kexec_dprintk is available for kexec_load.
2. Add some debugging message of the deleted kexec_image_info
   to generic code.
3. Remove duplicate debugging prints for arm64

Since kexec_load and kexec_file_load are not triggered simultaneously,
we can unify the debug flag of kexec and kexec_file as kexec_dbg_print.

In this way, kexec_dprintk is available for kexec_load and kexec_file_load.

The following are the key points of the specific changes:

1. rename kexec_file_dbg_print to kexec_dbg_print
2. Add KEXEC_DEBUG
3. Initialize kexec_dbg_print for kexec
4. Set the reset of kexec_dbg_print to kimage_free

Link: https://lkml.kernel.org/r/20251219093134.2268620-3-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
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
 
 extern void *kimage_map_segment(struct kimage *image, int idx);
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

kexec-print-out-debugging-message-if-required-for-kexec_load.patch
arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

