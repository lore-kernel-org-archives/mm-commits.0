From: akpm@linux-foundation.org
Subject: [folded-merged] nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:17:10 -0700
Message-ID: <20130430221710.9821731C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58462 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761235Ab3D3WRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:17:12 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so113873qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:17:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Anthony2486@interfaces.org.uk, fengguang.wu@intel.com, freeboy6716@gmail.com, hermes@ceres.dti.ne.jp, konishi.ryusuke@lab.ntt.co.jp, slava@dubeyko.com, szarpaj@grubelek.pl, zahid.chowdhury@starsolutions.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch

This patch was dropped because it was folded into nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix

fix printk warning

Cc: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
Cc: Anthony Doggett <Anthony2486@interfaces.org.uk>
Cc: Elmer Zhang <freeboy6716@gmail.com>
Cc: Piotr Szymaniak <szarpaj@grubelek.pl>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Zahid Chowdhury <zahid.chowdhury@starsolutions.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/page.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix
+++ a/fs/nilfs2/page.c
@@ -426,7 +426,7 @@ void nilfs_clear_dirty_page(struct page
 			lock_buffer(bh);
 			if (!silent) {
 				nilfs_warning(sb, __func__,
-					"discard block %llu, size %lu",
+					"discard block %llu, size %zu",
 					(u64)bh->b_blocknr, bh->b_size);
 			}
 			clear_buffer_dirty(bh);
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
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

