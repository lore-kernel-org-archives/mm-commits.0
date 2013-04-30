From: akpm@linux-foundation.org
Subject: [folded-merged] kexec-use-min_t-to-simplify-logic-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:18:23 -0700
Message-ID: <20130430221823.CB58831C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34378 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3WSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:18:25 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so114070qcr.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:18:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-use-min_t-to-simplify-logic-fix
has been removed from the -mm tree.  Its filename was
     kexec-use-min_t-to-simplify-logic-fix.patch

This patch was dropped because it was folded into kexec-use-min_t-to-simplify-logic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-use-min_t-to-simplify-logic-fix

replace min_t with min, remove unneeded casts

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Perches <joe@perches.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/kexec.c~kexec-use-min_t-to-simplify-logic-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-min_t-to-simplify-logic-fix
+++ a/kernel/kexec.c
@@ -820,8 +820,8 @@ static int kimage_load_normal_segment(st
 		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
-			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
-		uchunk = min_t(size_t, ubytes, mchunk);
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
 
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
@@ -868,8 +868,8 @@ static int kimage_load_crash_segment(str
 		ptr = kmap(page);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
-			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
-		uchunk = min_t(size_t, ubytes, mchunk);
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
 		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
@@ -1539,7 +1539,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
+	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kexec-use-min_t-to-simplify-logic.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

