From: akpm@linux-foundation.org
Subject: [merged] kexec-do-a-cleanup-for-function-kexec_load.patch removed from -mm tree
Date: Fri, 27 May 2016 11:43:42 -0700
Message-ID: <5748955e.KJyFB/DAlcKSzngk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbcE0Snn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, xlpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: do a cleanup for function kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-do-a-cleanup-for-function-kexec_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: do a cleanup for function kexec_load

There are a lof of work to be done in function kexec_load, not only for
allocating structs and loading initram, but also for some misc.

To make it more clear, wrap a new function do_kexec_load which is used to
allocate structs and load initram.  And the pre-work will be done in
kexec_load.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Xunlei Pang <xlpang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |  125 +++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

diff -puN kernel/kexec.c~kexec-do-a-cleanup-for-function-kexec_load kernel/kexec.c
--- a/kernel/kexec.c~kexec-do-a-cleanup-for-function-kexec_load
+++ a/kernel/kexec.c
@@ -103,6 +103,74 @@ out_free_image:
 	return ret;
 }
 
+static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
+		struct kexec_segment __user *segments, unsigned long flags)
+{
+	struct kimage **dest_image, *image;
+	unsigned long i;
+	int ret;
+
+	if (flags & KEXEC_ON_CRASH) {
+		dest_image = &kexec_crash_image;
+		if (kexec_crash_image)
+			arch_kexec_unprotect_crashkres();
+	} else {
+		dest_image = &kexec_image;
+	}
+
+	if (nr_segments == 0) {
+		/* Uninstall image */
+		kimage_free(xchg(dest_image, NULL));
+		return 0;
+	}
+	if (flags & KEXEC_ON_CRASH) {
+		/*
+		 * Loading another kernel to switch to if this one
+		 * crashes.  Free any current crash dump kernel before
+		 * we corrupt it.
+		 */
+		kimage_free(xchg(&kexec_crash_image, NULL));
+	}
+
+	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
+	if (ret)
+		return ret;
+
+	if (flags & KEXEC_ON_CRASH)
+		crash_map_reserved_pages();
+
+	if (flags & KEXEC_PRESERVE_CONTEXT)
+		image->preserve_context = 1;
+
+	ret = machine_kexec_prepare(image);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < nr_segments; i++) {
+		ret = kimage_load_segment(image, &image->segment[i]);
+		if (ret)
+			goto out;
+	}
+
+	kimage_terminate(image);
+
+	/* Install the new kernel and uninstall the old */
+	image = xchg(dest_image, image);
+
+out:
+	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
+		arch_kexec_protect_crashkres();
+
+	/*
+	 * Once the reserved memory is mapped, we should unmap this memory
+	 * before returning
+	 */
+	if (flags & KEXEC_ON_CRASH)
+		crash_unmap_reserved_pages();
+	kimage_free(image);
+	return ret;
+}
+
 /*
  * Exec Kernel system call: for obvious reasons only root may call it.
  *
@@ -127,7 +195,6 @@ out_free_image:
 SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		struct kexec_segment __user *, segments, unsigned long, flags)
 {
-	struct kimage **dest_image, *image;
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
@@ -152,9 +219,6 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 	if (nr_segments > KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
-	image = NULL;
-	result = 0;
-
 	/* Because we write directly to the reserved memory
 	 * region when loading crash kernels we need a mutex here to
 	 * prevent multiple crash  kernels from attempting to load
@@ -166,63 +230,12 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 
-	dest_image = &kexec_image;
-	if (flags & KEXEC_ON_CRASH) {
-		dest_image = &kexec_crash_image;
-		if (kexec_crash_image)
-			arch_kexec_unprotect_crashkres();
-	}
-
-	if (nr_segments > 0) {
-		unsigned long i;
-
-		if (flags & KEXEC_ON_CRASH) {
-			/*
-			 * Loading another kernel to switch to if this one
-			 * crashes.  Free any current crash dump kernel before
-			 * we corrupt it.
-			 */
-
-			kimage_free(xchg(&kexec_crash_image, NULL));
-			result = kimage_alloc_init(&image, entry, nr_segments,
-						   segments, flags);
-			crash_map_reserved_pages();
-		} else {
-			/* Loading another kernel to reboot into. */
-
-			result = kimage_alloc_init(&image, entry, nr_segments,
-						   segments, flags);
-		}
-		if (result)
-			goto unmap_page;
-
-		if (flags & KEXEC_PRESERVE_CONTEXT)
-			image->preserve_context = 1;
-		result = machine_kexec_prepare(image);
-		if (result)
-			goto unmap_page;
-
-		for (i = 0; i < nr_segments; i++) {
-			result = kimage_load_segment(image, &image->segment[i]);
-			if (result)
-				goto unmap_page;
-		}
-		kimage_terminate(image);
-unmap_page:
-		if (flags & KEXEC_ON_CRASH)
-			crash_unmap_reserved_pages();
-		if (result)
-			goto out;
-	}
-	/* Install the new kernel, and  Uninstall the old */
-	image = xchg(dest_image, image);
+	result = do_kexec_load(entry, nr_segments, segments, flags);
 
-out:
 	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
 	mutex_unlock(&kexec_mutex);
-	kimage_free(image);
 
 	return result;
 }
_

Patches currently in -mm which might be from mnfhuang@gmail.com are


