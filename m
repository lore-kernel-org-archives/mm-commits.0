From: akpm@linux-foundation.org
Subject: [nacked]
 fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:29:45 -0700
Message-ID: <53ea6b29.kCiLNmDCwiVozDGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:60186 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaHLT3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:29:46 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2667268pdj.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:29:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cachefiles/daemon.c: remove unnecessary tests on unsigned values
has been removed from the -mm tree.  Its filename was
     fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cachefiles/daemon.c: remove unnecessary tests on unsigned values

size_t and unsigned long values are never < 0

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/daemon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/cachefiles/daemon.c~fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values
+++ a/fs/cachefiles/daemon.c
@@ -222,7 +222,7 @@ static ssize_t cachefiles_daemon_write(s
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
@@ -385,7 +385,7 @@ static int cachefiles_daemon_fstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -457,7 +457,7 @@ static int cachefiles_daemon_bstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
init-mainc-code-clean-up.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

