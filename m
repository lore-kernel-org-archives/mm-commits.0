From: akpm@linux-foundation.org
Subject: [alternative-merged]
 fs-crypto-hooksc-fix-build-with-gcc-444.patch removed from -mm tree
Date: Fri, 02 Feb 2018 12:47:52 -0800
Message-ID: <20180202204752.Gi2CLmPvX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34330 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbeBBUr4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 15:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiggers@google.com, mm-commits@vger.kernel.org, tytso@mit.edu


The patch titled
     Subject: fs/crypto/hooks.c: fix build with gcc-4.4.4
has been removed from the -mm tree.  Its filename was
     fs-crypto-hooksc-fix-build-with-gcc-444.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/crypto/hooks.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with anon union initializers.  Work around this.

fs/crypto/hooks.c: In function '__fscrypt_encrypt_symlink':
fs/crypto/hooks.c:161: error: unknown field 'len' specified in initializer
fs/crypto/hooks.c:161: warning: excess elements in struct initializer
fs/crypto/hooks.c:161: warning: (near initialization for 'iname')

Fixes: 76e81d6d50 ("fscrypt: new helper functions for ->symlink()")
Cc: Eric Biggers <ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/crypto/hooks.c~fs-crypto-hooksc-fix-build-with-gcc-444 fs/crypto/hooks.c
--- a/fs/crypto/hooks.c~fs-crypto-hooksc-fix-build-with-gcc-444
+++ a/fs/crypto/hooks.c
@@ -158,7 +158,7 @@ int __fscrypt_encrypt_symlink(struct ino
 			      unsigned int len, struct fscrypt_str *disk_link)
 {
 	int err;
-	struct qstr iname = { .name = target, .len = len };
+	struct qstr iname = { { .hash_len = len, }, .name = target, };
 	struct fscrypt_symlink_data *sd;
 	unsigned int ciphertext_len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

