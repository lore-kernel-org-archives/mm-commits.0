From: akpm@linux-foundation.org
Subject: + kexec-implementation-of-new-syscall-kexec_file_load-fix.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 13:32:18 -0700
Message-ID: <53b31ad2.opKRLuzH/phV8V8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:36556 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaGAUcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 16:32:19 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2341011obc.1
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 13:32:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: return error if file bytes are less then file size
has been added to the -mm tree.  Its filename is
     kexec-implementation-of-new-syscall-kexec_file_load-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-implementation-of-new-syscall-kexec_file_load-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-implementation-of-new-syscall-kexec_file_load-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -331,7 +331,7 @@ out_free_image:
 static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
 {
 	struct fd f = fdget(fd);
-	int ret = 0;
+	int ret;
 	struct kstat stat;
 	loff_t pos;
 	ssize_t bytes = 0;
@@ -375,6 +375,12 @@ static int copy_file_from_fd(int fd, voi
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

bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-fix.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

