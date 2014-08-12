From: akpm@linux-foundation.org
Subject: [nacked] fs-cachefiles-bindc-remove-unnecessary-assertions.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:30:36 -0700
Message-ID: <53ea6b5c.fP+5MigQlPTsDcSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:37233 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaHLTah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:30:37 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1308334qgd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:30:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cachefiles/bind.c: remove unnecessary assertions
has been removed from the -mm tree.  Its filename was
     fs-cachefiles-bindc-remove-unnecessary-assertions.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cachefiles/bind.c: remove unnecessary assertions

Unsigned values are always >=0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/bind.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/cachefiles/bind.c~fs-cachefiles-bindc-remove-unnecessary-assertions fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~fs-cachefiles-bindc-remove-unnecessary-assertions
+++ a/fs/cachefiles/bind.c
@@ -39,13 +39,11 @@ int cachefiles_daemon_bind(struct cachef
 	       args);
 
 	/* start by checking things over */
-	ASSERT(cache->fstop_percent >= 0 &&
-	       cache->fstop_percent < cache->fcull_percent &&
+	ASSERT(cache->fstop_percent < cache->fcull_percent &&
 	       cache->fcull_percent < cache->frun_percent &&
 	       cache->frun_percent  < 100);
 
-	ASSERT(cache->bstop_percent >= 0 &&
-	       cache->bstop_percent < cache->bcull_percent &&
+	ASSERT(cache->bstop_percent < cache->bcull_percent &&
 	       cache->bcull_percent < cache->brun_percent &&
 	       cache->brun_percent  < 100);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
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

