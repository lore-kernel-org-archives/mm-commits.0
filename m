From: akpm@linux-foundation.org
Subject: [folded-merged] hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:17:34 -0700
Message-ID: <20130430221735.2740D31C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62164 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761294Ab3D3WRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:17:36 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so114263vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:17:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch

This patch was dropped because it was folded into hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix

make the workaround more explicit

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix
+++ a/fs/hfsplus/bfind.c
@@ -56,8 +56,8 @@ int hfs_find_1st_rec_by_cnid(struct hfs_
 				int *end,
 				int *cur_rec)
 {
-	__be32 cur_cnid = 0;
-	__be32 search_cnid = 0;
+	__be32 cur_cnid;
+	__be32 search_cnid;
 
 	if (bnode->tree->cnid == HFSPLUS_EXT_CNID) {
 		cur_cnid = fd->key->ext.cnid;
@@ -68,8 +68,11 @@ int hfs_find_1st_rec_by_cnid(struct hfs_
 	} else if (bnode->tree->cnid == HFSPLUS_ATTR_CNID) {
 		cur_cnid = fd->key->attr.cnid;
 		search_cnid = fd->search_key->attr.cnid;
-	} else
+	} else {
+		cur_cnid = 0;	/* used-uninitialized warning */
+		search_cnid = 0;
 		BUG();
+	}
 
 	if (cur_cnid == search_cnid) {
 		(*end) = (*cur_rec);
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
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

