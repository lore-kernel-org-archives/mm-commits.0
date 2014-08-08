From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-implementation-of-new-syscall-kexec_file_load-fix.patch removed from
 -mm tree
Date: Fri, 08 Aug 2014 14:02:16 -0700
Message-ID: <53e53ad8.ytEuTUaKK2N8gfBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:60130 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbaHHVCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:02:17 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1559808pde.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:02:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: return error if file bytes are less then file size
has been removed from the -mm tree.  Its filename was
     kexec-implementation-of-new-syscall-kexec_file_load-fix.patch

This patch was dropped because it was folded into kexec-implementation-of-new-syscall-kexec_file_load.patch

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: return error if file bytes are less then file size

If number of bytes read from file are not same as file size, return error.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-implementation-of-new-syscall-kexec_file_load-fix
+++ a/kernel/kexec.c
@@ -332,7 +332,7 @@ out_free_image:
 static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
 {
 	struct fd f = fdget(fd);
-	int ret = 0;
+	int ret;
 	struct kstat stat;
 	loff_t pos;
 	ssize_t bytes = 0;
@@ -376,6 +376,12 @@ static int copy_file_from_fd(int fd, voi
 		pos += bytes;
 	}
 
+	if (pos != stat.size) {
+		ret = -EBADF;
+		vfree(*buf);
+		goto out;
+	}
+
 	*buf_len = pos;
 out:
 	fdput(f);
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
purgatory-core-purgatory-functionality-fix.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch

