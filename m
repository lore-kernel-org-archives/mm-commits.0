From: akpm@linux-foundation.org
Subject: [folded-merged] inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:13:03 -0700
Message-ID: <20130430221304.4100931C2C5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37565 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3D3WNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:13:06 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so113488yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:13:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Jim.Somerville@windriver.com, eparis@parisplace.org, jmarchan@redhat.com, paul.gortmaker@windriver.com, zhaohongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix
has been removed from the -mm tree.  Its filename was
     inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch

This patch was dropped because it was folded into inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix

fix build

Cc: Eric Paris <eparis@parisplace.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Jim Somerville <Jim.Somerville@windriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix
+++ a/fs/notify/inotify/inotify_user.c
@@ -750,7 +750,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	unsigned flags = 0;
 
 	/* don't allow invalid bits: we don't want flags set */
-	if (unlikely(!(arg & ALL_INOTIFY_BITS)))
+	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
 		return -EINVAL;
 
 	f = fdget(fd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

